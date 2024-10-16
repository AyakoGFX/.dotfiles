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

installed_dir=$(dirname $(readlink -f $(basename `pwd`)))

##################################################################################################################

if [ "$DEBUG" = true ]; then
    echo
    echo "------------------------------------------------------------"
    echo "Running $(basename $0)"
    echo "------------------------------------------------------------"
    echo
    read -n 1 -s -r -p "Debug mode is on. Press any key to continue..."
    echo
fi

##################################################################################################################

echo
tput setaf 3
echo "################################################################"
echo "################### Bluetooth"
echo "################################################################"
tput sgr0
echo

func_install() {
    if dpkg -l | grep -q $1; then
        tput setaf 2
        echo "###############################################################################"
        echo "################## The package "$1" is already installed"
        echo "###############################################################################"
        echo
        tput sgr0
    else
        tput setaf 3
        echo "###############################################################################"
        echo "##################  Installing package "  $1
        echo "###############################################################################"
        echo
        tput sgr0
        sudo nala install -y $1
    fi
}

# Remove the check for blueberry since it's not available
# func_install pulseaudio-module-bluetooth
func_install bluez
func_install blueman
func_install libspa-0.2-bluetooth
sudo systemctl enable bluetooth.service
sudo systemctl start bluetooth.service

sudo sed -i 's/#AutoEnable=false/AutoEnable=true/g' /etc/bluetooth/main.conf

if ! grep -q "load-module module-switch-on-connect" /etc/pulse/default.pa; then
    echo 'load-module module-switch-on-connect' | sudo tee --append /etc/pulse/default.pa
fi

if ! grep -q "load-module module-bluetooth-policy" /etc/pulse/default.pa; then
    echo 'load-module module-bluetooth-policy' | sudo tee --append /etc/pulse/default.pa
fi

if ! grep -q "load-module module-bluetooth-discover" /etc/pulse/default.pa; then
    echo 'load-module module-bluetooth-discover' | sudo tee --append /etc/pulse/default.pa
fi


sudo apt install git dkms
git clone https://github.com/jeremyb31/bluetooth-6.5.git
sudo dkms add ./bluetooth-6.5
sudo dkms install btusb/4.1

echo
tput setaf 6
echo "######################################################"
echo "###################  $(basename $0) done reboot now!"
echo "######################################################"
tput sgr0
echo

