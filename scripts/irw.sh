#!/usr/bin/env bash

# Prompt the user to input the Instagram reel URL
read -p "Enter the Instagram reel URL: " REEL_URL

# Validate URL format (basic check)
if [[ ! "$REEL_URL" =~ ^https://www.instagram.com/reel/ ]]; then
    echo "Invalid URL. Please provide a valid Instagram reel URL."
    exit 1
fi

# Replace 'reel' with 'p' to convert the URL from reel to post
POST_URL="${REEL_URL/reel/p}"

# Print the converted URL (optional, for verification)
echo "Converted URL: $POST_URL"

# Run yt-dlp to download the video
yt-dlp "$POST_URL"
