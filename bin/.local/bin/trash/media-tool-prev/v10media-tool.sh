#!/bin/bash
# Ensure an input file is passed
if [ -z "$1" ] || [ ! -f "$1" ]; then
	echo "Usage: $0 <input_file>"
	exit 1
fi

INPUT_FILE="$1"

# extract directory, filename, and extension
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

OUTPUT_FILE=""

# --- Smart File Type Detection ---
FILE_TYPE="UNKNOWN"
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

# --- Helper function to run and print commands at the bottom ---
execute_command() {
	"$@"
	local exit_status=$?
	echo -e "\n[Executed Command]:\n$*"
	return $exit_status
}

# ==========================================
#              AUDIO TUI LOGIC
# ==========================================
show_audio_main_menu() {
	whiptail --title "Audio Processing TUI" --menu "Select an operation for: $BASE_NAME" 17 55 5 \
			 "CONV" "Convert Format..." \
			 "COMP" "Compress (Change Bitrate)..." \
			 "NORM" "Normalize Volume (Broadcast Standard)" \
			 "EXIT" "Exit Script" \
			 3>&1 1>&2 2>&3
}
show_audio_convert_menu() {
	whiptail --title "Audio Conversion" --menu "Select Target Format" 17 55 6 \
			 "MP3" "Convert to MP3 (High Quality VBR)" \
			 "FLAC" "Convert to FLAC (Lossless)" \
			 "WAV" "Convert to WAV (Uncompressed)" \
			 "OGG" "Convert to OGG (Vorbis)" \
			 "M4A" "Convert to M4A (AAC)" \
			 "BACK" "Go Back" \
			 3>&1 1>&2 2>&3
}
show_audio_compress_menu() {
	whiptail --title "Audio Compression" --menu "Select Target MP3 Bitrate" 17 55 6 \
			 "64k" "64 kbps (Voice / Podcast)" \
			 "128k" "128 kbps (Standard Web)" \
			 "192k" "192 kbps (Good Quality)" \
			 "256k" "256 kbps (High Quality)" \
			 "320k" "320 kbps (Maximum Quality)" \
			 "BACK" "Go Back" \
			 3>&1 1>&2 2>&3
}

process_audio() {
	while true; do
		MAIN_CHOICE=$(show_audio_main_menu)
		[ -z "$MAIN_CHOICE" ] && exit 0
		case "$MAIN_CHOICE" in
			EXIT) exit 0 ;;
			CONV)
				while true; do
					SUB_CHOICE=$(show_audio_convert_menu)
					[ -z "$SUB_CHOICE" ] && break
					case "$SUB_CHOICE" in
						BACK) break ;;
						MP3)  OUTPUT_FILE="${DIR_NAME}/${FILENAME_NO_EXT}_converted.mp3"; execute_command ffmpeg -y -i "$INPUT_FILE" -q:a 2 "$OUTPUT_FILE"; return 0 ;;
						FLAC) OUTPUT_FILE="${DIR_NAME}/${FILENAME_NO_EXT}_converted.flac"; execute_command ffmpeg -y -i "$INPUT_FILE" -c:a flac "$OUTPUT_FILE"; return 0 ;;
						WAV)  OUTPUT_FILE="${DIR_NAME}/${FILENAME_NO_EXT}_converted.wav"; execute_command ffmpeg -y -i "$INPUT_FILE" -c:a pcm_s16le "$OUTPUT_FILE"; return 0 ;;
						OGG)  OUTPUT_FILE="${DIR_NAME}/${FILENAME_NO_EXT}_converted.ogg"; execute_command ffmpeg -y -i "$INPUT_FILE" -c:a libvorbis -q:a 5 "$OUTPUT_FILE"; return 0 ;;
						M4A)  OUTPUT_FILE="${DIR_NAME}/${FILENAME_NO_EXT}_converted.m4a"; execute_command ffmpeg -y -i "$INPUT_FILE" -c:a aac -b:a 192k "$OUTPUT_FILE"; return 0 ;;
					esac
				done
				;;
			COMP)
				while true; do
					SUB_CHOICE=$(show_audio_compress_menu)
					[ -z "$SUB_CHOICE" ] && break
					case "$SUB_CHOICE" in
						BACK) break ;;
						*)
							OUTPUT_FILE="${DIR_NAME}/${FILENAME_NO_EXT}_${SUB_CHOICE}.mp3"
							execute_command ffmpeg -y -i "$INPUT_FILE" -c:a libmp3lame -b:a "$SUB_CHOICE" "$OUTPUT_FILE"
							return 0
							;;
					esac
				done
				;;
			NORM)
				OUTPUT_FILE="${DIR_NAME}/${FILENAME_NO_EXT}_normalized.${EXTENSION}"
				execute_command ffmpeg -y -i "$INPUT_FILE" -af "loudnorm=I=-16:TP=-1.5:LRA=11" "$OUTPUT_FILE"
				return 0
				;;
		esac
	done
}

