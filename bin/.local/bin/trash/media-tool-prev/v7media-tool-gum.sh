#!/bin/bash

# Ensure an input file is passed
if [ -z "$1" ] || [ ! -f "$1" ]; then
    gum style --foreground 196 "Error: Please provide a valid input file."
    echo "Usage: $0 <input_file>"
    exit 1
fi

INPUT_FILE="$1"
DIR_NAME=$(dirname "$INPUT_FILE")
BASE_NAME=$(basename "$INPUT_FILE")

if [[ "$BASE_NAME" == *.* ]]; then
    FILENAME_NO_EXT="${BASE_NAME%.*}"
    EXTENSION="${BASE_NAME##*.}"
    EXTENSION=$(echo "$EXTENSION" | tr '[:upper:]' '[:lower:]')
else
    FILENAME_NO_EXT="$BASE_NAME"
    EXTENSION=""
fi

FILE_TYPE="UNKNOWN"
if [[ "$EXTENSION" =~ ^(jpg|jpeg|png|webp|gif|tiff)$ ]]; then FILE_TYPE="IMAGE";
elif [[ "$EXTENSION" =~ ^(mp4|mkv|avi|mov|webm|flv)$ ]]; then FILE_TYPE="VIDEO";
elif [[ "$EXTENSION" =~ ^(mp3|wav|flac|m4a|ogg|aac|opus)$ ]]; then FILE_TYPE="AUDIO";
else gum style --foreground 196 "Error: Unsupported file type ($EXTENSION)."; exit 1; fi

# Dependency Check
for cmd in ffmpeg ffprobe gum magick exiftool; do
    if ! command -v "$cmd" &> /dev/null; then
        gum style --foreground 196 "Error: Required command '$cmd' is missing."
        exit 1
    fi
done

# UI Helper
execute_command() {
    gum style --foreground 240 "Running: $*"
    "$@"
}

# --- Shared Navigation Handler ---
# This helper ensures hitting Esc/Cancel in a submenu goes back
# instead of exiting the entire script.
navigate_back() {
    [ -z "$1" ] && return 0 # Return 0 for success, meaning 'Go Back'
    [ "$1" == "<-- Back" ] && return 0
    return 1 # Return 1 if a real action was selected
}

# ==========================================
#              AUDIO TUI LOGIC
# ==========================================
process_audio() {
    local state="MAIN"
    while true; do
        case "$state" in
            MAIN)
                CHOICE=$(gum choose "Convert Format" "Compress (Change Bitrate)" "Normalize Volume" "Exit")
                [ -z "$CHOICE" ] && exit 0 # Exit only if on Main Menu
                case "$CHOICE" in
                    "Convert Format") state="CONV" ;;
                    "Compress (Change Bitrate)") state="COMP" ;;
                    "Normalize Volume") state="NORM" ;;
                    "Exit") exit 0 ;;
                esac
                ;;
            CONV)
                SUB=$(gum choose "MP3 (High Quality VBR)" "FLAC (Lossless)" "WAV (Uncompressed)" "OGG (Vorbis)" "M4A (AAC)" "<-- Back")
                navigate_back "$SUB" && state="MAIN" || {
                    case "$SUB" in
                        "MP3"*) OUTPUT_FILE="${DIR_NAME}/${FILENAME_NO_EXT}_converted.mp3"; execute_command ffmpeg -i "$INPUT_FILE" -q:a 2 "$OUTPUT_FILE"; return ;;
                        "FLAC"*) OUTPUT_FILE="${DIR_NAME}/${FILENAME_NO_EXT}_converted.flac"; execute_command ffmpeg -i "$INPUT_FILE" -c:a flac "$OUTPUT_FILE"; return ;;
                        "WAV"*) OUTPUT_FILE="${DIR_NAME}/${FILENAME_NO_EXT}_converted.wav"; execute_command ffmpeg -i "$INPUT_FILE" -c:a pcm_s16le "$OUTPUT_FILE"; return ;;
                        "OGG"*) OUTPUT_FILE="${DIR_NAME}/${FILENAME_NO_EXT}_converted.ogg"; execute_command ffmpeg -i "$INPUT_FILE" -c:a libvorbis -q:a 5 "$OUTPUT_FILE"; return ;;
                        "M4A"*) OUTPUT_FILE="${DIR_NAME}/${FILENAME_NO_EXT}_converted.m4a"; execute_command ffmpeg -i "$INPUT_FILE" -c:a aac -b:a 192k "$OUTPUT_FILE"; return ;;
                    esac
                }
                ;;
            COMP)
                SUB=$(gum choose "64k (Voice)" "128k (Standard Web)" "192k (Good Quality)" "256k (High Quality)" "320k (Max Quality)" "<-- Back")
                navigate_back "$SUB" && state="MAIN" || {
                    BITRATE=$(echo "$SUB" | awk '{print $1}')
                    OUTPUT_FILE="${DIR_NAME}/${FILENAME_NO_EXT}_${BITRATE}.mp3"
                    execute_command ffmpeg -i "$INPUT_FILE" -c:a libmp3lame -b:a "$BITRATE" "$OUTPUT_FILE"
                    return
                }
                ;;
            NORM)
                OUTPUT_FILE="${DIR_NAME}/${FILENAME_NO_EXT}_normalized.${EXTENSION}"
                execute_command ffmpeg -i "$INPUT_FILE" -af "loudnorm=I=-16:TP=-1.5:LRA=11" "$OUTPUT_FILE"
                return
                ;;
        esac
    done
}

