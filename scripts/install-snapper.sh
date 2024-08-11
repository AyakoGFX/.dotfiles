#!/bin/bash
#set -e
##################################################################################################################
# Author    : Erik Dubois
# Website   : https://www.erikdubois.be
# Website   : https://www.alci.online
# Website   : https://www.ariser.eu
# Website   : https://www.arcolinux.info
# Website   : https://www.arcolinux.com
# Website   : https://www.arcolinuxd.com
# Website   : https://www.arcolinuxb.com
# Website   : https://www.arcolinuxiso.com
# Website   : https://www.arcolinuxforum.com
##################################################################################################################
#
#   DO NOT JUST RUN THIS. EXAMINE AND JUDGE. RUN AT YOUR OWN RISK.
#
##################################################################################################################
#tput setaf 0 = black
#tput setaf 1 = red
#tput setaf 2 = green
#tput setaf 3 = yellow
#tput setaf 4 = dark blue
#tput setaf 5 = purple
#tput setaf 6 = cyan
#tput setaf 7 = gray
#tput setaf 8 = light blue
##################################################################################################################


yay -S --noconfirm --needed btrfs-assistant
yay -S --noconfirm --needed grub-btrfs
yay -S --noconfirm --needed snap-pac-git
yay -S --noconfirm --needed snapper
yay -S --noconfirm --needed snapper-tools-git
yay -S --noconfirm --needed snapper-support

sudo snapper -c root create-config /

echo "first manual snapshot"

snapper -c root create --description "initial snapshot"

sudo chmod a+rx /.snapshots
sudo chown :users /.snapshots
