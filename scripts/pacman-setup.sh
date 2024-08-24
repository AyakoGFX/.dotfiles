#!/bin/bash

# Check for sudo privileges
if [ "$EUID" -ne 0 ]; then
    echo "This script requires sudo privileges. Please enter your password."
    exec sudo "$0" "$@"
    exit $?
fi

# Function to check and install packages
check_and_install() {
    if ! command -v $1 &> /dev/null; then
        echo "$1 is not installed. Installing..."
        pacman -S --noconfirm $1
    fi
}

# Check and install required packages
echo "Checking and installing required packages..."
check_and_install reflector
check_and_install sed
clear

# User input for configuration
echo "Configuring mirror and download settings..."
read -p "Enter the number of mirrors to use (default is 50): " MIRROR_COUNT
MIRROR_COUNT=${MIRROR_COUNT:-50}

read -p "Enter the number of parallel downloads (default is 7): " PARALLEL_DOWNLOADS
PARALLEL_DOWNLOADS=${PARALLEL_DOWNLOADS:-7}

# Update mirror list
echo "Updating mirror list..."
sudo reflector --verbose --sort rate -l $MIRROR_COUNT --save /etc/pacman.d/mirrorlist

# Update pacman.conf
echo "Modifying pacman.conf..."
sed -i '/^# *ParallelDownloads/s/^# *//' /etc/pacman.conf
sed -i "s/^ParallelDownloads *= *[0-9]*/ParallelDownloads = $PARALLEL_DOWNLOADS/" /etc/pacman.conf
sed -i '/^# *Color/s/^# *//' /etc/pacman.conf

# Add ILoveCandy if not present
if ! grep -q "ILoveCandy" /etc/pacman.conf; then
    echo "Adding ILoveCandy option..."
    sed -i '/^Color/a ILoveCandy' /etc/pacman.conf
fi

echo "Setup complete! Mirror list updated and pacman.conf modified with $PARALLEL_DOWNLOADS parallel downloads."