# ==========================================
#              VIDEO TUI LOGIC
# ==========================================
show_video_main_menu() {
	whiptail --title "Video Processing TUI" --menu "Select an operation for: $BASE_NAME" 20 55 8 \
			 "TRANSCODE" "Convert Format & Codec..." \
			 "COMPRESS" "Smart Target Size Compression..." \
			 "FPS" "Change Video Framerate (FPS)..." \
			 "FX" "Filters & Color Effects Menu..." \
			 "AUDIO_EXT" "Extract Audio Only..." \
			 "MUTE" "Remove Audio (Mute Video)" \
			 "EXIT" "Exit Script" \
			 3>&1 1>&2 2>&3
}
show_video_transcode_menu() {
	whiptail --title "Video Transcoding" --menu "Select Target Format" 17 60 5 \
			 "MP4_H264" "MP4 (H.264) - Maximum Compatibility" \
			 "MP4_HEVC" "MP4 (H.265/HEVC) - Best Size/Quality" \
			 "WEBM_VP9" "WEBM (VP9) - Web Standard" \
			 "MKV_COPY" "MKV (Copy) - Instant Remux, No Quality Loss" \
			 "BACK" "Go Back" \
			 3>&1 1>&2 2>&3
}
show_video_compress_menu() {
	whiptail --title "Smart Video Compression" --menu "Select Target File Size" 18 60 6 \
			 "8" "8 MB (Discord Basic limit)" \
			 "25" "25 MB (Discord Nitro / Email limit)" \
			 "50" "50 MB (Standard Web limit)" \
			 "100" "100 MB" \
			 "CUSTOM" "Enter custom size in MB..." \
			 "BACK" "Go Back" \
			 3>&1 1>&2 2>&3
}
show_video_fps_menu() {
	whiptail --title "Framerate Settings" --menu "Select Target Framerate (FPS)" 17 55 5 \
			 "24" "24 FPS (Cinematic Look)" \
			 "30" "30 FPS (Standard Video)" \
			 "60" "60 FPS (Smooth / Gaming)" \
			 "CUSTOM" "Enter custom FPS..." \
			 "BACK" "Go Back" \
			 3>&1 1>&2 2>&3
}
show_video_fx_menu() {
	whiptail --title "Video Effects Menu" --menu "Select an effect" 16 55 4 \
			 "GRAY" "Grayscale (Black & White)" \
			 "SEPIA" "Sepia Tone (Vintage Look)" \
			 "BACK" "Go Back" \
			 3>&1 1>&2 2>&3
}

