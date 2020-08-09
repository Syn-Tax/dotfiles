#!/usr/bin/env bash
sshfs pi@192.168.1.124:/home/pi /home/oscar/RPI -C
flameshot &
picom --experimental-backends --backend glx &
feh --bg-fill ~/wallpapers/0051.jpg &
