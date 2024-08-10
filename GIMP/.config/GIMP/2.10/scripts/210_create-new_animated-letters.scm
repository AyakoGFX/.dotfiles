; 210_create-new_animated-letters.scm
; last modified/tested by Paul Sherman [gimphelp.org]
; Wednesday, 07/01/2020  on GIMP 2.10.20
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
;==============================================================
; Original information 
; Lotr Letter Drop rel 0.03
; Created by Graechan combining SaulGoodes 'Letter Drop' and Fenceposts 'Lotr' Scripts as Requested by PhotoComix
; Comments directed to http://gimpchat.com or http://gimpscripts.com
;
; License: GPLv3
;    This program is free software: you can redistribute it and/or modify
;    it under the terms of the GNU General Public License as published by
;    the Free Software Foundation, either version 3 of the License, or
;    (at your option) any later version.
;
;    This program is distributed in the hope that it will be useful,
;    but WITHOUT ANY WARRANTY; without even the implied warranty of
;    MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE. See the
;    GNU General Public License for more details.
;
;    To view a copy of the GNU General Public License
;    visit: http://www.gnu.org/licenses/gpl.html
;
;
; ------------
;| Change Log |
; ------------ 
; Rel 0.01 - Initial Release
; Rel 0.02 - Bugfix for error with 'using color from gradient'
; Rel 0.03 - Added apply a 'Simple-Border' as an option
;
;==============================================================
; Original Original information 
; 
; Letter Drop script for GIMP 2.4
; Original author: Saul Goode
; Tags: animation
; Author statement:
; Based on the PERL plug-in "Impact Letters" by Ky McPherson
;
; 19.12.2007 - Added support for transparent background - Alexia Death
;==============================================================
;
; Include layer Procedure
(define (include-layer image newlayer oldlayer stack)	;stack 0=above 1=below
	(cond ((defined? 'gimp-image-get-item-position) ;test for 2.8 compatability
            (gimp-image-insert-layer image newlayer (car (gimp-item-get-parent oldlayer)) 
			(+ (car (gimp-image-get-item-position image oldlayer)) stack))                                     ;For GIMP 2.8 
          )
          (else
           (gimp-image-add-layer image newlayer (+ (car (gimp-image-get-layer-position image oldlayer)) stack)) ;For GIMP 2.6 
          )
    ) ;end cond
) ;end include layer procedure
;
(define (210-letter-drop
                        text 
						FGcolor 
						BGcolor
                        alpha_bg 
						font 
						letter-delay 
						word-delay 
						start-size 
						end-size 
						frames-per-letter 
						opacity 
						geometric 
						use-gradient 
						gradient
						bla
						deh
						dah
		)

 (let* (
            (ver 2.8)
			(image 0)
			(visible 0)
			(pasted 0)
			(width 0) 
			(height 0)
			(layerList 0)
			(layerId 0)
			(bkg-layerName (string-append "Background (" (number->string word-delay 10 0 0) "ms) (replace)"))
			(layerText "")
			(background 0)			
        )
	(cond ((not (defined? 'gimp-image-get-item-position)) (set! ver 2.6))) ;define the gimp version
	
    (gimp-context-set-paint-method "gimp-paintbrush")
	(cond ((defined? 'gimp-context-set-dynamics) (gimp-context-set-dynamics "Dynamics Off")))
    (gimp-context-set-foreground '(0 0 0))
	(gimp-context-set-background '(255 255 255))


;;;;begin the script
;;;;create the layers using 'Letter Drop' sript	
	(set! image (car (the-letter-drop text '(0 0 0) BGcolor TRUE font letter-delay word-delay 
	start-size end-size frames-per-letter opacity geometric use-gradient gradient)))
;;;;set the image size	
	(set! visible (car (gimp-layer-new image (car (gimp-image-width image)) (car (gimp-image-height image)) RGBA-IMAGE "Visible" 100 NORMAL-MODE)))
    (gimp-image-add-layer image visible 0)
	(gimp-edit-copy-visible image)
	(set! pasted (car (gimp-edit-paste visible FALSE)))
	(gimp-floating-sel-anchor pasted)	
	(plug-in-autocrop 1 image visible)	
	(gimp-image-remove-layer image visible)		
	(set! width (car (gimp-image-width image)))
    (set! height (car (gimp-image-height image)))	
    (map (lambda (x) (gimp-layer-resize-to-image-size x)) (vector->list (cadr (gimp-image-get-layers image))))

;;;;apply the alph-to-Logo scripts   
     (set! layerList (vector->list (cadr (gimp-image-get-layers image))))  
     (while (not (null? layerList))
     (set! layerId (car layerList))
     (set! layerText (car (gimp-drawable-get-name layerId))) 
     (cond ((string=? layerText bkg-layerName)
	       (set! background (car (gimp-layer-new image width height RGBA-IMAGE "background" 100 NORMAL-MODE)))
		   (include-layer image background layerId 1)	;stack 0=above 1=below
		   (if (= alpha_bg FALSE) (begin
		   (gimp-context-set-background BGcolor)
		   (gimp-drawable-fill background BACKGROUND-FILL)))
		   (set! layerId (car (gimp-image-merge-down image layerId EXPAND-AS-NECESSARY)))
		   (gimp-drawable-set-name layerId layerText))
		   (else
	 	   (the-lotr-text image layerId use-gradient FGcolor 0 FALSE 3 3 5 '(0 0 0) 80 FALSE)
		   (set! layerId (car (gimp-image-get-active-layer image)))
	 	   (set! background (car (gimp-layer-new image width height RGBA-IMAGE "background" 100 NORMAL-MODE)))
		   (include-layer image background layerId 1)	;stack 0=above 1=below
		   (if (= alpha_bg FALSE) (begin
		   (gimp-context-set-background BGcolor)
		   (gimp-drawable-fill background BACKGROUND-FILL)))
		   (set! layerId (car (gimp-image-merge-down image layerId EXPAND-AS-NECESSARY)))
		   (gimp-drawable-set-name layerId layerText))
	 ) ;endcond
    (set! layerList (cdr layerList))
	 ) ;endwhile
	(file-gif-save 0 image layerId "Letter-Animation.gif" "Letter-Animation.gif" TRUE 0 0 0)
 )
) 








(define (the-letter-drop text FGcolor BGcolor alpha_bg font letter-delay word-delay start-size
  end-size frames-per-letter opacity geometric use-gradient gradient)
  ;; This function returns a list of floats evenly spaced in the range start to end
  (define (algebraic-prog start end elements)
    (let* (
      (cnt 1)
      (new-list ())
      )
      (if (= start 0)
        (set! new-list (list 0 (/ end (- elements 1))))
        (set! new-list (list 1 (+ 1 (/ (- (/ end start) 1) (- elements 1)))))
        )
      (while (< cnt (- elements 1))
        (set! new-list (append new-list (list (+ (- (cadr new-list) (car new-list)) (car (last new-list))))))
        (set! cnt (+ cnt 1))
        )
      (if (> start 0)
        (set! new-list (mapcar * new-list (make-list (length new-list) start)))
        )
      new-list
      )
    )
  ;; 'geometric-prog' returns a list of floats with each element being the product of a radix and the
  ;; preceding element
  (define (geometric-prog start end elements)
    (let* (
      (cnt 2)
      (new-list ())
      )
      (if (= start 0)
        (set! new-list '( 0 0))
        (set! new-list (list 1 (pow (/ end start) (/ (- elements 1))))) ;; nth root
        )
      (while (< cnt elements)
        (set! new-list (append new-list (list (* (cadr new-list) (car (last new-list))))))
        (set! cnt (+ cnt 1))
        )
      (set! new-list (mapcar * new-list (make-list (length new-list) start)))
      )
    )
  ;; This function breaks a word up into a list of characters
  (define (string->list word)
    (let* (
      (i 1)
      (chars (list (substring word 0 1)))
      )
      (while (< i (string-length word))
        (set! chars (append chars (list (substring word i (+ i 1)))))
        (set! i (+ i 1))
        )
      chars
      )
    )
  ;; This function determines the cell width and height for a character
  ;; It is passed two chars because of proportionally-spaced fonts.
  (define (char-width str font size)
    (set! str (string-append str "  ")) ;; just to be safe
    (- (car (gimp-text-get-extents-fontname (substring str 0 2) size PIXELS font))
       (car (gimp-text-get-extents-fontname (substring str 1 2) size PIXELS font))
       )
    )
  ;; This function returns a list with the "union-ed" extents of the passed rectangles)
  (define (update-bounds old-bounds new-bounds)
    (list
        (min (car old-bounds) (car new-bounds))
        (min (cadr old-bounds) (cadr new-bounds))
        (max (caddr old-bounds) (caddr new-bounds))
        (max (cadr (cddr old-bounds)) (cadr (cddr new-bounds)))
        )
    )

  (let* (
      (display 0)
      (FG-old (car (gimp-context-get-foreground)))
      (BG-old (car (gimp-context-get-background)))
      (GRAD-old (car (gimp-context-get-gradient)))
      (image 0)
      (count (* (string-length text) frames-per-letter))
      (i 0)
      (sizes ())
      (size 0)
      (words ())
      (word 0)
      (letter 0)
      (reds ())
      (red 0)
      (greens ())
      (green 0)
      (blues ())
      (blue 0)
      (first-width 0)
      (last-width 0)
      (curr-width 0)
      (win-width 0)
      (win-height 0)
      (start-height 0)
      (end-height 0)
      (x 0)
      (x-base 0)
      (y-base 0)
      (y-offsets 0)
      (y-offset 0)
      (layer 0)
      (tmp-layer 0)       ;; temporary layer
      (float-layer 0)  ;; another temporary layer
      (ref-layer 0) ;; Holds the bounds of the maximum char size for a given letter (at a point in time)
      (background 0)
      (src-layer 0) ;; Image of all the previous letters
      (max-width 0)  ;; Used to determine if ref-layer is growing in size
      (image-bounds '(99999 99999 0 0))
      (disposal 0)
      )
    ;; Create the image image (it will be too wide, but we can correct when we are finished drawing)
    (set! win-width (car (gimp-text-get-extents-fontname text end-size PIXELS font)))
    (set! start-height (cadr (gimp-text-get-extents-fontname text start-size PIXELS font)))
    (set! end-height (cadr (gimp-text-get-extents-fontname text end-size PIXELS font)))

    ;; widen the window enough for the BIG letter on each end
    (set! win-height (max start-height end-height))
    (set! first-width (char-width (substring text 0 2) font (max start-size end-size)))
    (if (> start-size end-size)
      (set! x-base (/ first-width 2))
      )

    (set! last-width
        (char-width (string-append (substring text (- (string-length text) 1)) " ") font (max start-size end-size))
        )

    (set! win-width (+ win-width first-width last-width))
    (set! image (car (gimp-image-new win-width win-height RGB)))
    ;; Create the layer
    (set! background (car (gimp-layer-new image win-width win-height RGBA-IMAGE
        (string-append "Background (" (number->string word-delay 10 0 0) "ms) (replace)")
        100 ;; opacity
        NORMAL-MODE ))
        )
    (gimp-image-add-layer image background 0)
    (gimp-context-set-background BGcolor)
    (if (= alpha_bg TRUE)
       (begin
          (gimp-drawable-fill background TRANSPARENT-FILL)
          (set! disposal "(replace)" )
       )
       (begin (gimp-drawable-fill background BACKGROUND-FILL) (set! disposal "(combine)" ))
    )
    (set! display (car (gimp-display-new image)))
    (gimp-image-undo-disable image)

    (set! word (set! words (strbreakup text " ")))
    (while (pair? word)
      (set! letter (car word))
      (while (> 0 (string-length letter))
        (set! letter (substring word 1 (string-length letter)))
        )
      (set! word (cdr word))
      )

    ;; compute all font sizes, colors and luminosities for the animation (one per frame)
    (if geometric
      (begin
        (if (= start-size 0)
          (set! start-size 1)
          )
        (set! sizes (geometric-prog start-size end-size frames-per-letter))
        )
      (set! sizes (algebraic-prog start-size end-size frames-per-letter))
      )
    (if (= use-gradient TRUE)
      (begin ;; gradient cycle; use algebraic progression to set luminosity
        (set! reds (algebraic-prog (car BGcolor) (car FGcolor) frames-per-letter))
        (set! greens (algebraic-prog (cadr BGcolor) (cadr FGcolor) frames-per-letter))
        (set! blues (algebraic-prog (caddr BGcolor) (caddr FGcolor) frames-per-letter))
        (gimp-context-set-gradient gradient)
        )
      (begin ;; no gradient cycle
        (set! reds (algebraic-prog (car FGcolor) (car FGcolor) frames-per-letter))
        (set! greens (algebraic-prog (cadr FGcolor) (cadr FGcolor) frames-per-letter))
        (set! blues (algebraic-prog (caddr FGcolor) (caddr FGcolor) frames-per-letter))
        )
      )
    (set! size (cdr sizes))
    (set! src-layer (car (gimp-layer-copy background 1)))
    (gimp-image-add-layer image src-layer -1)  ;;
    ;; Note: start-height and end-height remain the same for all characters of a given size
    ;;       therefore we can pre-calc these values into a list
    (set! y-base (/ win-height 2) )
    (set! y-offsets (list (- y-base (/ start-height 2))))
    (while (pair? size) ;; compute the y-offsets
      (set! y-offsets (append y-offsets (list (- y-base (/ (cadr (gimp-text-get-extents-fontname "A" (car size) PIXELS font)) 2)))))
      (set! size (cdr size))
      )
    ;; for each word
    (set! word words)
    (gimp-progress-init "Generating letters" display)
    (while (pair? word)
      (set! letter (string->list (car word)))
      ;; for each letter
      (while (pair? letter)
        (set! size sizes)
        (set! y-offset y-offsets)
        (set! red reds)
        (set! green greens)
        (set! blue blues)
        (set! max-width 0) ;; keep track of the biggest char in each frame
        (if (pair? (cdr letter))
          (set! x-base (+ x-base (/ (char-width (string-append (car letter) (cadr letter)) font end-size) 2)))
          (set! x-base (+ x-base (/ (char-width (string-append (car letter) " ") font end-size) 2)))
          )
        ;; for each frame
        (while (pair? size)
          (if (pair? (cdr letter))
            (set! curr-width (char-width (string-append (car letter) (cadr letter)) font (car size)))
            (set! curr-width (char-width (string-append (car letter) " ") font (car size))) ;; assume space at end of word
            )
          (set! x (- x-base (/ curr-width 2)))
          (gimp-context-set-foreground (list (car red) (car green) (car blue)))
          (set! layer (car (gimp-text-fontname image -1 x (car y-offset) (car letter) 0 TRUE (car size) PIXELS font)))

          ;; Convert the text layer to a "normal" layer
          (plug-in-autocrop-layer RUN-NONINTERACTIVE image layer)
          ;; Text layer is now a graphic layer (so "layer bounds" could be determined, is there another way?)
          (if (and (cdr size) (= use-gradient TRUE))
            (plug-in-gradmap RUN-NONINTERACTIVE image layer)
            )
          (if (> curr-width max-width)
            (begin
              (set! ref-layer layer)
              (set! max-width curr-width)
              )
            )
          (gimp-rect-select image
              (car (gimp-drawable-offsets ref-layer))
              (cadr (gimp-drawable-offsets ref-layer))
              (car (gimp-drawable-width ref-layer))
              (car (gimp-drawable-height ref-layer))
              CHANNEL-OP-REPLACE 0 0
              )
          (set! image-bounds (update-bounds image-bounds (cdr (gimp-selection-bounds image))))
          (set! tmp-layer (car (gimp-layer-copy src-layer 1)))
          (gimp-image-add-layer image tmp-layer -1)  ;;
          (if (= alpha_bg TRUE) (gimp-selection-all image));
          (set! float-layer (car (gimp-selection-float tmp-layer 0 0))) ;; strip out the selected region
          (gimp-floating-sel-to-layer float-layer) ;; into a new layer
          (gimp-image-remove-layer image tmp-layer) ;; This layer no longer needed
          (gimp-image-lower-layer image float-layer)
          (if (cdr size) ;; if not last frame
            (gimp-layer-set-opacity layer opacity)
            )
          (set! layer (car (gimp-image-merge-down image layer EXPAND-AS-NECESSARY)))  ;; layers should be same size
          (if (>= curr-width max-width) ;; update ref-layer if necessary
            (set! ref-layer layer)
            )
          (gimp-drawable-set-name layer (string-append (car word) "-" (number->string layer 10 0 0)
              "(" (number->string letter-delay 10 0 0) "ms) " disposal ""))
          (set! y-offset (cdr y-offset))
          (set! red (cdr red))
          (set! green (cdr green))
          (set! blue (cdr blue))
          (set! size (cdr size)) ;; next frame
          (set! i (+ 1 i))
          (gimp-progress-update (/ i count))
          )
        ;; we need to merge the layer with the previous src-layer
        (gimp-image-raise-layer-to-top image src-layer)
        (set! tmp-layer (car (gimp-layer-copy layer 1))) ;; duplicate the letter
        (gimp-image-add-layer image tmp-layer 0)        ;; and place it on top
        (set! src-layer (car (gimp-image-merge-down image tmp-layer EXPAND-AS-NECESSARY)))
        (set! max-width 0)
        (set! x-base (+ x-base (/ curr-width 2)))
        (set! letter (cdr letter))
        )
      (gimp-drawable-set-name layer (string-append (car word) "-" (number->string layer 10 0 0)
              "(" (number->string word-delay 10 0 0) "ms) " disposal ""))

      (set! x-base (+ x-base (/ curr-width 2))) ;; increment for space
      (set! word (cdr word))
      )
    (gimp-image-remove-layer image src-layer) ;; This layer no longer needed

    (gimp-image-resize image
        (- (caddr image-bounds) (car image-bounds))
        (- (cadr (cddr image-bounds)) (cadr image-bounds))
        (- (car image-bounds))
        (- (cadr image-bounds))
        )

    (gimp-image-undo-disable image)
    (gimp-context-set-gradient GRAD-old)
    (gimp-context-set-foreground FG-old )
    (gimp-context-set-background BG-old )
    (gimp-image-clean-all image)
	(list image)
    ) ;; end of LET*
  ) ;; end of program

(define (the-lotr-text  image
						drawable
						useColor
						desiredColor
						blendStyle
						addShadow
						offsetX                               
						offsetY
						blurRadius	
						shadowColor
						opacity
						keepBumpMap
        )
  
  ;Declare the Variables
	
	(let* (
        (theSelection 0)
		(bumpMapLayer 0)
		(originalLayer 0)
		(gradientType 0)
		(shadowLayer 0)
		(position 0)
      )

; Set up the script so that user settings can be reset after the script is run		

  (gimp-context-push)
  
; Start an Undo Group so script can be undone in one step  

  (gimp-image-undo-group-start image)

; Save any active selections to a channel so script can be run on whole layers and then turn off selection

  (set! theSelection (car (gimp-selection-save image)))
  (gimp-selection-none image)

; Set the active layer

  (gimp-image-set-active-layer image drawable)

; Assign the bumpMapLayer and originalLayer, add the originalLayer above the bumpMapLayer
; & add the layer name to bumpMapLayer.  Lock the transparency for both layers so that 
; fills will be added only to non-transparent areas.  Alpha to selection was tried for this
; script, but results weren't as good.  The bumpMapLayer and OriginalLayer are linked for
; later movement around the canvas if so desired.

  (set! bumpMapLayer (car (gimp-image-get-active-layer image)))
  (set! originalLayer (car (gimp-layer-copy bumpMapLayer TRUE)))
  (gimp-image-add-layer image originalLayer -1)
  (gimp-drawable-set-name bumpMapLayer "Bump Map Layer")
  (gimp-layer-set-lock-alpha originalLayer TRUE)
  (gimp-layer-set-lock-alpha bumpMapLayer TRUE)
  (gimp-layer-set-linked originalLayer TRUE)
  (gimp-layer-set-linked bumpMapLayer TRUE)
    
; Set the foreground/background colors

  (gimp-context-set-foreground '(255 255 255))
  (gimp-context-set-background '(0 0 0))

; Assign values to the Blend Style.  See tutorial for example output of each style.  Dimple
; appears to look the best and is set as the default.  Then fill the bumpMapLayer with the
; chosen fill type

  (if (= blendStyle 0)
      (set! gradientType 6)
  )
  (if (= blendStyle 1)
      (set! gradientType 7)
  )
  (if (= blendStyle 2)
	(set! gradientType 8)
  )

  (gimp-edit-blend bumpMapLayer FG-BG-RGB-MODE NORMAL-MODE gradientType 100 0 REPEAT-NONE FALSE TRUE 2 0.2 TRUE 0 0 1 1)

; Run the Sharpen plugin twice to enhance chisel effect.

  (plug-in-sharpen 1 image bumpMapLayer 50)
  (plug-in-sharpen 1 image bumpMapLayer 50)
  
; Set bumpMapLayer invisible  
  (gimp-drawable-set-visible bumpMapLayer FALSE)
  
; Set the originalLayer as active

  (gimp-image-set-active-layer image originalLayer)

; If user decides they want to work with the existing color of the text, the text color is left
; unchanged.  Otherwise, the color selected when the script is first run is set as the foreground
; color and used to fill the originalLayer

  (if (= useColor FALSE)
      (begin
      (gimp-context-set-foreground desiredColor)
      (gimp-edit-fill originalLayer FOREGROUND-FILL)
      )
  )

  
; The bump map plugin is run using the bumpMapLayer to give the originalLayer its chiseled look
  
  (plug-in-bump-map 1 image originalLayer bumpMapLayer 135 45 5 0 0 0 0 TRUE FALSE 0)

; If the user wants to keep the bumpMapLayer for later use, it will be kept in this step.
; Otherwise, the layer is deleted.  
  
  (if (= keepBumpMap FALSE)
      (gimp-image-remove-layer image bumpMapLayer)
  )

; If the user wants to add a drop shadow, the parameters entered in when the script was first
; run are put into the existing GIMP drop shadow script.  

  (if (= addShadow TRUE)
      (script-fu-drop-shadow image originalLayer offsetX offsetY blurRadius shadowColor opacity FALSE)
  )
 
; Determine the position of the shadowLayer in the stack and link it 
; to the bumpMapLayer and OriginalLayer for later movement around the canvas if so desired.

;(set! position (car (gimp-image-get-layer-position image originalLayer)))
;(set! shadowLayer (aref (cadr (gimp-image-get-layers image)) (+ position 1)))
;(gimp-image-set-active-layer image shadowLayer)
;(gimp-layer-set-linked shadowLayer TRUE)

; The original selection is reloaded and its channel is deleted
  
  (gimp-selection-load theSelection)
  (gimp-image-remove-channel image theSelection)

; The originalLayer is made active

  ;(gimp-image-set-active-layer image originalLayer)
  (gimp-layer-set-linked (car (gimp-image-get-active-layer image)) FALSE)
  
; Closes the undo group

  (gimp-image-undo-group-end image)

; Tells GIMP that a change has been made

  (gimp-displays-flush)

; Resets previous user settings  
(gimp-context-pop)
  )
)

(define (the-lotr-overlay-background image)
  ; get visible layers (bottom-to-top)
  (define (get-visibles image)
    (let loop ((layers (vector->list (cadr (gimp-image-get-layers image))))
               (visibles '()) )
      (if (null? layers)
        visibles
        (loop (cdr layers) 
              (if (zero? (car (gimp-drawable-get-visible (car layers))))
                visibles
                (cons (car layers) visibles) ) ) ) ) )
  (gimp-image-undo-group-start image)
  (let* ((layers (vector->list (cadr (gimp-image-get-layers image))))
         (visibles (get-visibles image))
         (bg-layer (car (last layers)))
         (orig-sel (car (gimp-selection-save image))) )
    (gimp-selection-none image)
    (map (lambda (x) (gimp-drawable-set-visible x FALSE)) visibles)
    (when (= (car visibles) bg-layer)
      (set! visibles (cdr visibles))
      (gimp-drawable-set-visible bg-layer TRUE) )
    (while (pair? visibles)
      (let* ((layer (car visibles))
             (position (car (gimp-image-get-layer-position image layer))) 
             (over-layer 0) )
        (gimp-drawable-set-visible layer TRUE)
        (gimp-image-set-active-layer image layer)
        (set! over-layer (car (gimp-layer-new-from-drawable bg-layer image)))
        (gimp-image-add-layer image over-layer -1)
        (gimp-drawable-set-visible over-layer TRUE)
        (gimp-image-merge-down image over-layer EXPAND-AS-NECESSARY) )
      (set! visibles (cdr visibles)) )
    (gimp-selection-load orig-sel)
    (gimp-image-remove-channel image orig-sel) )
  (gimp-image-undo-group-end image)
  (gimp-displays-flush)
  )

(script-fu-register "210-letter-drop"        		    
  "Letter Animation"
  "Combines Saulgoodes Letter Drop and Fenceposts Lotr Script"
  "Graechan"
  "Graechan - http://gimpchat.com"
  "Aug 2013"
  ""
    SF-STRING _"Text"
        "The GIMP"
    SF-COLOR _"Foreground"  ;;     "color to use for letter"
        '(0 0 0)
    SF-COLOR _"Background"  ;;     "color to use for background"
        '( 255 255 255 )
	SF-TOGGLE _"Transparent background";; "Wether to use transparency in stead of bg color"
        FALSE
    SF-FONT  _"Font"        ;;      "font"
        "Sans Bold"
    SF-ADJUSTMENT _"Letter delay";; "time delay between letter in a word"
        '( 100 0 5000 1 100 0 0)
    SF-ADJUSTMENT _"Word delay"  ;;  "additional time delay for the space between words"
        '( 300 0 5000 1 100 0 0 )
    SF-ADJUSTMENT _"Starting size" ;;"animated letter initial size"
        '( 400 6 440 1 12 0 0 )
    SF-ADJUSTMENT _"Ending size";;   "animated letter final size"
        '( 110 6 440 1 12 0 0 )
    SF-ADJUSTMENT _"Frames per letter";; "number of frames for each animated letter"
        '( 5 2 200 1 5 0 0 )
    SF-ADJUSTMENT _"Opacity" ;; Opacity of "moving" letters
        '( 100 0 100 1 5 0 0 )
    SF-TOGGLE _"Geometric Progression";; "Letter size doubles each step"
        FALSE  ;; Otherwise letter size increases linearly
    SF-TOGGLE _"Use Color from Gradient";; "Sweep colors from gradient during animation"
        FALSE
    SF-GRADIENT _"Color Gradient" ;; "Gradient to use"
        "Full saturation spectrum CW"
	SF-STRING 		"WHEN SAVING GIF" 				"Select \"As animation\""
	SF-STRING 		"FILE WILL BE SAVED" 			"into the users home directory"
	SF-STRING 		"AS" 							"\"Letter-Animation.gif\""
)

(script-fu-menu-register "210-letter-drop" "<Image>/Script-Fu/Create New")
