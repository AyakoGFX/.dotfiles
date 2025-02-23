#!/bin/bash

# Update the system
sudo pacman -Syu

# Essential Packages
sudo pacman -S --noconfirm \
    emacs \
    git \
    pkgconf \
    cmake \
    fd

# Text Processing
sudo pacman -S --noconfirm \
    hunspell hunspell-en_us \
    enchant

# Development Tools
sudo pacman -S --noconfirm \
    base-devel \
    fish \
    tldr \
    stow

# System Utilities
sudo pacman -S --noconfirm \
    acpi \
    brightnessctl \
    ripgrep \
    picom \
    gdu \
    termdown

# Desktop Environment
sudo pacman -S --noconfirm \
    awesome \
    alacritty \
    sxhkd \
    flameshot \
    polkit-gnome \
    eog \
    nitrogen \
    copyq \
    vlc \
    ffmpeg \
    pavucontrol \
    yt-dlp \
    file-roller

sudo pacman -S --noconfirm \
    lightdm \
    lightdm-gtk-greeter
    
sudo systemctl enable lightdm
sudo systemctl start lightdm


# Utilities
sudo pacman -S --noconfirm \
    zoxide \
    eza \
    trash-cli \
    ugrep \
    neofetch \
    fastfetch \
    openrgb \
    xfce4-taskmanager \
    gvfs \
    xdotool \
    xorg-xwininfo \
    network-manager-applet

# Appearance and Themes
sudo pacman -S --noconfirm \
    lxappearance \
    kvantum \
    qt5ct \
    arc-gtk-theme \
    papirus-icon-theme

# Audio Packages
sudo pacman -S --noconfirm \
    pipewire-pulse \
    pipewire-alsa

# Fonts
sudo pacman -S --noconfirm \
    ttf-firacode-nerd \
    ttf-jetbrains-mono-nerd \
    noto-fonts \
    emoji-font \
    ttf-font \
    ttf-ms-fonts \
    ttf-liberation \
    terminus-font

# AUR Packages
sudo yay -S \
    bitwarden-bin \
    github-desktop \
    normcap

echo "Installation complete!"