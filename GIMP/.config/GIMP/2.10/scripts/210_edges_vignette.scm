; 210_edges_photoframe.scm
; last modified/tested by Paul Sherman [gimphelp.org]
; Wednesday, 07/01/2020 on GIMP 2.10.20
;==================================================
;
; Installation:
; This script should be placed in the user or system-wide script folder.
;
;	Windows 7/10
;	C:\Program Files\GIMP 2\share\gimp\2.0\scripts
;	or
;	C:\Users\YOUR-NAME\AppData\Roaming\GIMP\2.10\scripts
;	
;    
;	Linux
;	/home/yourname/.config/GIMP/2.10/scripts  
;	or
;	Linux system-wide
;	/usr/share/gimp/2.0/scripts
;
;==================================================
; Edited on 12/01/2007 by Paul Sherman to fix UNDO functionality 
; when NOT working on a copy. Menu location also changed.
; tested on GIMP-2.4.1
; udated again for gimp-2.6 by Paul - 11/20/2008
; 12/15/2008 - 
; pulled use with alpha layer until I get it to behave - PS
; 10/15/2010 - fixed undo glitch that left stray "select all" if undone.

;
; LICENSE
;
;    This program is free software: you can redistribute it and/or modify
;    it under the terms of the GNU General Public License as published by
;    the Free Software Foundation, either version 3 of the License, or
;    (at your option) any later version.
;
;    This program is distributed in the hope that it will be useful,
;    but WITHOUT ANY WARRANTY; without even the implied warranty of
;    MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
;    GNU General Public License for more details.
;
;    You should have received a copy of the GNU General Public License
;    along with this program.  If not, see <http://www.gnu.org/licenses/>.
;
;==============================================================

; Original information
;
; The GIMP -- an image manipulation program
; Copyright (C) 1995 Spencer Kimball and Peter Mattis
; 
; Photo Frame script  for GIMP 2.4
; Original author: Alexios Chouchoulas
;
; Author statement:
; This is a rather simple script to produce a photographic frame
; around an image. This resembles a simplistic full-frame print: a
; thin black frame outlines the photograph itself, with thicker white
; borders around frame and picture. The colours and thicknesses are,
; of course, customisable.
;
; Written on top of Chris Gutteridge's (cjg@ecs.soton.ac.uk) Fuzzy
; Border script (which was only used as a template, but there you go).
;
; --------------------------------------------------------------------

;


(define (210-make-vignette size opacity img)
  (let* ((width (car (gimp-image-width img)))
         (height (car (gimp-image-height img)))
         (layer (car (gimp-layer-new img width height 0 "vignette" 100 DARKEN-ONLY-MODE))))
    (gimp-selection-clear img)
    (gimp-image-select-ellipse img 0 0 0 width height)
    (gimp-selection-feather img size)
    (gimp-selection-invert img)
    (gimp-layer-set-opacity layer opacity)
    (gimp-layer-add-mask layer (car (gimp-layer-create-mask layer ADD-SELECTION-MASK)))
    (gimp-selection-clear img)
    (gimp-image-insert-layer img layer 0 -1)))
 
(script-fu-register
  "210-make-vignette"
  "Vignette"
  "Create Vignette for the image"
  "Jakub Jankiewicz"
  "Copyright (c) 2017 Jakub Jankiewicz <http://jcubic.pl/me>"
  "May 20, 2017"
  RGB
  SF-VALUE "Size" "1000"
  SF-VALUE "Opacity" "50"
  SF-IMAGE "image" 0
)
(script-fu-menu-register "210-make-vignette" "<Image>/Script-Fu/Edges")
