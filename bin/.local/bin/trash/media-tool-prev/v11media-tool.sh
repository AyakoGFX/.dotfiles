#!/bin/bash

# Ensure an input file or directory is passed
if [ -z "$1" ]; then
	echo "Usage: $0 <input_file_or_directory>"
	exit 1
fi

INPUT_PATH="$1"

# ==========================================
#        MODE DETECTION & INITIALIZATION
# ==========================================
if [ -d "$INPUT_PATH" ]; then
	BATCH_MODE=1
	TARGET_DIR="${INPUT_PATH%/}" # strip trailing slash

	BATCH_TYPE=$(whiptail --title "Batch Processing" --menu "Select media type to batch process in folder:\n$TARGET_DIR" 15 60 4 \
		"VIDEO" "Process all Video files" \
		"IMAGE" "Process all Image files" \
		"AUDIO" "Process all Audio files" \
		"EXIT" "Exit" 3>&1 1>&2 2>&3)

	[ -z "$BATCH_TYPE" ] || [ "$BATCH_TYPE" = "EXIT" ] && exit 0
	FILE_TYPE="$BATCH_TYPE"

	case "$FILE_TYPE" in
		VIDEO) EXT_REGEX=".*\.(mp4|mkv|avi|mov|webm|flv)$" ;;
		IMAGE) EXT_REGEX=".*\.(jpg|jpeg|png|webp|gif|tiff)$" ;;
		AUDIO) EXT_REGEX=".*\.(mp3|wav|flac|m4a|ogg|aac|opus)$" ;;
	esac

	# Safely capture matching files into an array
	TARGET_FILES=()
	while IFS= read -r -d $'\0'; do
		TARGET_FILES+=("$REPLY")
	done < <(find "$TARGET_DIR" -maxdepth 1 -type f -regextype posix-extended -iregex "$EXT_REGEX" -print0 | sort -z)

	if [ ${#TARGET_FILES[@]} -eq 0 ]; then
		whiptail --msgbox "No matching $FILE_TYPE files found in folder!" 8 45
		exit 1
	fi

	OUT_DIR="$TARGET_DIR/batch_output"
	mkdir -p "$OUT_DIR"
	GUI_TITLE_PREFIX="[BATCH MODE: ${#TARGET_FILES[@]} files]"
else
	BATCH_MODE=0
	TARGET_FILES=("$INPUT_PATH")
	DIR_NAME=$(dirname "$INPUT_PATH")
	OUT_DIR="$DIR_NAME"
	BASE_NAME=$(basename "$INPUT_PATH")

	if [[ "$BASE_NAME" == *.* ]]; then
		EXTENSION="${BASE_NAME##*.}"
		EXTENSION=$(echo "$EXTENSION" | tr '[:upper:]' '[:lower:]')
	else
		EXTENSION=""
	fi

	if [[ "$EXTENSION" =~ ^(jpg|jpeg|png|webp|gif|tiff)$ ]]; then
		FILE_TYPE="IMAGE"
	elif [[ "$EXTENSION" =~ ^(mp4|mkv|avi|mov|webm|flv)$ ]]; then
		FILE_TYPE="VIDEO"
	elif [[ "$EXTENSION" =~ ^(mp3|wav|flac|m4a|ogg|aac|opus)$ ]]; then
		FILE_TYPE="AUDIO"
	else
		echo "Error: Unsupported file type ($EXTENSION)."
		exit 1
	fi
	GUI_TITLE_PREFIX="File: $BASE_NAME"
fi

# --- Dependency Check ---
if [ "$FILE_TYPE" == "IMAGE" ]; then
	DEPS=(magick whiptail exiftool)
else
	DEPS=(ffmpeg ffprobe whiptail)
fi

for cmd in "${DEPS[@]}"; do
	if ! command -v "$cmd" &> /dev/null; then
		echo "Error: Required command '$cmd' is missing." >&2
		exit 1
	fi
done

# --- Cleanup Trap ---
cleanup() {
	if [ -n "$OUTPUT_FILE" ] && [ -f "$OUTPUT_FILE" ]; then
		echo -e "\n\n[Process Interrupted]: Cleaning up incomplete file..."
		rm -f "$OUTPUT_FILE"
	fi
	exit 1
}
trap cleanup SIGINT SIGTERM

execute_command() {
	"$@"
	local exit_status=$?
	echo -e "\n[Executed Command]:\n$*"
	return $exit_status
}

# ==========================================
#              GUI MENUS & ROUTING
# ==========================================

# --- AUDIO GUI ---
show_audio_main_menu() { whiptail --title "Audio TUI - $GUI_TITLE_PREFIX" --menu "Select an operation:" 18 55 6 "CONV" "Convert Format..." "COMP" "Compress (Change Bitrate)..." "NORM" "Normalize Volume" "MONO" "Downmix Stereo to Mono" "EXIT" "Exit Script" 3>&1 1>&2 2>&3 ; }
show_audio_convert_menu() { whiptail --title "Audio Conversion" --menu "Select Target Format" 17 55 6 "MP3" "Convert to MP3 (VBR)" "FLAC" "Convert to FLAC (Lossless)" "WAV" "Convert to WAV" "OGG" "Convert to OGG" "M4A" "Convert to M4A" "BACK" "Go Back" 3>&1 1>&2 2>&3 ; }
show_audio_compress_menu() { whiptail --title "Audio Compression" --menu "Select Target Bitrate" 17 55 6 "64k" "64 kbps (Voice)" "128k" "128 kbps (Standard)" "192k" "192 kbps (Good)" "256k" "256 kbps (High)" "320k" "320 kbps (Max)" "BACK" "Go Back" 3>&1 1>&2 2>&3 ; }

process_audio_gui() {
	while true; do
		MAIN_CHOICE=$(show_audio_main_menu)
		[ -z "$MAIN_CHOICE" ] && exit 0
		case "$MAIN_CHOICE" in
			EXIT) exit 0 ;;
			CONV)
				while true; do
					SUB_CHOICE=$(show_audio_convert_menu)
					[ -z "$SUB_CHOICE" ] || [ "$SUB_CHOICE" = "BACK" ] && break
					SELECTED_OP="CONV"; SELECTED_PARAM="$SUB_CHOICE"; return 0
				done ;;
			COMP)
				while true; do
					SUB_CHOICE=$(show_audio_compress_menu)
					[ -z "$SUB_CHOICE" ] || [ "$SUB_CHOICE" = "BACK" ] && break
					SELECTED_OP="COMP"; SELECTED_PARAM="$SUB_CHOICE"; return 0
				done ;;
			NORM) SELECTED_OP="NORM"; return 0 ;;
			MONO) SELECTED_OP="MONO"; return 0 ;;
		esac
	done
}


