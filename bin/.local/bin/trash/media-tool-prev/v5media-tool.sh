#!/bin/bash

# Ensure an input file is passed
if [ -z "$1" ] || [ ! -f "$1" ]; then
    echo "Usage: $0 <input_file>"
    exit 1
fi

INPUT_FILE="$1"

# Safely extract directory, filename, and extension
DIR_NAME=$(dirname "$INPUT_FILE")
BASE_NAME=$(basename "$INPUT_FILE")

if [[ "$BASE_NAME" == *.* ]]; then
    FILENAME_NO_EXT="${BASE_NAME%.*}"
    EXTENSION="${BASE_NAME##*.}"
    # Convert extension to lowercase for easier matching
    EXTENSION=$(echo "$EXTENSION" | tr '[:upper:]' '[:lower:]')
else
    FILENAME_NO_EXT="$BASE_NAME"
    EXTENSION=""
fi

OUTPUT_FILE=""

# --- Smart File Type Detection ---
FILE_TYPE="UNKNOWN"
if [[ "$EXTENSION" =~ ^(jpg|jpeg|png|webp|gif|tiff)$ ]]; then
    FILE_TYPE="IMAGE"
elif [[ "$EXTENSION" =~ ^(mp4|mkv|avi|mov|webm|flv)$ ]]; then
    FILE_TYPE="VIDEO"
else
    echo "Error: Unsupported file type ($EXTENSION)."
    exit 1
fi

# --- Dependency Check ---
if [ "$FILE_TYPE" == "IMAGE" ]; then
    DEPS=(magick webpinfo whiptail exiftool)
else
    DEPS=(ffmpeg ffprobe whiptail)
fi

for cmd in "${DEPS[@]}"; do
    if ! command -v "$cmd" &> /dev/null; then
        echo "Error: Required command '$cmd' is missing." >&2
        exit 1
    fi
done

# --- Helper function to run and print commands ---
execute_command() {
    echo -e "\n[Running Command]:\n  $*\n"
    "$@"
}

# ==========================================
#              VIDEO TUI LOGIC
# ==========================================

show_video_main_menu() {
    whiptail --title "Video Processing TUI" --menu "Select an operation for: $BASE_NAME" 17 55 5 \
        "TRANSCODE" "Convert Format & Codec..." \
        "COMPRESS" "Smart Target Size Compression..." \
        "AUDIO_EXT" "Extract Audio Only..." \
        "MUTE" "Remove Audio (Mute Video)" \
        3>&1 1>&2 2>&3
}

show_video_transcode_menu() {
    whiptail --title "Video Transcoding" --menu "Select Target Format" 16 60 5 \
        "MP4_H264" "MP4 (H.264) - Maximum Compatibility" \
        "MP4_HEVC" "MP4 (H.265/HEVC) - Best Size/Quality" \
        "WEBM_VP9" "WEBM (VP9) - Web Standard" \
        "MKV_COPY" "MKV (Copy) - Instant Remux, No Quality Loss" \
        3>&1 1>&2 2>&3
}

show_video_compress_menu() {
    whiptail --title "Smart Video Compression" --menu "Select Target File Size" 16 60 5 \
        "8" "8 MB (Discord Basic limit)" \
        "25" "25 MB (Discord Nitro / Email limit)" \
        "50" "50 MB (Standard Web limit)" \
        "100" "100 MB" \
        "CUSTOM" "Enter custom size in MB..." \
        3>&1 1>&2 2>&3
}

