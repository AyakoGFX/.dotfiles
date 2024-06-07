#!/bin/bash

# Update system
sudo pacman -Syu

# Install essential packages
sudo pacman -S base-devel           # Development tools
sudo pacman -S git                  # Version control system
sudo pacman -S python               # Python programming language
sudo pacman -S nodejs               # JavaScript runtime
sudo pacman -S yay                  # AUR package manager
sudo pacman -S cmake                # Cross-platform build system
sudo pacman -S npm                  # Node.js package manager
sudo pacman -S lua51                # Lua programming language
sudo pacman -S luajit               # Just-in-time compiler for Lua
sudo pacman -S gcc                  # GNU Compiler Collection
sudo pacman -S luarocks             # Lua package manager
sudo pacman -S neovim               # Vim-based text editor
sudo luarocks install luarocks.nvim # LuaRocks plugin for Neovim
sudo pacman -S emacs                # Extensible text editor
sudo pacman -S google-chrome        # Web browser
sudo pacman -S fzf                  # Command-line fuzzy finder
sudo pacman -S zsh                  # Shell
sudo pacman -S yay -S lazygit       # LazyGit, a simple terminal UI for git commands
sudo pacman -S xclip                # Command line interface to X selections
yay -S paru                         # Another AUR helper
yay -S paru-bin                     # Binary package of Paru AUR helper
sudo pacman -S gnome-disk-utility   # GNOME Disk Utility
sudo pacman -S baobab               # GNOME Disk Usage Analyzer
sudo pacman -S ripgrep              # Line-oriented search tool
sudo pacman -S ttf-firacode-nerd    # Monospaced font with programming ligatures
sudo pacman -S alacritty            # Install Alacritty terminal emulator
sudo pacman -S blueman              # Install the Blueman Bluetooth manager
sudo pacman -S picom                # Install Picom compositor
sudo pacman -S rofi                 # Install Rofi
sudo pacman -S cmake                # Install CMake
sudo pacman -S screenkey            # Install Screenkey
sudo pacman -S vlc                  # Install vlc
sudo pacman -S mpv                  # Install mpv
sudo pacman -S neovide              # Install neovide
yay -S latexrun-git                 # install latexrun

# install fonts
sudo pacman -S ttf-jetbrains-mono-nerd
sudo pacman -S ttf-firacode-nerd
# sudo pacman -S krusader           # Install Krusader file manager
sudo pacman -S blanket # ambaint music player gtk
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
