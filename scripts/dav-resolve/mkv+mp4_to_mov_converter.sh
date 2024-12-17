#!/usr/bin/env bash


# Updated 18 Nov 2024 to work with one or two audio tracks
# Also see my video at https://www.youtube.com/watch?v=q7lYaF6JENg
#   for a quicker way of running a script file in DaVinci Resolve

# Check if an input file is provided
if [[ \\\\\\\$# -eq 0 ]]; then
    echo "Usage: \\\\\\\$0 <input_mkv_file> [framerate]"
    exit 1
fi

# Get the input file name
input_file=\\\\\\\$1

# Get the framerate (default to 30 if not provided)
framerate=\\\\\\\${2:-30}

# Validate the framerate
if [[ "\\\\\\\$framerate" != "30" && "\\\\\\\$framerate" != "60" ]]; then
    echo "Invalid framerate. Must be 30 or 60."
    exit 1
fi

# Get the number of audio streams
audio_streams=\\\\\\\$(ffprobe -v error -select_streams a -show_entries stream=index -of csv=p=0 "\\\\\\\$input_file" | wc -w)

# Determine the output format based on the number of audio streams
if [[ "\\\\\\\$audio_streams" -eq 1 ]]; then
    # One audio stream: Convert to MOV with merged audio
    ffmpeg -i "\\\\\\\$input_file" -vcodec dnxhd -acodec pcm_s16le -s 1920x1080 -r "\\\\\\\$framerate" -b:v 36M -pix_fmt yuv422p -f mov "\\\\\\\$output_file"
else
    # Two or more audio streams: Convert to MOV without merging audio
    ffmpeg -i "\\\\\\\$input_file" -map 0:v -map 0:a? -c:v dnxhd -acodec pcm_s16le -s 1920x1080 -r "\\\\\\\$framerate" -b:v 36M -pix_fmt yuv422p -f mov "\\\\\\\$output_file"
fi

echo "Conversion completed. Output file: \\\\\\\$output_file"
