#!/usr/bin/env bash
function run {
    if ! pgrep $1 > /dev/null ;
    then
        $@&
    fi
}

run emacs --daemon &
run nm-applet &
run waybar &
run copyq &
run flameshot &
run systemctl --user start hyprpolkitagent