process_video() {
	while true; do
		MAIN_CHOICE=$(show_video_main_menu)
		[ -z "$MAIN_CHOICE" ] && exit 0
		case "$MAIN_CHOICE" in
			EXIT) exit 0 ;;
			TRANSCODE)
				while true; do
					SUB_CHOICE=$(show_video_transcode_menu)
					[ -z "$SUB_CHOICE" ] && break
					case "$SUB_CHOICE" in
						BACK) break ;;
						MP4_H264) OUTPUT_FILE="${DIR_NAME}/${FILENAME_NO_EXT}_h264.mp4"; execute_command ffmpeg -y -i "$INPUT_FILE" -c:v libx264 -preset fast -crf 23 -c:a aac -b:a 128k "$OUTPUT_FILE"; return 0 ;;
						MP4_HEVC) OUTPUT_FILE="${DIR_NAME}/${FILENAME_NO_EXT}_hevc.mp4"; execute_command ffmpeg -y -i "$INPUT_FILE" -c:v libx265 -preset fast -crf 26 -c:a aac -b:a 128k "$OUTPUT_FILE"; return 0 ;;
						WEBM_VP9) OUTPUT_FILE="${DIR_NAME}/${FILENAME_NO_EXT}_vp9.webm"; execute_command ffmpeg -y -i "$INPUT_FILE" -c:v libvpx-vp9 -crf 30 -b:v 0 -c:a libopus "$OUTPUT_FILE"; return 0 ;;
						MKV_COPY) OUTPUT_FILE="${DIR_NAME}/${FILENAME_NO_EXT}_remux.mkv"; execute_command ffmpeg -y -i "$INPUT_FILE" -c copy "$OUTPUT_FILE"; return 0 ;;
					esac
				done
				;;
			COMPRESS)
				while true; do
					SUB_CHOICE=$(show_video_compress_menu)
					[ -z "$SUB_CHOICE" ] && break
					case "$SUB_CHOICE" in
						BACK) break ;;
						*)
							if [ "$SUB_CHOICE" = "CUSTOM" ]; then
								TARGET_MB=$(whiptail --inputbox "Enter target size in MB (e.g. 15):" 8 40 3>&1 1>&2 2>&3)
								[ -z "$TARGET_MB" ] && continue
							else
								TARGET_MB="$SUB_CHOICE"
							fi
							DURATION=$(ffprobe -v error -show_entries format=duration -of default=noprint_wrappers=1:nokey=1 "$INPUT_FILE" | awk '{print int($1+0.5)}')
							if [ -z "$DURATION" ] || [ "$DURATION" -eq 0 ]; then
								whiptail --msgbox "Error: Could not determine video duration." 8 50
								continue
							fi
							TOTAL_BITRATE=$(( (TARGET_MB * 8192) / DURATION ))
							AUDIO_BITRATE=128
							VIDEO_BITRATE=$(( TOTAL_BITRATE - AUDIO_BITRATE ))
							if [ "$VIDEO_BITRATE" -lt 100 ]; then
								whiptail --msgbox "Error: Target size is too small for a video of this length." 8 50
								continue
							fi
							OUTPUT_FILE="${DIR_NAME}/${FILENAME_NO_EXT}_${TARGET_MB}MB.mp4"
							whiptail --msgbox "Calculated Video Bitrate: ${VIDEO_BITRATE}k
Calculated Audio Bitrate: ${AUDIO_BITRATE}k
Press OK to begin compression." 10 50
							execute_command ffmpeg -y -i "$INPUT_FILE" -c:v libx264 -b:v "${VIDEO_BITRATE}k" -maxrate "${VIDEO_BITRATE}k" -bufsize "$((VIDEO_BITRATE * 2))k" -c:a aac -b:a "${AUDIO_BITRATE}k" "$OUTPUT_FILE"
							return 0
							;;
					esac
				done
				;;
			FPS)
				while true; do
					SUB_CHOICE=$(show_video_fps_menu)
					[ -z "$SUB_CHOICE" ] && break
					case "$SUB_CHOICE" in
						BACK) break ;;
						*)
							if [ "$SUB_CHOICE" = "CUSTOM" ]; then
								TARGET_FPS=$(whiptail --inputbox "Enter target FPS number (e.g. 25 or 120):" 8 45 3>&1 1>&2 2>&3)
								[ -z "$TARGET_FPS" ] && continue
							else
								TARGET_FPS="$SUB_CHOICE"
							fi

							if [[ ! "$TARGET_FPS" =~ ^[0-9]+(\.[0-9]+)?$ ]]; then
								whiptail --msgbox "Error: Invalid FPS format. Please enter a valid number." 8 50
								continue
							fi

							OUTPUT_FILE="${DIR_NAME}/${FILENAME_NO_EXT}_${TARGET_FPS}fps.${EXTENSION}"
							execute_command ffmpeg -y -i "$INPUT_FILE" -r "$TARGET_FPS" -c:a copy "$OUTPUT_FILE"
							return 0
							;;
					esac
				done
				;;
			FX)
				while true; do
					SUB_CHOICE=$(show_video_fx_menu)
					[ -z "$SUB_CHOICE" ] && break
					case "$SUB_CHOICE" in
						BACK) break ;;
						GRAY)
							OUTPUT_FILE="${DIR_NAME}/${FILENAME_NO_EXT}_grayscale.${EXTENSION}"
							execute_command ffmpeg -y -i "$INPUT_FILE" -vf "eq=saturation=0" -c:a copy "$OUTPUT_FILE"
							return 0
							;;
						SEPIA)
							OUTPUT_FILE="${DIR_NAME}/${FILENAME_NO_EXT}_sepia.${EXTENSION}"
							execute_command ffmpeg -y -i "$INPUT_FILE" -vf "colorchannelmixer=.393:.769:.189:0:.349:.686:.168:0:.272:.534:.131" -c:a copy "$OUTPUT_FILE"
							return 0
							;;
					esac
				done
				;;
			AUDIO_EXT)
				OUTPUT_FILE="${DIR_NAME}/${FILENAME_NO_EXT}_audio.mp3"
				execute_command ffmpeg -y -i "$INPUT_FILE" -q:a 0 -map a "$OUTPUT_FILE"
				return 0
				;;
			MUTE)
				OUTPUT_FILE="${DIR_NAME}/${FILENAME_NO_EXT}_muted.${EXTENSION}"
				execute_command ffmpeg -y -i "$INPUT_FILE" -c:v copy -an "$OUTPUT_FILE"
				return 0
				;;
		esac
	done
}

