#!/bin/bash

# Check if simple-mtpfs is installed, if not, install it
if ! command -v simple-mtpfs &> /dev/null
then
    yay -S simple-mtpfs --noconfirm --needed
fi
clear 
# Display start page with options
echo "Select an option:"
echo "1. Mount devices"
echo "2. Unmount devices"
read -p "Enter your choice: " choice

# Create the ~/phone directory if it doesn't exist
mkdir -p ~/phone
clear

if [ $choice -eq 1 ]
then
    # List the connected MTP devices
    simple-mtpfs -l

    # Ask the user to input the device number
    read -p "Enter the device number to mount: " device_number

    # Mount the specified device to ~/phone
    simple-mtpfs --device $device_number ~/phone
elif [ $choice -eq 2 ]
then
    # Unmount the device mounted at ~/phone
    fusermount -u ~/phone
else
    echo "Invalid choice. Please select 1 or 2."
fi