# --- VIDEO GUI ---
show_video_main_menu() {
    whiptail \
        --title "Video TUI - $GUI_TITLE_PREFIX" \
        --menu "Select an operation:" \
        22 60 10 \
        "TRANSCODE" "Convert Format & Codec..." \
        "COMPRESS"  "Smart Target Size Compression..." \
        "FPS"       "Change Framerate (FPS)..." \
        "CROP"      "Smart Crop (Aspect Ratios)..." \
        "TRIM"      "Trim / Cut Video..." \
        "SPEED"     "Change Playback Speed..." \
        "FX"        "Filters & Color Effects..." \
        "AUDIO_EXT" "Extract Audio Only..." \
        "MUTE"      "Remove Audio" \
        "EXIT"      "Exit Script" \
        3>&1 1>&2 2>&3
}

show_video_transcode_menu() {
    whiptail \
        --title "Video Transcoding" \
        --menu "Select Target Format" \
        17 60 5 \
        "MP4_H264" "MP4 (H.264)" \
        "MP4_HEVC" "MP4 (H.265/HEVC)" \
        "WEBM_VP9" "WEBM (VP9)" \
        "MKV_COPY" "MKV (Copy Remux)" \
        "BACK"     "Go Back" \
        3>&1 1>&2 2>&3
}

show_video_compress_menu() {
    whiptail \
        --title "Smart Compression" \
        --menu "Select Target File Size" \
        18 60 6 \
        "8"      "8 MB (Discord limit)" \
        "25"     "25 MB (Email limit)" \
        "50"     "50 MB (Web limit)" \
        "100"    "100 MB" \
        "CUSTOM" "Enter custom size in MB..." \
        "BACK"   "Go Back" \
        3>&1 1>&2 2>&3
}

show_video_fps_menu() {
    whiptail \
        --title "Framerate Settings" \
        --menu "Select FPS" \
        17 55 5 \
        "24"     "24 FPS" \
        "30"     "30 FPS" \
        "60"     "60 FPS" \
        "CUSTOM" "Enter custom FPS..." \
        "BACK"   "Go Back" \
        3>&1 1>&2 2>&3
}

