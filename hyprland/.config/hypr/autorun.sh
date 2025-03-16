#!/usr/bin/env bash
function run {
    if ! pgrep $1 > /dev/null ;
    then
        $@&
    fi
}

waybar &
waypaper --restore &
run nm-applet &
run copyq &
emacs --daemon &
flameshot &
hypridle &
systemctl --user start hyprpolkitagent
