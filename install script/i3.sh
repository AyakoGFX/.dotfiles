#!/bin/bash

# Install i3ipc using paru
paru i3ipc

# Choose glib2
# Note: You might need to manually choose glib2 here depending on your paru configuration.
# If prompted, select the version you prefer.
paru i3-workspaces

yay -S i3-auto-layout

# Install ttf-firacode-nerd using pacman
sudo pacman -S ttf-firacode-nerd

# Install nitrogen using pacman
sudo pacman -S nitrogen

# Install i3 window manager using pacman
sudo pacman -S i3

git clone https://github.com/marcoplaitano/wallpapers.git ~/Pictures