show_video_crop_menu() {
    whiptail \
        --title "Smart Cropping" \
        --menu "Select Aspect Ratio" \
        17 55 4 \
        "9:16" "Vertical (Shorts/Reels)" \
        "1:1"  "Square (Insta Grid)" \
        "16:9" "Landscape (Standard)" \
        "BACK" "Go Back" \
        3>&1 1>&2 2>&3
}

show_video_speed_menu() {
    whiptail \
        --title "Playback Speed" \
        --menu "Select Speed Multiplier" \
        17 55 5 \
        "0.5x"  "Half Speed (Slow Mo)" \
        "1.25x" "1.25x Faster" \
        "1.5x"  "1.5x Faster" \
        "2.0x"  "Double Speed" \
        "BACK"  "Go Back" \
        3>&1 1>&2 2>&3
}

show_video_fx_menu() {
    whiptail \
        --title "Video Effects" \
        --menu "Select an effect" \
        16 55 4 \
        "GRAY"  "Grayscale" \
        "SEPIA" "Sepia Tone" \
        "BACK"  "Go Back" \
        3>&1 1>&2 2>&3
}

process_video_gui() {
	while true; do
		MAIN_CHOICE=$(show_video_main_menu)
		[ -z "$MAIN_CHOICE" ] && exit 0
		case "$MAIN_CHOICE" in
			EXIT) exit 0 ;;
			TRANSCODE)
				while true; do
					SUB_CHOICE=$(show_video_transcode_menu)
					[ -z "$SUB_CHOICE" ] || [ "$SUB_CHOICE" = "BACK" ] && break
					SELECTED_OP="TRANSCODE"; SELECTED_PARAM="$SUB_CHOICE"; return 0
				done ;;
			COMPRESS)
				while true; do
					SUB_CHOICE=$(show_video_compress_menu)
					[ -z "$SUB_CHOICE" ] || [ "$SUB_CHOICE" = "BACK" ] && break
					if [ "$SUB_CHOICE" = "CUSTOM" ]; then
						TARGET_MB=$(whiptail --inputbox "Enter target size in MB (e.g. 15):" 8 40 3>&1 1>&2 2>&3)
						[ -z "$TARGET_MB" ] && continue
						SELECTED_OP="COMPRESS"; SELECTED_PARAM="$TARGET_MB"; return 0
					fi
					SELECTED_OP="COMPRESS"; SELECTED_PARAM="$SUB_CHOICE"; return 0
				done ;;
			FPS)
				while true; do
					SUB_CHOICE=$(show_video_fps_menu)
					[ -z "$SUB_CHOICE" ] || [ "$SUB_CHOICE" = "BACK" ] && break
					if [ "$SUB_CHOICE" = "CUSTOM" ]; then
						TARGET_FPS=$(whiptail --inputbox "Enter custom FPS (e.g. 29.97 or 120):" 8 45 3>&1 1>&2 2>&3)
						[ -z "$TARGET_FPS" ] && continue
						if [[ ! "$TARGET_FPS" =~ ^[0-9]+(\.[0-9]+)?$ ]]; then whiptail --msgbox "Invalid FPS format." 8 50; continue; fi
						SELECTED_OP="FPS"; SELECTED_PARAM="$TARGET_FPS"; return 0
					fi
					SELECTED_OP="FPS"; SELECTED_PARAM="$SUB_CHOICE"; return 0
				done ;;
			CROP)
				while true; do
					SUB_CHOICE=$(show_video_crop_menu)
					[ -z "$SUB_CHOICE" ] || [ "$SUB_CHOICE" = "BACK" ] && break
					SELECTED_OP="CROP"; SELECTED_PARAM="$SUB_CHOICE"; return 0
				done ;;
			TRIM)
				START_TIME=$(whiptail --inputbox "Enter Start Time (e.g. 00:01:30 or 90):" 8 45 3>&1 1>&2 2>&3)
				[ -z "$START_TIME" ] && continue
				DURATION_VAL=$(whiptail --inputbox "Enter Duration to keep (e.g. 00:00:15 or 15):" 8 50 3>&1 1>&2 2>&3)
				[ -z "$DURATION_VAL" ] && continue
				SELECTED_OP="TRIM"; SELECTED_PARAM="$START_TIME"; SELECTED_PARAM2="$DURATION_VAL"; return 0 ;;
			SPEED)
				while true; do
					SUB_CHOICE=$(show_video_speed_menu)
					[ -z "$SUB_CHOICE" ] || [ "$SUB_CHOICE" = "BACK" ] && break
					SELECTED_OP="SPEED"; SELECTED_PARAM="$SUB_CHOICE"; return 0
				done ;;
			FX)
				while true; do
					SUB_CHOICE=$(show_video_fx_menu)
					[ -z "$SUB_CHOICE" ] || [ "$SUB_CHOICE" = "BACK" ] && break
					SELECTED_OP="FX"; SELECTED_PARAM="$SUB_CHOICE"; return 0
				done ;;
			AUDIO_EXT) SELECTED_OP="AUDIO_EXT"; return 0 ;;
			MUTE) SELECTED_OP="MUTE"; return 0 ;;
		esac
	done
}

