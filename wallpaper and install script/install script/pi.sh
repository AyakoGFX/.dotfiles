#!/bin/bash

# Update system
sudo pacman -Syu --noconfirm

# Install essential packages
sudo pacman -S --noconfirm base-devel
sudo pacman -S --noconfirm git
sudo pacman -S --noconfirm python
sudo pacman -S --noconfirm nodejs
sudo pacman -S --noconfirm yay
sudo pacman -S --noconfirm cmake
sudo pacman -S --noconfirm npm
sudo pacman -S --noconfirm lua51
sudo pacman -S --noconfirm luajit
sudo pacman -S --noconfirm gcc
sudo pacman -S --noconfirm luarocks
sudo pacman -S --noconfirm neovim
sudo luarocks install luarocks.nvim
sudo pacman -S --noconfirm emacs
sudo pacman -S --noconfirm google-chrome
sudo pacman -S --noconfirm fzf
sudo pacman -S --noconfirm zsh
sudo pacman -S --noconfirm xclip
yay -S --noconfirm paru
yay -S --noconfirm paru-bin
sudo pacman -S gnome-disk-utility
sudo pacman -S baobab
sudo pacman -S ripgrep
sudo pacman -S ttf-firacode-nerd
# sudo pacman -S krusader
# ambaint music player gtk
sudo pacman -S blanket
# yay -S Kmonad-bin
#sudo pacman -S xorg-xmodmap
#sudo pacman -S xorg-xev
#sudo pacman -S xorg-setxkbmap
#sudo pacman -S xorg-xset
#Identifying Keys Script:
# xev | awk -F'[ )]+' '/^KeyPress/ { a[NR+2] } NR in a { printf "%-3s %s\n", $5, $8 }'
# xmodmap -e 'keycode 66 = Escape'
# xmodmap -e 'keycode 108 = Caps_Lock'
# xmodmap -e 'clear lock'
#
#
#
#
#
# Install input-remapper-git
#yay -S input-remapper-git

# Restart input-remapper service
#sudo systemctl restart input-remapper

# Enable input-remapper service to start on boot
#sudo systemctl enable input-remapper

#echo "input-remapper-git installed and configured."
