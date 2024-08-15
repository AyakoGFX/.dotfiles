eza
papirus-icon-theme 
arc-gtk-theme
lxappearance



sudo pacman -S --noconfirm --needed btrfs-assistant
sudo pacman -S --noconfirm --needed grub-btrfs
sudo pacman -S --noconfirm --needed snap-pac-git
sudo pacman -S --noconfirm --needed snapper
sudo pacman -S --noconfirm --needed snapper-tools-git
sudo pacman -S --noconfirm --needed snapper-support


sudo umount /.snapshots
sudo rm -r /.snapshots

sudo snapper -c root create-config /

echo "first manual snapshot"

snapper -c root create --description "initial snapshot"

sudo chmod a+rx /.snapshots
sudo chown :users /.snapshots

