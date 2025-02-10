#!/usr/bin/env bash

# Update package list and install dependencies
echo "Installing dependencies..."
sudo apt update
sudo apt install -y build-essential libfftw3-dev libasound2-dev libpulse-dev libtool automake autoconf-archive libiniparser-dev libsdl2-2.0-0 libsdl2-dev libpipewire-0.3-dev libjack-jackd2-dev pkgconf

# Clone the Cava repository
echo "Cloning Cava repository..."
git clone https://github.com/karlstav/cava.git

# Navigate to the Cava directory
cd cava || { echo "Failed to enter Cava directory"; exit 1; }

# Build and install Cava
echo "Building and installing Cava..."
./autogen.sh
./configure
make
sudo make install

echo "Cava installation completed!"

# Optional: Uncomment the following line to uninstall
# make uninstall
