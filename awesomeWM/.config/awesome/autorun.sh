#!/usr/bin/env bash
function run {
    if ! pgrep $1 > /dev/null ;
    then
        $@&
    fi
}


# Autostart GNOME Polkit Authentication Agent only for nixos users for mode details ---> https://nixos.wiki/wiki/Polkit
/nix/store/$(ls -la /nix/store | grep 'polkit-gnome' | grep -v 'fish-completions' | grep '4096' | awk '{print $9}' | sed -n '$p')/libexec/polkit-gnome-authentication-agent-1 &

run sxhkd &
run libinput-gestures &
run nitrogen --restore &
run picom --backend glx &
run emacs --daemon &
run nm-applet &
run copyq &
run slstatus &
run flameshot &

# Set keyboard repeat rate
run xset r rate 250 60 &
xinput --set-prop 19 "libinput Accel Speed" -0.6 &
setxkbmap -option caps:swapescape &

#/usr/lib/policykit-1-gnome/polkit-gnome-authentication-agent-1 &
#/usr/lib/x86_64-linux-gnu/xfce4/notifyd/xfce4-notifyd &


#clipmenud &
#blueman-applet &
#volapplet &
#cbatticon &

# set screan to  1920x1080 --rate 144.00
# xrandr --output eDP --mode 1920x1080 --rate 144.00 &
# xrandr --output eDP --mode 1920x1080 --rate 60.02 &

# dwmblocks &
# /usr/lib/polkit-gnome/polkit-gnome-authentication-agent-1 &

# mouse speed
# xinput --set-prop '19' 'libinput Accel Profile Enabled' 0 1 0
# xinput --set-prop '19' 'libinput Accel Speed' -0.1

# yay -S picom-ftlabs-git
# picom --animations -b &

# setwall 1 &
# for more info >> https://github.com/zeroruka/video-wallpaper-scripts.git
