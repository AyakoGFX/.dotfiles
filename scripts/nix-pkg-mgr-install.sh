#!/usr/bin/env bash

 # Check if Nix package manager is already installed
if command -v nix-env &> /dev/null; then
    echo "Nix package manager is already installed."
    exit 0
fi
sh <(curl -L https://nixos.org/nix/install) --daemon

# Define the environment variable and its value
VAR_NAME="NIXPKGS_ALLOW_UNFREE"
VAR_VALUE="1"

# Add to ~/.bashrc if not already present
BASHRC_FILE="$HOME/.bashrc"
if ! grep -q "^export $VAR_NAME=$VAR_VALUE" "$BASHRC_FILE"; then
    echo "export $VAR_NAME=$VAR_VALUE" >> "$BASHRC_FILE"
    echo "Added $VAR_NAME to $BASHRC_FILE"
else
    echo "$VAR_NAME already exists in $BASHRC_FILE"
fi

# Add to ~/.config/fish/config.fish if not already present
FISH_CONFIG_FILE="$HOME/.config/fish/config.fish"
if ! grep -q "^set -x $VAR_NAME $VAR_VALUE" "$FISH_CONFIG_FILE"; then
    mkdir -p "$HOME/.config/fish"  # Ensure the directory exists
    echo "set -x $VAR_NAME $VAR_VALUE" >> "$FISH_CONFIG_FILE"
    echo "Added $VAR_NAME to $FISH_CONFIG_FILE"
else
    echo "$VAR_NAME already exists in $FISH_CONFIG_FILE"
fi
