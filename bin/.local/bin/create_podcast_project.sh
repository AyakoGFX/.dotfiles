#!/usr/bin/env bash

# Usage:
#   ./create_podcast_project.sh "Ep12_BigTalk"

# Check for argument
if [ -z "$1" ]; then
  echo "Usage: $0 <project_name>"
  exit 1
fi

PROJECT_NAME="$1"

# Create the main project folder
mkdir -p "$PROJECT_NAME" || { echo "Failed to create project folder"; exit 1; }

# Create subfolders
mkdir -p "$PROJECT_NAME"/{00_RAW,01_TRANSCRIPTS,02_PROJECT_FILES,03_CLIPS/horizontal,03_CLIPS/vertical,04_SOCIAL_ASSETS/{captions,thumbnails,overlays}}

# Create a README file
cat > "$PROJECT_NAME/README.md" <<EOF
# $PROJECT_NAME

Project created on: $(date '+%Y-%m-%d')

## Folder guide:
- 00_RAW: Original podcast audio/video (do not edit)
- 01_TRANSCRIPTS: Transcripts, timestamps, notes
- 02_PROJECT_FILES: Video editing project files
- 03_CLIPS: Final exported clips
  - horizontal/: YouTube, desktop
  - vertical/: TikTok, Shorts, Reels
- 04_SOCIAL_ASSETS: Captions, thumbnails, overlays
EOF

echo "✅ Podcast project '$PROJECT_NAME' has been created!"

