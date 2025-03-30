; 210_add-pointer.scm
; last modified/tested by Paul Sherman [gimphelp.org]
; Monday, 04/05/2021 on GIMP-2.10.24
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
;
; requires the following 20 PNGs to be in scripts/images subfolder:
;
; finger-point-left-color.png
; finger-point-left.png
; finger-point-right-color.png
; finger-point-right.png
; large-black-outline.png
; large-dark-glossy.png
; large-pointer.png
; large-white-outline.png
; mouse-click-circle-black.png
; mouse-click-circle.png
; pointer-blue.png
; pointer-click-light.png
; pointer-click-red.png
; pointer-click.png
; pointer-dark.png
; pointer-drag-and-drop-move.png
; pointer-drag-and-drop.png
; pointer-editor.png
; pointer-link-select.png
; pointer-normal-select.png

;==================================================
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

;==============================================================
; Original information 
; 
; Konstantin Beliakov <Konstantin.Belyakov@devexpress.com>
; Developer Express Inc.
; 2010/07/22
;==============================================================

(define (210-add-pointer image
				drawable
				drop-shadow
				pointer-type
	)
	
	

  (let* (

	(image-width (car (gimp-image-width image)))
	(image-height (car (gimp-image-height image)))
	(offset-x (/ image-width 2))
	(offset-y (/ image-height 2))
	(opacity 100)
	(opacity-decrement (/ opacity 4))
	(motion-step (/ 200 3))
	(reflections-counter 4)
	(layer (gimp-image-get-active-layer image))
	(shadow-transl-y (* 3 (sin (/ (- 180 120) 57.32))))
	(shadow-transl-x (* 3 (cos (/ (- 180 120) 57.32))))
        )

	(gimp-context-push)
	(gimp-image-set-active-layer image drawable)
	(gimp-image-undo-group-start image)

	

	(while (> reflections-counter 0)
		(if (= pointer-type 0)
		        (set! layer (car (gimp-file-load-layer 0 image (string-append gimp-data-directory DIR-SEPARATOR "scripts" DIR-SEPARATOR "images" DIR-SEPARATOR "pointer-normal-select.png"))))
		)
		(if (= pointer-type 1)
		        (set! layer (car (gimp-file-load-layer 0 image (string-append gimp-data-directory DIR-SEPARATOR "scripts" DIR-SEPARATOR "images" DIR-SEPARATOR "pointer-drag-and-drop.png"))))
		)
		(if (= pointer-type 2)
		        (set! layer (car (gimp-file-load-layer 0 image (string-append gimp-data-directory DIR-SEPARATOR "scripts" DIR-SEPARATOR "images" DIR-SEPARATOR "pointer-drag-and-drop-move.png"))))
		)
		(if (= pointer-type 3)
		        (set! layer (car (gimp-file-load-layer 0 image (string-append gimp-data-directory DIR-SEPARATOR "scripts" DIR-SEPARATOR "images" DIR-SEPARATOR "pointer-link-select.png"))))
		)

		(if (= pointer-type 4)
		        (set! layer (car (gimp-file-load-layer 0 image (string-append gimp-data-directory DIR-SEPARATOR "scripts" DIR-SEPARATOR "images" DIR-SEPARATOR "pointer-editor.png"))))
		)
		(if (= pointer-type 5)
		        (set! layer (car (gimp-file-load-layer 0 image (string-append gimp-data-directory DIR-SEPARATOR "scripts" DIR-SEPARATOR "images" DIR-SEPARATOR "pointer-dark.png"))))
		)
		(if (= pointer-type 6)
		        (set! layer (car (gimp-file-load-layer 0 image (string-append gimp-data-directory DIR-SEPARATOR "scripts" DIR-SEPARATOR "images" DIR-SEPARATOR "pointer-click.png"))))
		)
		(if (= pointer-type 7)
		        (set! layer (car (gimp-file-load-layer 0 image (string-append gimp-data-directory DIR-SEPARATOR "scripts" DIR-SEPARATOR "images" DIR-SEPARATOR "pointer-click-light.png"))))
		)
		(if (= pointer-type 8)
		        (set! layer (car (gimp-file-load-layer 0 image (string-append gimp-data-directory DIR-SEPARATOR "scripts" DIR-SEPARATOR "images" DIR-SEPARATOR "pointer-click-red.png"))))
		)
		(if (= pointer-type 9)
		        (set! layer (car (gimp-file-load-layer 0 image (string-append gimp-data-directory DIR-SEPARATOR "scripts" DIR-SEPARATOR "images" DIR-SEPARATOR "mouse-click-circle-black.png"))))
		)
		(if (= pointer-type 10)
		        (set! layer (car (gimp-file-load-layer 0 image (string-append gimp-data-directory DIR-SEPARATOR "scripts" DIR-SEPARATOR "images" DIR-SEPARATOR "mouse-click-circle.png"))))
		)
		(if (= pointer-type 11)
		        (set! layer (car (gimp-file-load-layer 0 image (string-append gimp-data-directory DIR-SEPARATOR "scripts" DIR-SEPARATOR "images" DIR-SEPARATOR "large-black-outline.png"))))
		)
		(if (= pointer-type 12)
		        (set! layer (car (gimp-file-load-layer 0 image (string-append gimp-data-directory DIR-SEPARATOR "scripts" DIR-SEPARATOR "images" DIR-SEPARATOR "large-dark-glossy.png"))))
		)
		(if (= pointer-type 13)
		        (set! layer (car (gimp-file-load-layer 0 image (string-append gimp-data-directory DIR-SEPARATOR "scripts" DIR-SEPARATOR "images" DIR-SEPARATOR "large-pointer.png"))))
		)
		(if (= pointer-type 14)
		        (set! layer (car (gimp-file-load-layer 0 image (string-append gimp-data-directory DIR-SEPARATOR "scripts" DIR-SEPARATOR "images" DIR-SEPARATOR "large-white-outline.png"))))
		)
		(if (= pointer-type 15)
		        (set! layer (car (gimp-file-load-layer 0 image (string-append gimp-data-directory DIR-SEPARATOR "scripts" DIR-SEPARATOR "images" DIR-SEPARATOR "pointer-blue.png"))))
		)
		(if (= pointer-type 16)
		        (set! layer (car (gimp-file-load-layer 0 image (string-append gimp-data-directory DIR-SEPARATOR "scripts" DIR-SEPARATOR "images" DIR-SEPARATOR "finger-point-left.png"))))
		)
		(if (= pointer-type 17)
		        (set! layer (car (gimp-file-load-layer 0 image (string-append gimp-data-directory DIR-SEPARATOR "scripts" DIR-SEPARATOR "images" DIR-SEPARATOR "finger-point-left-color.png"))))
		)
		(if (= pointer-type 18)
		        (set! layer (car (gimp-file-load-layer 0 image (string-append gimp-data-directory DIR-SEPARATOR "scripts" DIR-SEPARATOR "images" DIR-SEPARATOR "finger-point-right.png"))))
		)
		(if (= pointer-type 19)
		        (set! layer (car (gimp-file-load-layer 0 image (string-append gimp-data-directory DIR-SEPARATOR "scripts" DIR-SEPARATOR "images" DIR-SEPARATOR "finger-point-right-color.png"))))
		)
	        (gimp-layer-set-offsets layer offset-x offset-y)
		(gimp-image-insert-layer image layer 0 -1)
		;(gimp-image-resize-to-layers image)
		(if (= drop-shadow TRUE)
		(begin
			(script-fu-drop-shadow image 
					;(car (gimp-image-get-active-layer image))
					layer
					shadow-transl-x
					shadow-transl-y
					3
					"black"
					66
					TRUE)
				
			(gimp-image-merge-down image 
				;(car (gimp-image-get-active-layer image))
				layer
				 0)
		)
		)
		(gimp-layer-set-opacity (car (gimp-image-get-active-layer image)) opacity)
		(gimp-item-set-name (car (gimp-image-get-active-drawable image)) "Pointer")
 		(set! reflections-counter (- reflections-counter 1))
		(set! offset-x (+ offset-x (* motion-step (sin (/ (- 15 90) 57.2958)))))
		(set! offset-y (+ offset-y (* motion-step (cos (/ (- 15 90) 57.2958)))))
		(set! opacity (- opacity opacity-decrement))
		(set! reflections-counter 0)
	 )

	(gimp-image-undo-group-end image)
	(gimp-displays-flush)
	(gimp-context-pop)
	
); end let
); end define
(script-fu-register "210-add-pointer"
	"Add-Pointer"
	"Adds pointer to image and applies effects to it."
	"Konstantin Beliakov <Konstantin.Belyakov@devexpress.com>"
	"Developer Express Inc."
	"2010/07/22"
	"RGB* GRAY*"
	SF-IMAGE      "Image"                                0
	SF-DRAWABLE   "Drawable"                             0
	SF-TOGGLE     "Add pointer shadow"  	             TRUE
	SF-OPTION     "Pointer type"      					'("Normal pointer" "Drag&Drop" "Drag&Drop/Move" "Hand Point" "Editor" "Pointer Dark" "Pointer Click" "Pointer Click Light" "Pointer Click Red" "Mouse-Click Circle Black" "Mouse-Click Circle" "large Black Outline" "large Black Glossy" "Extra-Large Pointer" "Large White Outline" "Blue Pointer" "Finger Point Left" "Finger Point Left Color" "Finger Point Right" "Finger Point Right Color")
)
(script-fu-menu-register "210-add-pointer" "<Image>/Script-Fu")
