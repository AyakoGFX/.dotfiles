#!/bin/bash

# Function to install libinput based on the available package manager
install_libinput() {
    if command -v apt &> /dev/null; then
        echo "Detected Debian-based system. Installing libinput..."
        sudo apt update
        sudo apt install -y xserver-xorg-input-libinput
    elif command -v pacman &> /dev/null; then
        echo "Detected Arch-based system. Installing libinput..."
        sudo pacman -S --noconfirm xf86-input-libinput
    elif command -v dnf &> /dev/null; then
        echo "Detected Red Hat-based system. Installing libinput..."
        sudo dnf install -y xorg-x11-drv-libinput
    else
        echo "Unsupported system. Please install libinput manually."
        exit 1
    fi
}

# Function to create touchpad configuration
create_touchpad_conf() {
    local config_path="/etc/X11/xorg.conf.d/30-touchpad.conf"
    
    if [ ! -d /etc/X11/xorg.conf.d/ ]; then
        echo "Creating directory /etc/X11/xorg.conf.d/..."
        sudo mkdir -p /etc/X11/xorg.conf.d/
    fi
    
    echo "Creating configuration file $config_path..."
    sudo tee "$config_path" > /dev/null <<EOL
Section "InputClass"
    Identifier "touchpad"
    Driver "libinput"
    MatchIsTouchpad "on"
    Option "Tapping" "on"
    Option "NaturalScrolling" "true"
    Option "ClickMethod" "clickfinger"
    Option "TapButton1" "1"
    Option "TapButton2" "3"
    Option "TapButton3" "2"
    Option "ScrollMethod" "button"
    Option "ScrollButton" "2"
EndSection
EOL

    echo "Touchpad configuration created successfully."
}

# Main script execution
install_libinput
create_touchpad_conf

echo "Setup completed. Please restart your X session to apply the changes."
