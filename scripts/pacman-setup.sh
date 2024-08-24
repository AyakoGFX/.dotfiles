#!/bin/bash

# Check if running as root
if [ "$EUID" -ne 0 ]; then
    echo "Please run as root"
    exit 1
fi

# Ask user for number of mirrors
read -p "Enter the number of mirrors to use (default is 70): " MIRROR_COUNT
MIRROR_COUNT=${MIRROR_COUNT:-70}

# Check if reflector is installed, if not, install it
if ! command -v reflector &> /dev/null; then
    echo "reflector is not installed. Installing..."
    pacman -S --noconfirm reflector
fi

# Check if sed is installed, if not, install it
if ! command -v sed &> /dev/null; then
    echo "sed is not installed. Installing..."
    pacman -S --noconfirm sed
fi

# Update mirror list
reflector --verbose --sort rate -l $MIRROR_COUNT --save /etc/pacman.d/mirrorlist

# Update pacman.conf
sed -i 's/^#ParallelDownloads = 5/ParallelDownloads = 5/' /etc/pacman.conf
sed -i '/^#Color/s/^#//' /etc/pacman.conf
sed -i '/^Color/a ILoveCandy' /etc/pacman.conf

echo "Mirror list updated with $MIRROR_COUNT mirrors and pacman.conf modified."

# Usage Examples:
#
# 1. Sort 30 latest mirrors by speed:
#    sudo reflector --verbose --sort rate -l 30 --save /etc/pacman.d/mirrorlist
#
# 2. Sort 30 latest mirrors by delay time:
#    sudo reflector --verbose --sort delay -l 30 --save /etc/pacman.d/mirrorlist
#
# 3. Sort 30 latest mirrors from specific countries (Italy and France):
#    sudo reflector --verbose --sort rate -l 30 -c Italy -c France --save /etc/pacman.d/mirrorlist
#
# 4. Sort 15 latest HTTPS-only mirrors by speed:
#    sudo reflector --verbose --sort rate -l 15 -p https --save /etc/pacman.d/mirrorlist