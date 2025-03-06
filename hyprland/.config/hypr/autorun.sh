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
run waypaper --restore &
run copyq &
flameshot &
systemctl --user start hyprpolkitagent
