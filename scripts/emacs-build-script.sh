#!/bin/bash

# Exit on error
set -e

echo "Starting Emacs build process..."

# Function to check if command succeeded
check_status() {
  if [ $? -eq 0 ]; then
    echo "✓ $1 completed successfully"
  else
    echo "✗ $1 failed"
    exit 1
  fi
}

# Create directory for build
BUILD_DIR="$HOME/emacs-build"
mkdir -p "$BUILD_DIR"
cd "$BUILD_DIR"

echo "Installing required dependencies..."
sudo apt install -y \
  build-essential \
  libgtk-3-dev \
  libgnutls28-dev \
  libtiff5-dev \
  libgif-dev \
  libjpeg-dev \
  libpng-dev \
  libxpm-dev \
  libncurses-dev \
  texinfo
check_status "Base dependencies installation"

# Install JSON support dependencies
echo "Installing JSON support dependencies..."
sudo apt install -y libjansson4 libjansson-dev
check_status "JSON dependencies installation"

# Install JIT compilation dependencies
# echo "Installing JIT compilation dependencies..."
# sudo apt install -y \
#     libgccjit0 \
#     libgccjit-10-dev \
#     gcc-10 \
#     g++-10
check_status "JIT compilation dependencies installation"

# Install imagemagick dependencies
echo "Installing imagemagick dependencies..."
sudo apt install -y libmagickcore-dev libmagick++-dev
check_status "Imagemagick dependencies installation"

# Install tree-sitter dependencies
echo "Installing tree-sitter dependencies..."
sudo apt install -y libtree-sitter-dev
check_status "Tree-sitter dependencies installation"

# Clone Emacs repository
echo "Cloning Emacs repository..."
if [ "$1" = "--shallow" ]; then
  git clone --depth=1 https://git.savannah.gnu.org/git/emacs.git
else
  git clone --depth=1 https://git.savannah.gnu.org/git/emacs.git
fi
check_status "Repository cloning"

# Build Emacs
cd emacs
export CC=/usr/bin/gcc-10 CXX=/usr/bin/gcc-10

echo "Running autogen..."
./autogen.sh
check_status "Autogen"

echo "Configuring build..."
./configure \
  --with-native-compilation \
  --with-json \
  --with-tree-sitter \
  --with-imagemagick \
  --with-xwidgets
check_status "Configure"

echo "Building Emacs..."
make --jobs=$(nproc)
check_status "Make"

echo "Installing Emacs..."
sudo make install
check_status "Installation"

echo "
====================================
Emacs build and installation complete!
====================================

Your new Emacs installation should be available at /usr/local/bin/emacs

Note: The first time you run Emacs, it will byte-compile all installed packages.
This is normal and may take some time.

Usage:
- Run 'emacs' to start the GUI version
- Run 'emacs -nw' to start in terminal mode
"