# --- IMAGE GUI ---
show_image_main_menu() {
    whiptail \
        --title "Image TUI - $GUI_TITLE_PREFIX" \
        --menu "Select an operation:" \
        19 55 7 \
        "COMP"   "Compression Menu..." \
        "RESIZE" "Resize Menu..." \
        "ROTATE" "Auto-Orientation..." \
        "CONV"   "Convert Format..." \
        "FX"     "Filters & Effects..." \
        "STRIP"  "Strip Metadata" \
        "EXIT"   "Exit Script" \
        3>&1 1>&2 2>&3
}

show_image_compression_menu() {
    whiptail \
        --title "Compression Options" \
        --menu "Select Quality" \
        18 50 7 \
        "50%"    "Compress at 50%" \
        "70%"    "Compress at 70%" \
        "75%"    "Compress at 75%" \
        "80%"    "Compress at 80%" \
        "90%"    "Compress at 90%" \
        "CUSTOM" "Custom quality" \
        "BACK"   "Go Back" \
        3>&1 1>&2 2>&3
}

show_image_resize_menu() {
    whiptail \
        --title "Resize Options" \
        --menu "Select Size" \
        19 60 8 \
        "25%"       "Resize at 25%" \
        "50%"       "Resize at 50%" \
        "75%"       "Resize at 75%" \
        "1920x1080" "Resize at 1920x1080 px" \
        "800x600"   "Resize at 800x600 px" \
        "CUSTOM"    "Custom resize" \
        "BACK"      "Go Back" \
        3>&1 1>&2 2>&3
}

show_image_rotate_menu() {
    whiptail \
        --title "Image Rotation" \
        --menu "Select Rotation" \
        17 55 4 \
        "90CW"  "90° Clockwise" \
        "90CCW" "90° Counter-Clockwise" \
        "180"   "180° Flip" \
        "BACK"  "Go Back" \
        3>&1 1>&2 2>&3
}

show_image_convert_menu() {
    whiptail \
        --title "Conversion Options" \
        --menu "Select Target Format" \
        18 55 6 \
        "GIF"   "Convert to GIF" \
        "JPEG"  "Convert to JPEG" \
        "PNG"   "Convert to PNG" \
        "WEBP"  "Convert to WEBP" \
        "PDF"   "Convert to PDF" \
        "BACK"  "Go Back" \
        3>&1 1>&2 2>&3
}

show_image_fx_menu() {
    whiptail \
        --title "Image Effects" \
        --menu "Select an effect" \
        17 55 5 \
        "GRAY"  "Grayscale" \
        "SEPIA" "Sepia Tone" \
        "ALPHA" "Transparency to Color" \
        "BACK"  "Go Back" \
        3>&1 1>&2 2>&3
}

