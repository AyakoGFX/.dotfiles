#!/usr/bin/env bash
mkdir -p ~/.config/sxhkd/
ln -s "$(pwd)/sxhkdrc" ~/.config/sxhkd/sxhkdrc
ln -s "$(pwd)/libinput-gestures.conf" ~/.config/libinput-gestures.conf