process_video() {
    MAIN_CHOICE=$(show_video_main_menu)
    [ -z "$MAIN_CHOICE" ] && exit 0

    case "$MAIN_CHOICE" in
        TRANSCODE)
            SUB_CHOICE=$(show_video_transcode_menu)
            [ -z "$SUB_CHOICE" ] && exit 0
            
            case "$SUB_CHOICE" in
                MP4_H264)
                    OUTPUT_FILE="${DIR_NAME}/${FILENAME_NO_EXT}_h264.mp4"
                    execute_command ffmpeg -i "$INPUT_FILE" -c:v libx264 -preset fast -crf 23 -c:a aac -b:a 128k "$OUTPUT_FILE"
                    ;;
                MP4_HEVC)
                    OUTPUT_FILE="${DIR_NAME}/${FILENAME_NO_EXT}_hevc.mp4"
                    execute_command ffmpeg -i "$INPUT_FILE" -c:v libx265 -preset fast -crf 26 -c:a aac -b:a 128k "$OUTPUT_FILE"
                    ;;
                WEBM_VP9)
                    OUTPUT_FILE="${DIR_NAME}/${FILENAME_NO_EXT}_vp9.webm"
                    execute_command ffmpeg -i "$INPUT_FILE" -c:v libvpx-vp9 -crf 30 -b:v 0 -c:a libopus "$OUTPUT_FILE"
                    ;;
                MKV_COPY)
                    OUTPUT_FILE="${DIR_NAME}/${FILENAME_NO_EXT}_remux.mkv"
                    execute_command ffmpeg -i "$INPUT_FILE" -c copy "$OUTPUT_FILE"
                    ;;
            esac
            ;;
            
        COMPRESS)
            SUB_CHOICE=$(show_video_compress_menu)
            [ -z "$SUB_CHOICE" ] && exit 0
            
            if [ "$SUB_CHOICE" = "CUSTOM" ]; then
                TARGET_MB=$(whiptail --inputbox "Enter target size in MB (e.g. 15):" 8 40 3>&1 1>&2 2>&3)
                [ -z "$TARGET_MB" ] && exit 0
            else
                TARGET_MB="$SUB_CHOICE"
            fi
            
            # Smart Compression Math
            DURATION=$(ffprobe -v error -show_entries format=duration -of default=noprint_wrappers=1:nokey=1 "$INPUT_FILE" | awk '{print int($1+0.5)}')
            
            if [ -z "$DURATION" ] || [ "$DURATION" -eq 0 ]; then
                echo "Error: Could not determine video duration."
                exit 1
            fi
            
            TOTAL_BITRATE=$(( (TARGET_MB * 8192) / DURATION ))
            AUDIO_BITRATE=128
            VIDEO_BITRATE=$(( TOTAL_BITRATE - AUDIO_BITRATE ))
            
            if [ "$VIDEO_BITRATE" -lt 100 ]; then
                whiptail --msgbox "Error: Target size is too small for a video of this length. The quality would be unwatchable." 8 50
                exit 1
            fi
            
            OUTPUT_FILE="${DIR_NAME}/${FILENAME_NO_EXT}_${TARGET_MB}MB.mp4"
            
            whiptail --msgbox "Calculated Video Bitrate: ${VIDEO_BITRATE}k\nCalculated Audio Bitrate: ${AUDIO_BITRATE}k\n\nPress OK to begin compression. This may take a while." 10 50
            execute_command ffmpeg -i "$INPUT_FILE" -c:v libx264 -b:v "${VIDEO_BITRATE}k" -maxrate "${VIDEO_BITRATE}k" -bufsize "$((VIDEO_BITRATE * 2))k" -c:a aac -b:a "${AUDIO_BITRATE}k" "$OUTPUT_FILE"
            ;;
            
        AUDIO_EXT)
            OUTPUT_FILE="${DIR_NAME}/${FILENAME_NO_EXT}_audio.mp3"
            execute_command ffmpeg -i "$INPUT_FILE" -q:a 0 -map a "$OUTPUT_FILE"
            ;;
            
        MUTE)
            OUTPUT_FILE="${DIR_NAME}/${FILENAME_NO_EXT}_muted.${EXTENSION}"
            # -c:v copy prevents rendering time, -an tells ffmpeg to drop the audio completely
            execute_command ffmpeg -i "$INPUT_FILE" -c:v copy -an "$OUTPUT_FILE"
            ;;
    esac
}

# ==========================================
#              IMAGE TUI LOGIC
# ==========================================

show_image_main_menu() {
    whiptail --title "Image Processing TUI" --menu "Select an operation for: $BASE_NAME" 16 55 4 \
        "COMP" "Compression & Quality Menu..." \
        "RESIZE" "Resize & Dimensions Menu..." \
        "CONV" "Convert Format Menu..." \
        "STRIP" "Strip Metadata (ExifTool)" \
        3>&1 1>&2 2>&3
}

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
        "1920x1080" "Resize at 1920x1080 px" \
        "800x600" "Resize at 800x600 px" \
        3>&1 1>&2 2>&3
}

