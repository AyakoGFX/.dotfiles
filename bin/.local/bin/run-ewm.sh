#!/usr/bin/env bash

# Set essential Wayland session variables
export XDG_CURRENT_DESKTOP=wlroots
export XDG_SESSION_TYPE=wayland

# Launch EWM
EWM_MODULE_PATH=/home/xshwa/ewm/compositor/target/debug/libewm_core.so \
  emacs --fg-daemon -L /home/xshwa/ewm/lisp -l ewm -f ewm-start-module
