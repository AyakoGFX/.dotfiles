#!/bin/bash

# Ensure the script is run as root
function check_root() {
    if [ "$EUID" -ne 0 ]; then
        echo "Please run as root"
        exit 1
    fi
}

# Check if git is installed
function check_git() {
    if ! command -v git &> /dev/null; then
        echo "git could not be found, please install git first."
        exit 1
    fi
}

# Clone the repository
function clone_repo() {
    if ! git clone https://github.com/catppuccin/grub.git; then
        echo "Failed to clone the repository."
        exit 1
    fi
    cd grub || exit
}

# Check if the themes directory exists
function check_themes_dir() {
    if [ ! -d /usr/share/grub/themes/ ]; then
        echo "/usr/share/grub/themes/ directory does not exist. Creating it now."
        sudo mkdir -p /usr/share/grub/themes/
    fi
}

# Copy themes to the GRUB themes directory
function copy_themes() {
    sudo cp -r src/* /usr/share/grub/themes/
}

# List available flavors
function list_flavors() {
    echo "Available flavors:"
    echo "🌻 latte"
    echo "🪴 frappe"
    echo "🌺 macchiato"
    echo "🌿 mocha"
}

# Ask for the desired flavor
function ask_flavor() {
    read -p "Enter the flavor you want to use (e.g, mocha): " FLAVOR
}

# Validate the flavor input
function validate_flavor() {
    case "$FLAVOR" in
        latte|frappe|macchiato|mocha)
            ;;
        *)
            echo "Invalid flavor. Please enter one of the listed flavors."
            exit 1
            ;;
    esac
}

# Update /etc/default/grub with the selected theme
function update_grub_config() {
    GRUB_CONFIG="/etc/default/grub"
    if grep -q 'GRUB_THEME' "$GRUB_CONFIG"; then
        sudo sed -i "s|^GRUB_THEME=.*|GRUB_THEME=\"/usr/share/grub/themes/catppuccin-${FLAVOR,,}-grub-theme/theme.txt\"|" "$GRUB_CONFIG"
    else
        echo "GRUB_THEME=\"/usr/share/grub/themes/catppuccin-${FLAVOR,,}-grub-theme/theme.txt\"" | sudo tee -a "$GRUB_CONFIG" > /dev/null
    fi

    # Add GRUB_GFXMODE setting
    if grep -q 'GRUB_GFXMODE' "$GRUB_CONFIG"; then
        sudo sed -i "s|^GRUB_GFXMODE=.*|GRUB_GFXMODE=1920x1080|" "$GRUB_CONFIG"
    else
        echo "GRUB_GFXMODE=1920x1080" | sudo tee -a "$GRUB_CONFIG" > /dev/null
    fi
} 

# Function to update GRUB configuration
function update_grub() {
    echo "Updating grub config..."
    if [[ -x "$(command -v update-grub)" ]]; then
        echo "Running update-grub"
        update-grub
    elif [[ -x "$(command -v grub-mkconfig)" ]]; then
        echo "Running grub-mkconfig -o /boot/grub/grub.cfg"
        grub-mkconfig -o /boot/grub/grub.cfg
    elif [[ -x "$(command -v grub2-mkconfig)" ]]; then
        if [[ -x "$(command -v zypper)" ]]; then
            echo "Running grub2-mkconfig -o /boot/grub2/grub.cfg"
            grub2-mkconfig -o /boot/grub2/grub.cfg
        elif [[ -x "$(command -v dnf)" ]]; then
            echo "Running grub2-mkconfig -o /boot/efi/EFI/fedora/grub.cfg"
            grub2-mkconfig -o /boot/efi/EFI/fedora/grub.cfg
        fi
    fi
}

# Main function to orchestrate the script
function main() {
    check_root
    check_git
    clone_repo
    check_themes_dir
    copy_themes
    list_flavors
    ask_flavor
    validate_flavor
    update_grub_config
    update_grub
    echo "GRUB themes have been updated successfully!"
}

# Execute the main function
main