# ==========================================
#              VIDEO TUI LOGIC
# ==========================================
process_video() {
    local state="MAIN"
    while true; do
        case "$state" in
            MAIN)
                CHOICE=$(gum choose "Convert Format & Codec" "Smart Target Size Compression" "Extract Audio Only" "Remove Audio (Mute Video)" "Exit")
                [ -z "$CHOICE" ] && exit 0
                case "$CHOICE" in
                    "Convert Format & Codec") state="TRANSCODE" ;;
                    "Smart Target Size Compression") state="COMPRESS" ;;
                    "Extract Audio Only") state="AUDIO_EXT" ;;
                    "Remove Audio (Mute Video)") state="MUTE" ;;
                    "Exit") exit 0 ;;
                esac
                ;;
            TRANSCODE)
                SUB=$(gum choose "MP4 (H.264 - Max Compatibility)" "MP4 (H.265/HEVC - Best Size)" "WEBM (VP9 - Web Standard)" "MKV (Copy - Instant Remux)" "<-- Back")
                navigate_back "$SUB" && state="MAIN" || {
                    case "$SUB" in
                        *H.264*) OUTPUT_FILE="${DIR_NAME}/${FILENAME_NO_EXT}_h264.mp4"; execute_command ffmpeg -i "$INPUT_FILE" -c:v libx264 -preset fast -crf 23 -c:a aac -b:a 128k "$OUTPUT_FILE"; return ;;
                        *H.265*) OUTPUT_FILE="${DIR_NAME}/${FILENAME_NO_EXT}_hevc.mp4"; execute_command ffmpeg -i "$INPUT_FILE" -c:v libx265 -preset fast -crf 26 -c:a aac -b:a 128k "$OUTPUT_FILE"; return ;;
                        *VP9*)   OUTPUT_FILE="${DIR_NAME}/${FILENAME_NO_EXT}_vp9.webm"; execute_command ffmpeg -i "$INPUT_FILE" -c:v libvpx-vp9 -crf 30 -b:v 0 -c:a libopus "$OUTPUT_FILE"; return ;;
                        *Copy*)  OUTPUT_FILE="${DIR_NAME}/${FILENAME_NO_EXT}_remux.mkv"; execute_command ffmpeg -i "$INPUT_FILE" -c copy "$OUTPUT_FILE"; return ;;
                    esac
                }
                ;;
            COMPRESS)
                SUB=$(gum choose "8 MB (Discord Basic)" "25 MB (Email/Nitro)" "50 MB (Web Standard)" "100 MB" "Custom Size..." "<-- Back")
                navigate_back "$SUB" && state="MAIN" || {
                    [ "$SUB" == "Custom Size..." ] && TARGET_MB=$(gum input --placeholder "Enter target size in MB") || TARGET_MB=$(echo "$SUB" | awk '{print $1}')
                    [ -z "$TARGET_MB" ] && continue
                    
                    DURATION=$(ffprobe -v error -show_entries format=duration -of default=noprint_wrappers=1:nokey=1 "$INPUT_FILE" | awk '{print int($1+0.5)}')
                    TOTAL_BITRATE=$(( (TARGET_MB * 8192) / DURATION ))
                    VIDEO_BITRATE=$(( TOTAL_BITRATE - 128 ))
                    
                    OUTPUT_FILE="${DIR_NAME}/${FILENAME_NO_EXT}_${TARGET_MB}MB.mp4"
                    gum confirm "Begin compression?" && execute_command ffmpeg -i "$INPUT_FILE" -c:v libx264 -b:v "${VIDEO_BITRATE}k" -maxrate "${VIDEO_BITRATE}k" -bufsize "$((VIDEO_BITRATE * 2))k" -c:a aac -b:a 128k "$OUTPUT_FILE"
                    return
                }
                ;;
            AUDIO_EXT) OUTPUT_FILE="${DIR_NAME}/${FILENAME_NO_EXT}_audio.mp3"; execute_command ffmpeg -i "$INPUT_FILE" -q:a 0 -map a "$OUTPUT_FILE"; return ;;
            MUTE) OUTPUT_FILE="${DIR_NAME}/${FILENAME_NO_EXT}_muted.${EXTENSION}"; execute_command ffmpeg -i "$INPUT_FILE" -c:v copy -an "$OUTPUT_FILE"; return ;;
        esac
    done
}

