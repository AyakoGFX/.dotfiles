#!/bin/bash

# Ensure an input file is passed
if [ -z "$1" ] || [ ! -f "$1" ]; then
    echo "Usage: $0 <input_image>"
    exit 1
fi

INPUT_FILE="$1"
# Default output name if not specified by user later
OUTPUT_FILE="${INPUT_FILE%.*}_processed.${INPUT_FILE##*.}"

# --- Dependency Check ---
for cmd in magick jhead webpinfo whiptail; do
    if ! command -v "$cmd" &> /dev/null; then
        echo "Error: Required command '$cmd' is missing." >&2
        exit 1
    fi
done

# --- Main Menu Options ---
# Combines options from Screenshot_20260709_160745.png & Screenshot_20260709_160811.png
show_main_menu() {
    whiptail --title "Image Processing TUI" --menu "Select an operation for: $(basename "$INPUT_FILE")" 23 60 14 \
        "WEB" "Complete optimization for web" \
        "PROG" "Make progressive" \
        "COMP" "Compression & Quality Menu..." \
        "RESIZE" "Resize & Dimensions Menu..." \
        "CONV" "Convert Format Menu..." \
        "ROT" "Rotate & Flip Menu..." \
        3>&1 1>&2 2>&3
}

# --- Submenus ---
show_compression_menu() {
    whiptail --title "Compression Options" --menu "Select Quality" 15 50 6 \
        "50%" "Compress at 50%" \
        "70%" "Compress at 70%" \
        "75%" "Compress at 75%" \
        "80%" "Compress at 80%" \
        "90%" "Compress at 90%" \
        "CUSTOM" "Custom quality" \
        3>&1 1>&2 2>&3
}

show_resize_menu() {
    whiptail --title "Resize Options" --menu "Select Size" 20 60 12 \
        "25%" "Resize at 25%" \
        "50%" "Resize at 50%" \
        "75%" "Resize at 75%" \
        "CUSTOM" "Custom resize" \
        "1024x768" "Resize at 1024x768 px" \
        "1200x630" "Resize at 1200x630 px (Social OG)" \
        "1200x900" "Resize at 1200x900 px" \
        "1400x1050" "Resize at 1400x1050 px" \
        "1920x1080" "Resize at 1920x1080 px" \
        "300x225" "Resize at 300x225 px" \
        "600x450" "Resize at 600x450 px" \
        "640x480" "Resize at 640x480 px" \
        "800x600" "Resize at 800x600 px" \
        3>&1 1>&2 2>&3
}

show_convert_menu() {
    whiptail --title "Conversion Options" --menu "Select Target Format" 18 55 10 \
        "GIF" "Convert to GIF" \
        "JPEG" "Convert to JPEG" \
        "PNG" "Convert to PNG" \
        "TIFF" "Convert to TIFF" \
        "WEBP" "Convert to WEBP" \
        "PDF" "Convert to PDF" \
        "PDF-A" "Convert to PDF/A-1" \
        "ANIM_GIF" "Generate animated GIF" \
        "B64" "Convert to Base64" \
        "FAV" "Generate favicons" \
        3>&1 1>&2 2>&3
}

show_rotate_menu() {
    whiptail --title "Rotate & Flip Options" --menu "Select Rotation" 15 50 7 \
        "AUTO" "Auto-rotate with Exif" \
        "180" "Rotate 180°" \
        "-90" "Rotate (-90°)" \
        "90" "Rotate 90°" \
        "CUSTOM" "Rotate custom" \
        "FLIP_V" "Overturn vertically" \
        "FLIP_H" "Overturn horizontally" \
        3>&1 1>&2 2>&3
}

# --- Execution Engine ---
MAIN_CHOICE=$(show_main_menu)

case "$MAIN_CHOICE" in
    WEB)
        # Web optimization shortcut: compress, strip, and make progressive/optimized
        magick "$INPUT_FILE" -strip -interlace Plane -quality 80% "$OUTPUT_FILE"
        ;;
    PROG)
        magick "$INPUT_FILE" -interlace Plane "$OUTPUT_FILE"
        ;;
    COMP)
        SUB_CHOICE=$(show_compression_menu)
        if [ "$SUB_CHOICE" = "CUSTOM" ]; then
            SUB_CHOICE=$(whiptail --inputbox "Enter custom quality (1-100):" 8 40 3>&1 1>&2 2>&3)
            SUB_CHOICE="${SUB_CHOICE}%"
        fi
        [ -n "$SUB_CHOICE" ] && magick "$INPUT_FILE" -quality "$SUB_CHOICE" "$OUTPUT_FILE"
        ;;
    RESIZE)
        SUB_CHOICE=$(show_resize_menu)
        if [ "$SUB_CHOICE" = "CUSTOM" ]; then
            SUB_CHOICE=$(whiptail --inputbox "Enter size (e.g. 800x600 or 40%):" 8 40 3>&1 1>&2 2>&3)
        fi
        [ -n "$SUB_CHOICE" ] && magick "$INPUT_FILE" -resize "$SUB_CHOICE" "$OUTPUT_FILE"
        ;;
    CONV)
        SUB_CHOICE=$(show_convert_menu)
        case "$SUB_CHOICE" in
            GIF) magick "$INPUT_FILE" "${INPUT_FILE%.*}.gif" ;;
            JPEG) magick "$INPUT_FILE" "${INPUT_FILE%.*}.jpg" ;;
            PNG) magick "$INPUT_FILE" "${INPUT_FILE%.*}.png" ;;
            TIFF) magick "$INPUT_FILE" "${INPUT_FILE%.*}.tiff" ;;
            WEBP) magick "$INPUT_FILE" "${INPUT_FILE%.*}.webp" ;;
            PDF) magick "$INPUT_FILE" "${INPUT_FILE%.*}.pdf" ;;
            PDF-A) magick "$INPUT_FILE" -colorspace sRGB -type truecolor "${INPUT_FILE%.*}.pdf" ;;
            B64) base64 "$INPUT_FILE" > "${INPUT_FILE}.b64" ;;
            FAV) magick "$INPUT_FILE" -define icon:auto-resize=64,48,32,16 favicon.ico ;;
            *) exit 0 ;;
        esac
        echo "Conversion Complete."
        exit 0
        ;;
    ROT)
        SUB_CHOICE=$(show_rotate_menu)
        case "$SUB_CHOICE" in
            AUTO) jhead -autorot "$INPUT_FILE" ;; # Modifies file in-place via EXIF
            180) magick "$INPUT_FILE" -rotate 180 "$OUTPUT_FILE" ;;
            -90) magick "$INPUT_FILE" -rotate 270 "$OUTPUT_FILE" ;;
            90) magick "$INPUT_FILE" -rotate 90 "$OUTPUT_FILE" ;;
            CUSTOM)
                DEGREE=$(whiptail --inputbox "Enter rotation degrees:" 8 40 3>&1 1>&2 2>&3)
                magick "$INPUT_FILE" -rotate "$DEGREE" "$OUTPUT_FILE"
                ;;
            FLIP_V) magick "$INPUT_FILE" -flip "$OUTPUT_FILE" ;;
            FLIP_H) magick "$INPUT_FILE" -flop "$OUTPUT_FILE" ;;
        esac
        ;;
    *)
        exit 0
        ;;
esac

# WebP Verification Check if output happens to be webp
if [[ "$OUTPUT_FILE" =~ \.webp$ ]] && [ -f "$OUTPUT_FILE" ]; then
    webpinfo "$OUTPUT_FILE" > /dev/null
fi

echo "Operation complete! Target processed file outputted."
