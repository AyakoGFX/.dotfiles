#!/usr/bin/env bash
cd ~/.dotfiles/hyprland/.config/wlogout/icons

# Loop through the PNG files
for img in hibernate.png lock.png logout.png reboot.png shutdown.png suspend.png; do
    # Convert the image to white
    convert "$img" -fill white -colorize 100% "new_$img"
    # Remove the old image
    rm "$img"
    # Rename the new image to the original name
    mv "new_$img" "$img"
done
