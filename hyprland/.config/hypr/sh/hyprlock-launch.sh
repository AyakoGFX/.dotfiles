#!/usr/bin/env sh
# Made by ChatGpt so don't Ask Me How It Works It Just Work

# Get the wallpaper path using grep and cut
WALLPAPER=$(waypaper --list | grep -oP '"wallpaper": *"\K[^"]+')

# Ensure a valid path is returned
if [ -n "$WALLPAPER" ]; then
    # Update hyprlock.conf with the correct wallpaper path
    sed -i "s|path = .*|path = $WALLPAPER|" ~/.config/hypr/hyprlock.conf
fi

# Launch hyprlock
hyprlock


############################ 
# using swww query 
# #!/bin/sh
# # Get the current wallpaper path from swww
# WALLPAPER=$(swww query | grep 'currently displaying: image:' | awk -F ': ' '{print $3}')

# # Ensure a valid path is returned
# if [ -n "$WALLPAPER" ]; then
#     # Update hyprlock.conf with the correct wallpaper path
#     sed -i "s|path = .*|path = $WALLPAPER|" ~/.config/hypr/hyprlock.conf
# fi

