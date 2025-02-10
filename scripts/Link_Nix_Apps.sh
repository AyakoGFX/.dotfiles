#!/usr/bin/env bash

# Define directories
NIX_APPS_DIR="$HOME/.nix-profile/share/applications"
LOCAL_APPS_DIR="$HOME/.local/share/applications"

NIX_ICONS_DIR="$HOME/.nix-profile/share/icons/hicolor/256x256/apps"
LOCAL_ICONS_DIR="$HOME/.local/share/icons/hicolor/scalable/apps"

# Function to create symbolic links
link_apps() {
    mkdir -p "$LOCAL_APPS_DIR" "$LOCAL_ICONS_DIR"

    if [ -d "$NIX_APPS_DIR" ]; then
        for file in "$NIX_APPS_DIR"/*; do
            if [ -f "$file" ]; then
                ln -sf "$file" "$LOCAL_APPS_DIR/"
                echo "Linked application: $file"
            fi
        done
    else
        echo "Source directory for applications does not exist: $NIX_APPS_DIR"
    fi

    if [ -d "$NIX_ICONS_DIR" ]; then
        for file in "$NIX_ICONS_DIR"/*; do
            if [ -f "$file" ]; then
                ln -sf "$file" "$LOCAL_ICONS_DIR/"
                echo "Linked icon: $file"
            fi
        done
    else
        echo "Source directory for icons does not exist: $NIX_ICONS_DIR"
    fi

    echo "Symbolic links created successfully."
}

# Function to remove symbolic links
unlink_apps() {
    if [ -d "$LOCAL_APPS_DIR" ]; then
        rm -f "$LOCAL_APPS_DIR"/*
        echo "Removed application links from: $LOCAL_APPS_DIR"
    else
        echo "No application directory found: $LOCAL_APPS_DIR"
    fi

    if [ -d "$LOCAL_ICONS_DIR" ]; then
        rm -f "$LOCAL_ICONS_DIR"/*
        echo "Removed icon links from: $LOCAL_ICONS_DIR"
    else
        echo "No icon directory found: $LOCAL_ICONS_DIR"
    fi

    echo "All symbolic links removed successfully."
}

# Main script logic
echo "Do you want to (L)ink or (U)nlink applications? (L/U)"
read -r choice

case "$choice" in
    [lL])
        link_apps
        ;;
    [uU])
        unlink_apps
        ;;
    *)
        echo "Invalid choice. Please enter 'L' to link or 'U' to unlink."
        ;;
esac

