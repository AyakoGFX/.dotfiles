#!/usr/bin/env bash


# testing

# Function to confirm user choice
confirm() {
    read -p "$1 (y/n): " -n 1 -r
    echo    # Move to a new line after user input
    if [[ $REPLY =~ ^[Yy]$ ]]; then
        return 0  # True
    else
        return 1  # False
    fi
}
cd
echo "Do you want to update the system?"

# update
if confirm "Update the system?"; then
    echo "Updating the system"
    sudo pacman -Suy --noconfirm
    clear
else
    echo "Update canceled."
fi


# Installing yay
sudo pacman -S --noconfirm --needed base-devel git
git clone https://aur.archlinux.org/yay.git
cd yay
makepkg -si


sudo pacman -S --noconfirm stow


# Bluetooth
echo "Do you want to install Bluetooth packages?"
echo "bluez-utils, bluez, blueman"
# Ask for confirmation
if confirm "Install Bluetooth packages?"; then
    echo "Downloading Bluetooth"
    sudo pacman -S --noconfirm bluez-utils
    sudo pacman -S --noconfirm bluez
    sudo pacman -S --noconfirm blueman
    clear
else
    echo "Installation of Bluetooth packages aborted."
fi


#!/usr/bin/env bash

# Prompt user to choose a terminal emulator
echo "Which terminal emulator do you want to install?"
echo "1. kitty"
echo "2. alacritty"
echo "3. Skip"
read -p "Enter your choice (1, 2, or 3): " choice

# Check user input and install the chosen terminal emulator or skip
case $choice in
    1)
        sudo pacman -S kitty
        clear
        ;;
    2)
        sudo pacman -S alacritty
        clear
        ;;
    3)
        echo "Skipping terminal emulator installation."
        ;;
    *)
        echo "Invalid choice. Please enter 1, 2, or 3."
        exit 1
        ;;
esac

# Prompt user to choose additional browsers
echo "Do you want to install additional browsers?"
echo "1. Chromium"
echo "2. Firefox"
echo "3. Skip"
read -p "Enter your choice (1, 2, or 3): " browser_choice

# Check user input and install the chosen browser(s) or skip
case $browser_choice in
    1)
        sudo pacman -S chromium
        ;;
    2)
        sudo pacman -S firefox
        ;;
    3)
        echo "Skipping additional browsers installation."
        ;;
    *)
        echo "Invalid choice. Please enter 1, 2, or 3."
        exit 1
        ;;
esac

echo "Installation complete."


# Install Policy Kit 
echo "Want To Install Policy Kit Important!"
if confirm "Install Policy Kit "; then
    sudo pacman -S --noconfirm polkit-gnome 
    clear
else
    echo "not installed"
fi


# install emacs and nvim
echo "install emacs and nvim"
if confirm "installing editor's"; then
    sudo pacman -S --noconfirm neovim
    sudo pacman -S --noconfirm emacs
    clear
else
    echo "not installed"
fi


# git stuff
echo "want git stuff"
if confirm "installing"; then
  yay -S --noconfirm github-desktop-bin
else
    echo "not installed"
fi

# audio setup
echo "audio pipewire"
if confirm "installing"; then
sudo pacman -S --noconfirm pipewire-pulse pipewire-alsa
else
    echo "not installed"
fi


# audio setup
echo "visual-studio-code-bin"
if confirm "installing"; then
sudo pacman -S --noconfirm visual-studio-code-bin

else
    echo "not installed"
fi

sudo pacman -S --noconfirm hunspell-en_US ispell hunspell

