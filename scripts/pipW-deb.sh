#!/usr/bin/env bash

set -e  # Exit immediately if a command exits with a non-zero status

echo "Starting the installation of PipeWire..."

# Step 1: Install PipeWire client libraries
echo "Installing PipeWire client libraries..."
sudo apt install -y pipewire-audio-client-libraries libspa-0.2-bluetooth libspa-0.2-jack

# Step 2: Install WirePlumber and remove pipewire-media-session
echo "Installing WirePlumber and removing pipewire-media-session..."
sudo apt install -y wireplumber pipewire-media-session-

# Step 3: Copy configuration files
echo "Copying configuration files for ALSA and JACK..."
sudo cp /usr/share/doc/pipewire/examples/alsa.conf.d/99-pipewire-default.conf /etc/alsa/conf.d/
sudo cp /usr/share/doc/pipewire/examples/ld.so.conf.d/pipewire-jack-*.conf /etc/ld.so.conf.d/
sudo ldconfig

# Remove the PulseAudio Bluetooth module
echo "Removing PulseAudio Bluetooth module..."
sudo apt remove -y pulseaudio-mo