process_image_gui() {
	while true; do
		MAIN_CHOICE=$(show_image_main_menu)
		[ -z "$MAIN_CHOICE" ] && exit 0
		case "$MAIN_CHOICE" in
			EXIT) exit 0 ;;
			COMP)
				while true; do
					SUB_CHOICE=$(show_image_compression_menu)
					[ -z "$SUB_CHOICE" ] || [ "$SUB_CHOICE" = "BACK" ] && break
					if [ "$SUB_CHOICE" = "CUSTOM" ]; then
						SUB_CHOICE=$(whiptail --inputbox "Enter custom quality (1-100):" 8 40 3>&1 1>&2 2>&3)
						[ -z "$SUB_CHOICE" ] && continue
					fi
					SELECTED_OP="COMP"; SELECTED_PARAM=$(echo "$SUB_CHOICE" | tr -d '%'); return 0
				done ;;
			RESIZE)
				while true; do
					SUB_CHOICE=$(show_image_resize_menu)
					[ -z "$SUB_CHOICE" ] || [ "$SUB_CHOICE" = "BACK" ] && break
					if [ "$SUB_CHOICE" = "CUSTOM" ]; then
						SUB_CHOICE=$(whiptail --inputbox "Enter size (e.g. 800x600 or 40%):" 8 40 3>&1 1>&2 2>&3)
						[ -z "$SUB_CHOICE" ] && continue
					fi
					SELECTED_OP="RESIZE"; SELECTED_PARAM=$(echo "$SUB_CHOICE" | tr -d '%'); return 0
				done ;;
			ROTATE)
				while true; do
					SUB_CHOICE=$(show_image_rotate_menu)
					[ -z "$SUB_CHOICE" ] || [ "$SUB_CHOICE" = "BACK" ] && break
					SELECTED_OP="ROTATE"; SELECTED_PARAM="$SUB_CHOICE"; return 0
				done ;;
			CONV)
				while true; do
					SUB_CHOICE=$(show_image_convert_menu)
					[ -z "$SUB_CHOICE" ] || [ "$SUB_CHOICE" = "BACK" ] && break
					SELECTED_OP="CONV"; SELECTED_PARAM="$SUB_CHOICE"; return 0
				done ;;
			FX)
				while true; do
					SUB_CHOICE=$(show_image_fx_menu)
					[ -z "$SUB_CHOICE" ] || [ "$SUB_CHOICE" = "BACK" ] && break
					if [ "$SUB_CHOICE" = "ALPHA" ]; then
						BG_COLOR=$(whiptail --inputbox "Enter target background color (e.g. white, black, #FF5733):" 8 55 "white" 3>&1 1>&2 2>&3)
						[ -z "$BG_COLOR" ] && continue
						SELECTED_OP="FX"; SELECTED_PARAM="ALPHA"; SELECTED_PARAM2="$BG_COLOR"; return 0
					fi
					SELECTED_OP="FX"; SELECTED_PARAM="$SUB_CHOICE"; return 0
				done ;;
			STRIP) SELECTED_OP="STRIP"; return 0 ;;
		esac
	done
}

# ==========================================
#         EXECUTION ROUTING LOGIC
# ==========================================

execute_audio_op() {
	case "$SELECTED_OP" in
		CONV)
			case "$SELECTED_PARAM" in
				MP3)  OUTPUT_FILE="${OUT_DIR}/${FILENAME_NO_EXT}_conv.mp3"; execute_command ffmpeg -y -i "$INPUT_FILE" -q:a 2 "$OUTPUT_FILE" ;;
				FLAC) OUTPUT_FILE="${OUT_DIR}/${FILENAME_NO_EXT}_conv.flac"; execute_command ffmpeg -y -i "$INPUT_FILE" -c:a flac "$OUTPUT_FILE" ;;
				WAV)  OUTPUT_FILE="${OUT_DIR}/${FILENAME_NO_EXT}_conv.wav"; execute_command ffmpeg -y -i "$INPUT_FILE" -c:a pcm_s16le "$OUTPUT_FILE" ;;
				OGG)  OUTPUT_FILE="${OUT_DIR}/${FILENAME_NO_EXT}_conv.ogg"; execute_command ffmpeg -y -i "$INPUT_FILE" -c:a libvorbis -q:a 5 "$OUTPUT_FILE" ;;
				M4A)  OUTPUT_FILE="${OUT_DIR}/${FILENAME_NO_EXT}_conv.m4a"; execute_command ffmpeg -y -i "$INPUT_FILE" -c:a aac -b:a 192k "$OUTPUT_FILE" ;;
			esac ;;
		COMP) OUTPUT_FILE="${OUT_DIR}/${FILENAME_NO_EXT}_${SELECTED_PARAM}.mp3"; execute_command ffmpeg -y -i "$INPUT_FILE" -c:a libmp3lame -b:a "$SELECTED_PARAM" "$OUTPUT_FILE" ;;
		NORM) OUTPUT_FILE="${OUT_DIR}/${FILENAME_NO_EXT}_norm.${EXTENSION}"; execute_command ffmpeg -y -i "$INPUT_FILE" -af "loudnorm=I=-16:TP=-1.5:LRA=11" "$OUTPUT_FILE" ;;
		MONO) OUTPUT_FILE="${OUT_DIR}/${FILENAME_NO_EXT}_mono.${EXTENSION}"; execute_command ffmpeg -y -i "$INPUT_FILE" -ac 1 "$OUTPUT_FILE" ;;
	esac
}

