# sudo pacman -S --noconfirm --needed amd-ucode
# sudo pacman -S --noconfirm --needed mesa lib32-mesa vulkan-radeon lib32-vulkan-radeon libva-mesa-driver libva-utils

sudo pacman -S --needed --noconfirm mesa xf86-video-amdgpu amdvlk lib32-mesa vulkan-radeon lib32-vulkan-radeon vulkan-icd-loader lib32-vulkan-icd-loader vulkan-mesa-layers lib32-vulkan-mesa-layers libva-mesa-driver lib32-libva-mesa-driver
sudo pacman -S --needed --noconfirm mesa-vdpau lib32-mesa-vdpau rocm-opencl-runtime rocm-hip-runtime
# yay -S lact
# https://github.com/ilya-zlobintsev/LACT.git
# https://youtu.be/um0PibK4Mtk?si=Gcq6GnkqR_rQUOCZ
# Arch Linux | DWM | How to Overclock an AMD GPU | Guide
#
# yay -S lact
# sudo systemctl enable --now lactd
#
#

# Ubuntu Based Distributions
# sudo dpkg --add-architecture i386
#
# sudo add-apt-repository ppa:kisak/kisak-mesa -y
# sudo apt update
# sudo apt install libgl1-mesa-dri:i386 mesa-vulkan-drivers mesa-vulkan-drivers:i386 -y