# ==========================================
#              IMAGE TUI LOGIC
# ==========================================
show_image_main_menu() {
	whiptail --title "Image Processing TUI" --menu "Select an operation for: $BASE_NAME" 18 55 6 \
			 "COMP" "Compression & Quality Menu..." \
			 "RESIZE" "Resize & Dimensions Menu..." \
			 "CONV" "Convert Format Menu..." \
			 "FX" "Filters & Color Effects Menu..." \
			 "STRIP" "Strip Metadata (ExifTool)" \
			 "EXIT" "Exit Script" \
			 3>&1 1>&2 2>&3
}
show_compression_menu() {
	whiptail --title "Compression Options" --menu "Select Quality" 18 50 7 \
			 "50%" "Compress at 50%" \
			 "70%" "Compress at 70%" \
			 "75%" "Compress at 75%" \
			 "80%" "Compress at 80%" \
			 "90%" "Compress at 90%" \
			 "CUSTOM" "Custom quality" \
			 "BACK" "Go Back" \
			 3>&1 1>&2 2>&3
}
show_resize_menu() {
	whiptail --title "Resize Options" --menu "Select Size" 19 60 8 \
			 "25%" "Resize at 25%" \
			 "50%" "Resize at 50%" \
			 "75%" "Resize at 75%" \
			 "1920x1080" "Resize at 1920x1080 px" \
			 "800x600" "Resize at 800x600 px" \
			 "CUSTOM" "Custom resize" \
			 "BACK" "Go Back" \
			 3>&1 1>&2 2>&3
}
show_convert_menu() {
	whiptail --title "Conversion Options" --menu "Select Target Format" 18 55 6 \
			 "GIF" "Convert to GIF" \
			 "JPEG" "Convert to JPEG" \
			 "PNG" "Convert to PNG" \
			 "WEBP" "Convert to WEBP" \
			 "PDF" "Convert to PDF" \
			 "BACK" "Go Back" \
			 3>&1 1>&2 2>&3
}
show_image_fx_menu() {
	whiptail --title "Image Effects Menu" --menu "Select an effect" 17 55 5 \
			 "GRAY" "Grayscale (Black & White)" \
			 "SEPIA" "Sepia Tone (Vintage Look)" \
			 "ALPHA" "Change Transparent Background to Color" \
			 "BACK" "Go Back" \
			 3>&1 1>&2 2>&3
}