execute_video_op() {
	case "$SELECTED_OP" in
		TRANSCODE)
			case "$SELECTED_PARAM" in
				MP4_H264) OUTPUT_FILE="${OUT_DIR}/${FILENAME_NO_EXT}_h264.mp4"; execute_command ffmpeg -y -i "$INPUT_FILE" -c:v libx264 -preset fast -crf 23 -c:a aac -b:a 128k "$OUTPUT_FILE" ;;
				MP4_HEVC) OUTPUT_FILE="${OUT_DIR}/${FILENAME_NO_EXT}_hevc.mp4"; execute_command ffmpeg -y -i "$INPUT_FILE" -c:v libx265 -preset fast -crf 26 -c:a aac -b:a 128k "$OUTPUT_FILE" ;;
				WEBM_VP9) OUTPUT_FILE="${OUT_DIR}/${FILENAME_NO_EXT}_vp9.webm"; execute_command ffmpeg -y -i "$INPUT_FILE" -c:v libvpx-vp9 -crf 30 -b:v 0 -c:a libopus "$OUTPUT_FILE" ;;
				MKV_COPY) OUTPUT_FILE="${OUT_DIR}/${FILENAME_NO_EXT}_remux.mkv"; execute_command ffmpeg -y -i "$INPUT_FILE" -c copy "$OUTPUT_FILE" ;;
			esac ;;
		COMPRESS)
			DURATION=$(ffprobe -v error -show_entries format=duration -of default=noprint_wrappers=1:nokey=1 "$INPUT_FILE" | awk '{print int($1+0.5)}')
			if [ -z "$DURATION" ] || [ "$DURATION" -eq 0 ]; then echo "Skipping $BASE_NAME: Could not determine duration."; return 1; fi
			TOTAL_BITRATE=$(( (SELECTED_PARAM * 8192) / DURATION ))
			AUDIO_BITRATE=128
			VIDEO_BITRATE=$(( TOTAL_BITRATE - AUDIO_BITRATE ))
			if [ "$VIDEO_BITRATE" -lt 100 ]; then echo "Skipping $BASE_NAME: Target size too small for duration."; return 1; fi
			echo "Calculated Bitrate for $BASE_NAME -> Video: ${VIDEO_BITRATE}k | Audio: ${AUDIO_BITRATE}k"
			OUTPUT_FILE="${OUT_DIR}/${FILENAME_NO_EXT}_${SELECTED_PARAM}MB.mp4"
			execute_command ffmpeg -y -i "$INPUT_FILE" -c:v libx264 -b:v "${VIDEO_BITRATE}k" -maxrate "${VIDEO_BITRATE}k" -bufsize "$((VIDEO_BITRATE * 2))k" -c:a aac -b:a "${AUDIO_BITRATE}k" "$OUTPUT_FILE" ;;
		FPS)
			OUTPUT_FILE="${OUT_DIR}/${FILENAME_NO_EXT}_${SELECTED_PARAM}fps.${EXTENSION}"
			execute_command ffmpeg -y -i "$INPUT_FILE" -r "$SELECTED_PARAM" -c:a copy "$OUTPUT_FILE" ;;
		CROP)
			case "$SELECTED_PARAM" in
				9:16) OUTPUT_FILE="${OUT_DIR}/${FILENAME_NO_EXT}_9x16.${EXTENSION}"; execute_command ffmpeg -y -i "$INPUT_FILE" -vf "crop=ih*(9/16):ih" -c:a copy "$OUTPUT_FILE" ;;
				1:1) OUTPUT_FILE="${OUT_DIR}/${FILENAME_NO_EXT}_1x1.${EXTENSION}"; execute_command ffmpeg -y -i "$INPUT_FILE" -vf "crop='min(iw,ih)':'min(iw,ih)'" -c:a copy "$OUTPUT_FILE" ;;
				16:9) OUTPUT_FILE="${OUT_DIR}/${FILENAME_NO_EXT}_16x9.${EXTENSION}"; execute_command ffmpeg -y -i "$INPUT_FILE" -vf "crop=iw:iw*(9/16)" -c:a copy "$OUTPUT_FILE" ;;
			esac ;;
		TRIM)
			OUTPUT_FILE="${OUT_DIR}/${FILENAME_NO_EXT}_trimmed.${EXTENSION}"
			execute_command ffmpeg -y -ss "$SELECTED_PARAM" -i "$INPUT_FILE" -t "$SELECTED_PARAM2" -c copy "$OUTPUT_FILE" ;;
		SPEED)
			case "$SELECTED_PARAM" in
				0.5x) V_PTS="2.0"; A_TEMPO="0.5" ;;
				1.25x) V_PTS="0.8"; A_TEMPO="1.25" ;;
				1.5x) V_PTS="0.6666"; A_TEMPO="1.5" ;;
				2.0x) V_PTS="0.5"; A_TEMPO="2.0" ;;
			esac
			OUTPUT_FILE="${OUT_DIR}/${FILENAME_NO_EXT}_speed_${SELECTED_PARAM}.${EXTENSION}"
			execute_command ffmpeg -y -i "$INPUT_FILE" -filter_complex "[0:v]setpts=${V_PTS}*PTS[v];[0:a]atempo=${A_TEMPO}[a]" -map "[v]" -map "[a]" "$OUTPUT_FILE" ;;
		FX)
			case "$SELECTED_PARAM" in
				GRAY) OUTPUT_FILE="${OUT_DIR}/${FILENAME_NO_EXT}_gray.${EXTENSION}"; execute_command ffmpeg -y -i "$INPUT_FILE" -vf "eq=saturation=0" -c:a copy "$OUTPUT_FILE" ;;
				SEPIA) OUTPUT_FILE="${OUT_DIR}/${FILENAME_NO_EXT}_sepia.${EXTENSION}"; execute_command ffmpeg -y -i "$INPUT_FILE" -vf "colorchannelmixer=.393:.769:.189:0:.349:.686:.168:0:.272:.534:.131" -c:a copy "$OUTPUT_FILE" ;;
			esac ;;
		AUDIO_EXT)
			NATIVE_A_CODEC=$(ffprobe -v error -select_streams a:0 -show_entries stream=codec_name -of default=noprint_wrappers=1:nokey=1 "$INPUT_FILE")
			case "$NATIVE_A_CODEC" in aac) A_EXT="m4a" ;; mp3) A_EXT="mp3" ;; opus) A_EXT="opus" ;; flac) A_EXT="flac" ;; *) A_EXT="aac" ;; esac
			OUTPUT_FILE="${OUT_DIR}/${FILENAME_NO_EXT}_audio.${A_EXT}"
			if [ "$A_EXT" = "aac" ] && [ "$NATIVE_A_CODEC" != "aac" ]; then
				execute_command ffmpeg -y -i "$INPUT_FILE" -vn -c:a aac -b:a 192k "$OUTPUT_FILE"
			else
				execute_command ffmpeg -y -i "$INPUT_FILE" -vn -c:a copy "$OUTPUT_FILE"
			fi ;;
		MUTE) OUTPUT_FILE="${OUT_DIR}/${FILENAME_NO_EXT}_muted.${EXTENSION}"; execute_command ffmpeg -y -i "$INPUT_FILE" -c:v copy -an "$OUTPUT_FILE" ;;
	esac
}