# ==========================================
#              IMAGE TUI LOGIC
# ==========================================
process_image() {
    local state="MAIN"
    while true; do
        case "$state" in
            MAIN)
                CHOICE=$(gum choose "Compression & Quality" "Resize & Dimensions" "Convert Format" "Strip Metadata" "Exit")
                [ -z "$CHOICE" ] && exit 0
                case "$CHOICE" in
                    "Compression & Quality") state="COMP" ;;
                    "Resize & Dimensions") state="RESIZE" ;;
                    "Convert Format") state="CONV" ;;
                    "Strip Metadata") state="STRIP" ;;
                    "Exit") exit 0 ;;
                esac
                ;;
            COMP)
                SUB=$(gum choose "50%" "70%" "75%" "80%" "90%" "Custom Quality..." "<-- Back")
                navigate_back "$SUB" && state="MAIN" || {
                    [ "$SUB" == "Custom Quality..." ] && QUALITY=$(gum input --placeholder "Enter 1-100") || QUALITY=$(echo "$SUB" | tr -d '%')
                    OUTPUT_FILE="${DIR_NAME}/${FILENAME_NO_EXT}_compressed_${QUALITY}.${EXTENSION}"
                    execute_command magick "$INPUT_FILE" -quality "${QUALITY}%" "$OUTPUT_FILE"; return
                }
                ;;
            RESIZE)
                SUB=$(gum choose "25%" "50%" "75%" "1920x1080 px" "800x600 px" "Custom Resize..." "<-- Back")
                navigate_back "$SUB" && state="MAIN" || {
                    [ "$SUB" == "Custom Resize..." ] && SIZE=$(gum input --placeholder "e.g. 1024x768") || SIZE=$(echo "$SUB" | awk '{print $1}')
                    OUTPUT_FILE="${DIR_NAME}/${FILENAME_NO_EXT}_resized_${SIZE}.${EXTENSION}"
                    execute_command magick "$INPUT_FILE" -resize "$SIZE" "$OUTPUT_FILE"; return
                }
                ;;
            CONV)
                SUB=$(gum choose "GIF" "JPEG" "PNG" "WEBP" "PDF" "<-- Back")
                navigate_back "$SUB" && state="MAIN" || {
                    OUTPUT_FILE="${DIR_NAME}/${FILENAME_NO_EXT}_converted.${SUB,,}"
                    execute_command magick "$INPUT_FILE" "$OUTPUT_FILE"; return
                }
                ;;
            STRIP)
                OUTPUT_FILE="${DIR_NAME}/${FILENAME_NO_EXT}_stripped.${EXTENSION}"
                execute_command cp "$INPUT_FILE" "$OUTPUT_FILE"
                execute_command exiftool -all= -overwrite_original "$OUTPUT_FILE"; return
                ;;
        esac
    done
}

# --- Execution ---
if [ "$FILE_TYPE" == "VIDEO" ]; then process_video
elif [ "$FILE_TYPE" == "AUDIO" ]; then process_audio
elif [ "$FILE_TYPE" == "IMAGE" ]; then process_image; fi

if [ -n "$OUTPUT_FILE" ] && [ -f "$OUTPUT_FILE" ]; then
    gum style --foreground 46 "✓ Operation complete: $OUTPUT_FILE"
fi
