#!/usr/bin/env bash

file="$HOME/.config/rofi/bookmark" # file to store bookmarks in
browser="chromium"      # supports CTRL+L to go to address bar.
fileManager="pcmanfm"   # supports CTRL+L to go to address bar.

function getUrlFromBookmarkEntry 
{
    bookmark="$(cat "$file" | rofi -dmenu -p ":")"
    if [ -z "$bookmark" ]; then 
        exit 1 
    fi

    echo "$(echo "$bookmark" | cut -d '|' -f 2- | xargs)"
}

# if no arguments
if [ $# -eq 0 ]; then
    pid="$(xdotool getactivewindow)"
    activeApp="$(xprop -id $pid | grep WM_CLASS | cut -d '"' -f 2)"
    notify-send "Active app: $activeApp"

    if [[ "$activeApp" = "$browser"  ||  "$activeApp" = "$fileManager" ]]; then
        xdotool activatewindow $pid
        sleep 0.1
        xdotool key --clearmodifiers Control_L+l Control_L+a Control_L+c
        xdotool keyup Meta_L Meta_R Alt_L Alt_R Super_L Super_R # release all modifiers, otherwise they will be stuck.
    fi

    bookmark="$(xclip -o | xargs)"

    if [ -z "$bookmark" ]; then
        exit 1
    fi

    title="$(echo "$bookmark" | rofi -dmenu -p "title:")"

    if [ -z "$title" ]; then
        exit 1
    fi

    printf "%-40s | %s\n" "$title" "$bookmark" | tee -a "$file"

elif [ "$1" = "insert" ]; then
    xdotool type "$(getUrlFromBookmarkEntry)"
elif [ "$1" = "open" ]; then
    xdg-open "$(getUrlFromBookmarkEntry)"
fi