execute_image_op() {
	case "$SELECTED_OP" in
		COMP) OUTPUT_FILE="${OUT_DIR}/${FILENAME_NO_EXT}_comp_${SELECTED_PARAM}.${EXTENSION}"; execute_command magick "$INPUT_FILE" -quality "${SELECTED_PARAM}%" "$OUTPUT_FILE" ;;
		RESIZE) OUTPUT_FILE="${OUT_DIR}/${FILENAME_NO_EXT}_res_${SELECTED_PARAM}.${EXTENSION}"; execute_command magick "$INPUT_FILE" -resize "$SELECTED_PARAM" "$OUTPUT_FILE" ;;
		ROTATE)
			case "$SELECTED_PARAM" in
				90CW) OUTPUT_FILE="${OUT_DIR}/${FILENAME_NO_EXT}_90CW.${EXTENSION}"; execute_command magick "$INPUT_FILE" -rotate 90 "$OUTPUT_FILE" ;;
				90CCW) OUTPUT_FILE="${OUT_DIR}/${FILENAME_NO_EXT}_90CCW.${EXTENSION}"; execute_command magick "$INPUT_FILE" -rotate -90 "$OUTPUT_FILE" ;;
				180) OUTPUT_FILE="${OUT_DIR}/${FILENAME_NO_EXT}_180.${EXTENSION}"; execute_command magick "$INPUT_FILE" -rotate 180 "$OUTPUT_FILE" ;;
			esac ;;
		CONV)
			case "$SELECTED_PARAM" in
				GIF)  OUTPUT_FILE="${OUT_DIR}/${FILENAME_NO_EXT}_conv.gif"; execute_command magick "$INPUT_FILE" "$OUTPUT_FILE" ;;
				JPEG) OUTPUT_FILE="${OUT_DIR}/${FILENAME_NO_EXT}_conv.jpg"; execute_command magick "$INPUT_FILE" "$OUTPUT_FILE" ;;
				PNG)  OUTPUT_FILE="${OUT_DIR}/${FILENAME_NO_EXT}_conv.png"; execute_command magick "$INPUT_FILE" "$OUTPUT_FILE" ;;
				WEBP) OUTPUT_FILE="${OUT_DIR}/${FILENAME_NO_EXT}_conv.webp"; execute_command magick "$INPUT_FILE" "$OUTPUT_FILE" ;;
				PDF)  OUTPUT_FILE="${OUT_DIR}/${FILENAME_NO_EXT}_conv.pdf"; execute_command magick "$INPUT_FILE" "$OUTPUT_FILE" ;;
			esac ;;
		FX)
			case "$SELECTED_PARAM" in
				GRAY) OUTPUT_FILE="${OUT_DIR}/${FILENAME_NO_EXT}_gray.${EXTENSION}"; execute_command magick "$INPUT_FILE" -colorspace gray "$OUTPUT_FILE" ;;
				SEPIA) OUTPUT_FILE="${OUT_DIR}/${FILENAME_NO_EXT}_sepia.${EXTENSION}"; execute_command magick "$INPUT_FILE" -sepia-tone 80% "$OUTPUT_FILE" ;;
				ALPHA) OUTPUT_FILE="${OUT_DIR}/${FILENAME_NO_EXT}_solid_bg.${EXTENSION}"; execute_command magick "$INPUT_FILE" -background "$SELECTED_PARAM2" -alpha remove -alpha off "$OUTPUT_FILE" ;;
			esac ;;
		STRIP) OUTPUT_FILE="${OUT_DIR}/${FILENAME_NO_EXT}_stripped.${EXTENSION}"; execute_command cp "$INPUT_FILE" "$OUTPUT_FILE"; execute_command exiftool -all= -overwrite_original "$OUTPUT_FILE" ;;
	esac
}

