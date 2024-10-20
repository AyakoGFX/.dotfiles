#!/bin/bash

# Function to check if the system is Arch-based
is_arch() {
    command -v pacman &> /dev/null
}

# Function to check if the system is Debian-based
is_debian() {
    command -v apt &> /dev/null
}

# Install Noto Color Emoji fonts
if is_debian; then
    echo "Detected Debian-based system. Installing Noto Color Emoji fonts..."
    sudo nala install fonts-noto-color-emoji
    sudo nala install fonts-noto
elif is_arch; then
    echo "Detected Arch-based system. Installing Noto Emoji fonts..."
    yay -S noto-fonts-emoji
else
    echo "Unsupported operating system."
    exit 1
fi

# Create font configuration for emoji
echo "Creating emoji font configuration..."
cat <<EOL | sudo tee /etc/fonts/conf.d/02-emoji.conf
<?xml version="1.0"?>
<!DOCTYPE fontconfig SYSTEM "fonts.dtd">
<fontconfig>
  <alias>
    <family>sans-serif</family>
    <prefer>
      <family>Your favorite sans-serif font name</family>
      <family>Noto Color Emoji</family>
      <family>Noto Emoji</family>
    </prefer> 
  </alias>

  <alias>
    <family>serif</family>
    <prefer>
      <family>Your favorite serif font name</family>
      <family>Noto Color Emoji</family>
      <family>Noto Emoji</family>
    </prefer>
  </alias>

  <alias>
    <family>monospace</family>
    <prefer>
      <family>Your favorite monospace font name</family>
      <family>Noto Color Emoji</family>
      <family>Noto Emoji</family>
    </prefer>
  </alias>
</fontconfig>
EOL

echo "Font configuration created successfully."
