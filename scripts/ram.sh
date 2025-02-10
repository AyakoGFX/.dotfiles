#!/usr/bin/env bash


sudo uptime | lolcat
sudo free -m | lolcat

sudo sync; echo 1 > /proc/sys/vm/drop_caches
sudo sync; echo 2 > /proc/sys/vm/drop_caches
sudo sync; echo 3 > /proc/sys/vm/drop_caches 



sudo swapoff -a
sudo swapon -a

fish
