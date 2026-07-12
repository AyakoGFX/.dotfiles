#!/bin/bash

# Ensure an input file is passed
if [ -z "$1" ] || [ ! -f "$1" ]; then
    echo "Usage: $0 <input_image>"
    exit 1
fi

INPUT_FILE="$1"

# Safely extract directory, filename, and extension (handles files without extensions cleanly)
DIR_NAME=$(dirname "$INPUT_FILE")
BASE_NAME=$(basename "$INPUT_FILE")

if [[ "$BASE_NAME" == *.* ]]; then
    FILENAME_NO_EXT="${BASE_NAME%.*}"
    EXTENSION=".${BASE_NAME##*.}"
else
    FILENAME_NO_EXT="$BASE_NAME"
    EXTENSION=""
fi

# Initialize output file variable
OUTPUT_FILE=""

# --- Dependency Check ---
for cmd in magick webpinfo whiptail exiftool; do
    if ! command -v "$cmd" &> /dev/null; then
        echo "Error: Required command '$cmd' is missing." >&2
        exit 1
    fi
done

# --- Main Menu Options ---
show_main_menu() {
    whiptail --title "Image Processing TUI" --menu "Select an operation for: $BASE_NAME" 16 55 4 \
        "COMP" "Compression & Quality Menu..." \
        "RESIZE" "Resize & Dimensions Menu..." \
        "CONV" "Convert Format Menu..." \
        "STRIP" "Strip Metadata (ExifTool)" \
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
        "B64" "Convert to Base64" \
        "FAV" "Generate favicons" \
        3>&1 1>&2 2>&3
}

# --- Helper function to run and print commands ---
execute_command() {
    echo -e "\n[Running Command]:\n  $*\n"
    "$@"
}

# --- Execution Engine ---
MAIN_CHOICE=$(show_main_menu)

case "$MAIN_CHOICE" in
    COMP)
        SUB_CHOICE=$(show_compression_menu)
        [ -z "$SUB_CHOICE" ] && exit 0

        if [ "$SUB_CHOICE" = "CUSTOM" ]; then
            SUB_CHOICE=$(whiptail --inputbox "Enter custom quality (1-100):" 8 40 3>&1 1>&2 2>&3)
            [ -z "$SUB_CHOICE" ] && exit 0
        fi

        CLEAN_SUF=$(echo "$SUB_CHOICE" | tr -d '%')
        OUTPUT_FILE="${DIR_NAME}/${FILENAME_NO_EXT}_compressed_${CLEAN_SUF}${EXTENSION}"

        execute_command magick "$INPUT_FILE" -quality "${CLEAN_SUF}%" "$OUTPUT_FILE"
        ;;

    RESIZE)
        SUB_CHOICE=$(show_resize_menu)
        [ -z "$SUB_CHOICE" ] && exit 0

        if [ "$SUB_CHOICE" = "CUSTOM" ]; then
            SUB_CHOICE=$(whiptail --inputbox "Enter size (e.g. 800x600 or 40%):" 8 40 3>&1 1>&2 2>&3)
            [ -z "$SUB_CHOICE" ] && exit 0
        fi

        CLEAN_SUF=$(echo "$SUB_CHOICE" | tr -d '%')
        OUTPUT_FILE="${DIR_NAME}/${FILENAME_NO_EXT}_resized_${CLEAN_SUF}${EXTENSION}"

        execute_command magick "$INPUT_FILE" -resize "$SUB_CHOICE" "$OUTPUT_FILE"
        ;;

    CONV)
        SUB_CHOICE=$(show_convert_menu)
        [ -z "$SUB_CHOICE" ] && exit 0

        case "$SUB_CHOICE" in
            GIF)   OUTPUT_FILE="${DIR_NAME}/${FILENAME_NO_EXT}_converted.gif"; execute_command magick "$INPUT_FILE" "$OUTPUT_FILE" ;;
            JPEG)  OUTPUT_FILE="${DIR_NAME}/${FILENAME_NO_EXT}_converted.jpg"; execute_command magick "$INPUT_FILE" "$OUTPUT_FILE" ;;
            PNG)   OUTPUT_FILE="${DIR_NAME}/${FILENAME_NO_EXT}_converted.png"; execute_command magick "$INPUT_FILE" "$OUTPUT_FILE" ;;
            TIFF)  OUTPUT_FILE="${DIR_NAME}/${FILENAME_NO_EXT}_converted.tiff"; execute_command magick "$INPUT_FILE" "$OUTPUT_FILE" ;;
            WEBP)  OUTPUT_FILE="${DIR_NAME}/${FILENAME_NO_EXT}_converted.webp"; execute_command magick "$INPUT_FILE" "$OUTPUT_FILE" ;;
            PDF)   OUTPUT_FILE="${DIR_NAME}/${FILENAME_NO_EXT}_converted.pdf"; execute_command magick "$INPUT_FILE" "$OUTPUT_FILE" ;;
            PDF-A) OUTPUT_FILE="${DIR_NAME}/${FILENAME_NO_EXT}_converted_pdfa.pdf"; execute_command magick "$INPUT_FILE" -colorspace sRGB -type truecolor "$OUTPUT_FILE" ;;
            B64)   OUTPUT_FILE="${INPUT_FILE}.b64"; echo -e "\n[Running Command]:\n  base64 \"$INPUT_FILE\" > \"$OUTPUT_FILE\"\n"; base64 "$INPUT_FILE" > "$OUTPUT_FILE" ;;
            FAV)   OUTPUT_FILE="${DIR_NAME}/favicon.ico"; execute_command magick "$INPUT_FILE" -define icon:auto-resize=64,48,32,16 "$OUTPUT_FILE" ;;
            *) exit 0 ;;
        esac
        ;;

    STRIP)
        OUTPUT_FILE="${DIR_NAME}/${FILENAME_NO_EXT}_stripped${EXTENSION}"
        # Clone the original file first so ExifTool can strip the copy safely
        execute_command cp "$INPUT_FILE" "$OUTPUT_FILE"
        execute_command exiftool -all= -overwrite_original "$OUTPUT_FILE"
        ;;
    *)
        exit 0
        ;;
esac

# WebP Verification Check (only triggers if an output file exists and ends with .webp)
if [ -n "$OUTPUT_FILE" ] && [[ "$OUTPUT_FILE" =~ \.webp$ ]] && [ -f "$OUTPUT_FILE" ]; then
    echo -e "\n[Running Verification Checking]:\n  webpinfo \"$OUTPUT_FILE\""
    webpinfo "$OUTPUT_FILE" > /dev/null
fi

if [ -n "$OUTPUT_FILE" ] && [ -f "$OUTPUT_FILE" ]; then
    echo -e "\nOperation complete! File saved as: $OUTPUT_FILE"
fi