# ==========================================
#              MAIN EXECUTION
# ==========================================

# 1. Trigger correct GUI
if [ "$FILE_TYPE" == "VIDEO" ]; then process_video_gui
elif [ "$FILE_TYPE" == "AUDIO" ]; then process_audio_gui
elif [ "$FILE_TYPE" == "IMAGE" ]; then process_image_gui
fi

echo -e "\n========================================================"
echo -e "Starting Operation: $SELECTED_OP $SELECTED_PARAM $SELECTED_PARAM2"
echo -e "========================================================\n"

# 2. Iterate through all target files
for INPUT_FILE in "${TARGET_FILES[@]}"; do
	BASE_NAME=$(basename "$INPUT_FILE")
	if [[ "$BASE_NAME" == *.* ]]; then
		FILENAME_NO_EXT="${BASE_NAME%.*}"
		EXTENSION="${BASE_NAME##*.}"
		EXTENSION=$(echo "$EXTENSION" | tr '[:upper:]' '[:lower:]')
	else
		FILENAME_NO_EXT="$BASE_NAME"
		EXTENSION=""
	fi

	if [ "$FILE_TYPE" == "VIDEO" ]; then execute_video_op
	elif [ "$FILE_TYPE" == "AUDIO" ]; then execute_audio_op
	elif [ "$FILE_TYPE" == "IMAGE" ]; then execute_image_op
	fi
done

if [ "$BATCH_MODE" -eq 1 ]; then
	echo -e "\nBatch operation complete! Output saved to:\n$OUT_DIR"
else
	if [ -n "$OUTPUT_FILE" ] && [ -f "$OUTPUT_FILE" ]; then
		echo -e "\nOperation complete! File saved as:\n$OUTPUT_FILE"
	fi
fi
