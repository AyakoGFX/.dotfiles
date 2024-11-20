#!/usr/bin/env bash

# TODO add open suse installer
# sudo zypper in nim Mesa libmfx-gen libXext-devel-32bit libXrandr-devel

# Function to install dependencies and build for Arch-based distros
install_arch() {
    sudo pacman -S --noconfirm --needed nim mesa libfx11 libxext lib32-libxext libxrandr 
    mkdir -p ~/.zoom
    cd ~/.zoom
    git clone https://github.com/tsoding/boomer.git ~/.zoom
    nimble build -d:developer
}

install_opensuse() {
    sudo zypper in nim Mesa libmfx-gen libXext-devel-32bit libXrandr-devel
    mkdir -p ~/.zoom
    cd ~/.zoom
    git clone https://github.com/tsoding/boomer.git ~/.zoom
    nimble build -d:developer
}

# Function to install dependencies and build for Debian-based distros
install_debian() {
    sudo apt-get update
    sudo apt-get install -y nim libgl1-mesa-dev libx11-dev libxext-dev libxrandr-dev
    mkdir -p ~/.zoom
    cd ~/.zoom
    git clone https://github.com/tsoding/boomer.git ~/.zoom
    nimble build -d:developer
}

# Function to create a shell script to run boomer and move it to /usr/local/bin
create_boomer_script() {
    cat << 'EOF' > ~/.zoom/zoom
#!/usr/bin/env bash
cd ~/.zoom
exec ./boomer
EOF
    chmod +x ~/.zoom/zoom
    sudo cp ~/.zoom/zoom /usr/local/bin/zoom
}

# Check the package manager and call the appropriate function
if command -v pacman > /dev/null; then
    install_arch
elif command -v zypper > /dev/null; then
    install_opensuse
elif command -v apt > /dev/null; then
    install_debian
else
    echo "Unsupported distribution"
    exit 1
fi

# Create the boomer script
create_boomer_script

clear
cat << EOF
*TO RUN*
$ zoom

*CONTROLS*
q or ESC: Quit the application.
0 : Reset the application state (position, scale, velocity, etc).
r: Reload configuration.
Ctrl + r: Reload the shaders (only for Developer mode).
f: Toggle flashlight effect.
Drag with left mouse button: Move the image around.
Scroll wheel or =/-: Zoom in/out.
Ctrl + Scroll wheel: Change the radius of the flashlight.
EOF

