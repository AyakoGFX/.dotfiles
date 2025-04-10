#!/usr/bin/env bash
function run {
    if ! pgrep $1 > /dev/null ;
    then
        $@&
    fi
}

waybar &
swaync &
waypaper --restore &
run nm-applet &
emacs --daemon &


# systemctl  --user start xwayland-satellite
# hypridle &
# systemctl --user start hyprpolkitagent