process_image() {
	while true; do
		MAIN_CHOICE=$(show_image_main_menu)
		[ -z "$MAIN_CHOICE" ] && exit 0
		case "$MAIN_CHOICE" in
			EXIT) exit 0 ;;
			COMP)
				while true; do
					SUB_CHOICE=$(show_compression_menu)
					[ -z "$SUB_CHOICE" ] && break
					case "$SUB_CHOICE" in
						BACK) break ;;
						CUSTOM)
							SUB_CHOICE=$(whiptail --inputbox "Enter custom quality (1-100):" 8 40 3>&1 1>&2 2>&3)
							[ -z "$SUB_CHOICE" ] && continue
							;;
					esac
					CLEAN_SUF=$(echo "$SUB_CHOICE" | tr -d '%')
					OUTPUT_FILE="${DIR_NAME}/${FILENAME_NO_EXT}_compressed_${CLEAN_SUF}.${EXTENSION}"
					execute_command magick "$INPUT_FILE" -quality "${CLEAN_SUF}%" "$OUTPUT_FILE"
					return 0
				done
				;;
			RESIZE)
				while true; do
					SUB_CHOICE=$(show_resize_menu)
					[ -z "$SUB_CHOICE" ] && break
					case "$SUB_CHOICE" in
						BACK) break ;;
						CUSTOM)
							SUB_CHOICE=$(whiptail --inputbox "Enter size (e.g. 800x600 or 40%):" 8 40 3>&1 1>&2 2>&3)
							[ -z "$SUB_CHOICE" ] && continue
							;;
					esac
					CLEAN_SUF=$(echo "$SUB_CHOICE" | tr -d '%')
					OUTPUT_FILE="${DIR_NAME}/${FILENAME_NO_EXT}_resized_${CLEAN_SUF}.${EXTENSION}"
					execute_command magick "$INPUT_FILE" -resize "$SUB_CHOICE" "$OUTPUT_FILE"
					return 0
				done
				;;
			CONV)
				while true; do
					SUB_CHOICE=$(show_convert_menu)
					[ -z "$SUB_CHOICE" ] && break
					case "$SUB_CHOICE" in
						BACK) break ;;
						GIF)   OUTPUT_FILE="${DIR_NAME}/${FILENAME_NO_EXT}_converted.gif"; execute_command magick "$INPUT_FILE" "$OUTPUT_FILE"; return 0 ;;
						JPEG)  OUTPUT_FILE="${DIR_NAME}/${FILENAME_NO_EXT}_converted.jpg"; execute_command magick "$INPUT_FILE" "$OUTPUT_FILE"; return 0 ;;
						PNG)   OUTPUT_FILE="${DIR_NAME}/${FILENAME_NO_EXT}_converted.png"; execute_command magick "$INPUT_FILE" "$OUTPUT_FILE"; return 0 ;;
						WEBP)  OUTPUT_FILE="${DIR_NAME}/${FILENAME_NO_EXT}_converted.webp"; execute_command magick "$INPUT_FILE" "$OUTPUT_FILE"; return 0 ;;
						PDF)   OUTPUT_FILE="${DIR_NAME}/${FILENAME_NO_EXT}_converted.pdf"; execute_command magick "$INPUT_FILE" "$OUTPUT_FILE"; return 0 ;;
					esac
				done
				;;
			FX)
				while true; do
					SUB_CHOICE=$(show_image_fx_menu)
					[ -z "$SUB_CHOICE" ] && break
					case "$SUB_CHOICE" in
						BACK) break ;;
						GRAY)
							OUTPUT_FILE="${DIR_NAME}/${FILENAME_NO_EXT}_grayscale.${EXTENSION}"
							execute_command magick "$INPUT_FILE" -colorspace gray "$OUTPUT_FILE"
							return 0
							;;
						SEPIA)
							OUTPUT_FILE="${DIR_NAME}/${FILENAME_NO_EXT}_sepia.${EXTENSION}"
							execute_command magick "$INPUT_FILE" -sepia-tone 80% "$OUTPUT_FILE"
							return 0
							;;
						ALPHA)
							BG_COLOR=$(whiptail --inputbox "Enter target background color (e.g. white, black, red, #FF5733):" 8 55 "white" 3>&1 1>&2 2>&3)
							[ -z "$BG_COLOR" ] && continue
							OUTPUT_FILE="${DIR_NAME}/${FILENAME_NO_EXT}_solid_bg.${EXTENSION}"
							execute_command magick "$INPUT_FILE" -background "$BG_COLOR" -alpha remove -alpha off "$OUTPUT_FILE"
							return 0
							;;
					esac
				done
				;;
			STRIP)
				OUTPUT_FILE="${DIR_NAME}/${FILENAME_NO_EXT}_stripped.${EXTENSION}"
				execute_command cp "$INPUT_FILE" "$OUTPUT_FILE"
				execute_command exiftool -all= -overwrite_original "$OUTPUT_FILE"
				return 0
				;;
		esac
	done
}

# ==========================================
#              MAIN EXECUTION
# ==========================================
if [ "$FILE_TYPE" == "VIDEO" ]; then
	process_video
elif [ "$FILE_TYPE" == "AUDIO" ]; then
	process_audio
elif [ "$FILE_TYPE" == "IMAGE" ]; then
	process_image
fi

if [ -n "$OUTPUT_FILE" ] && [ -f "$OUTPUT_FILE" ]; then
	echo -e "\nOperation complete! File saved as: $OUTPUT_FILE"
fi
