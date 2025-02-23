# Never struggle again with Nvidia drivers on Linux! NVIDIA ALL by TkG on Arch / Arch based distros
# https://youtu.be/QW2XGMAu6VE?si=PMBb5ythCTDZiX87
# https://github.com/Frogging-Family/nvidia-all.git


# pacman -S --noconfirm nvidia
 
 # https://github.com/xerolinux/xlapit-cli/blob/main/xero-scripts/scripts/drivers.sh
# echo "open me" 

read -rp "Older 900/1000 series or Newer 1650ti/1660ti/20 series and up? (o/n): " nvidia_series
if [[ $nvidia_series == "o" || $nvidia_series == "1000" ]]; then
  sudo pacman -S --needed --noconfirm linux-headers nvidia-dkms nvidia-utils lib32-nvidia-utils nvidia-settings vulkan-icd-loader lib32-vulkan-icd-loader egl-wayland opencl-nvidia lib32-opencl-nvidia libvdpau-va-gl libvdpau
elif [[ $nvidia_series == "n" ]]; then
  sudo pacman -S --needed --noconfirm linux-headers nvidia-open-dkms nvidia-utils lib32-nvidia-utils nvidia-settings vulkan-icd-loader lib32-vulkan-icd-loader egl-wayland opencl-nvidia lib32-opencl-nvidia libvdpau-va-gl libvdpau
else
  echo "Invalid selection."
  return
fi
