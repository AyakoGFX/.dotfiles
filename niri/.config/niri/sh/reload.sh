#!/usr/bin/env sh

# Kill and reload Waybar
pkill waybar
waybar &

# Kill and restart swaync
pkill swaync
swaync &

echo "Reloaded Waybar and SwayNC."