show_convert_menu() {
    whiptail --title "Conversion Options" --menu "Select Target Format" 18 55 10 \
        "GIF" "Convert to GIF" \
        "JPEG" "Convert to JPEG" \
        "PNG" "Convert to PNG" \
        "WEBP" "Convert to WEBP" \
        "PDF" "Convert to PDF" \
        3>&1 1>&2 2>&3
}

process_image() {
    MAIN_CHOICE=$(show_image_main_menu)
    [ -z "$MAIN_CHOICE" ] && exit 0

    case "$MAIN_CHOICE" in
        COMP)
            SUB_CHOICE=$(show_compression_menu)
            [ -z "$SUB_CHOICE" ] && exit 0
            if [ "$SUB_CHOICE" = "CUSTOM" ]; then
                SUB_CHOICE=$(whiptail --inputbox "Enter custom quality (1-100):" 8 40 3>&1 1>&2 2>&3)
                [ -z "$SUB_CHOICE" ] && exit 0
            fi
            CLEAN_SUF=$(echo "$SUB_CHOICE" | tr -d '%')
            OUTPUT_FILE="${DIR_NAME}/${FILENAME_NO_EXT}_compressed_${CLEAN_SUF}.${EXTENSION}"
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
            OUTPUT_FILE="${DIR_NAME}/${FILENAME_NO_EXT}_resized_${CLEAN_SUF}.${EXTENSION}"
            execute_command magick "$INPUT_FILE" -resize "$SUB_CHOICE" "$OUTPUT_FILE"
            ;;
            
        CONV)
            SUB_CHOICE=$(show_convert_menu)
            [ -z "$SUB_CHOICE" ] && exit 0
            case "$SUB_CHOICE" in
                GIF)   OUTPUT_FILE="${DIR_NAME}/${FILENAME_NO_EXT}_converted.gif"; execute_command magick "$INPUT_FILE" "$OUTPUT_FILE" ;;
                JPEG)  OUTPUT_FILE="${DIR_NAME}/${FILENAME_NO_EXT}_converted.jpg"; execute_command magick "$INPUT_FILE" "$OUTPUT_FILE" ;;
                PNG)   OUTPUT_FILE="${DIR_NAME}/${FILENAME_NO_EXT}_converted.png"; execute_command magick "$INPUT_FILE" "$OUTPUT_FILE" ;;
                WEBP)  OUTPUT_FILE="${DIR_NAME}/${FILENAME_NO_EXT}_converted.webp"; execute_command magick "$INPUT_FILE" "$OUTPUT_FILE" ;;
                PDF)   OUTPUT_FILE="${DIR_NAME}/${FILENAME_NO_EXT}_converted.pdf"; execute_command magick "$INPUT_FILE" "$OUTPUT_FILE" ;;
            esac
            ;;
            
        STRIP)
            OUTPUT_FILE="${DIR_NAME}/${FILENAME_NO_EXT}_stripped.${EXTENSION}"
            execute_command cp "$INPUT_FILE" "$OUTPUT_FILE"
            execute_command exiftool -all= -overwrite_original "$OUTPUT_FILE"
            ;;
    esac
}

# ==========================================
#              MAIN EXECUTION
# ==========================================

if [ "$FILE_TYPE" == "VIDEO" ]; then
    process_video
elif [ "$FILE_TYPE" == "IMAGE" ]; then
    process_image
fi

# WebP Verification Check (for images)
if [ -n "$OUTPUT_FILE" ] && [[ "$OUTPUT_FILE" =~ \.webp$ ]] && [ -f "$OUTPUT_FILE" ]; then
    echo -e "\n[Running Verification Checking]:\n  webpinfo \"$OUTPUT_FILE\""
    webpinfo "$OUTPUT_FILE" > /dev/null
fi

if [ -n "$OUTPUT_FILE" ] && [ -f "$OUTPUT_FILE" ]; then
    echo -e "\nOperation complete! File saved as: $OUTPUT_FILE"
fi
