#!/usr/bin/env bash
#sshfs pi@192.168.1.124:/home/pi /home/oscar/RPI -C
picom --experimental-backends --backend glx &
feh --bg-fill ~/wallpapers/0026.jpg &
flameshot &
dunst &
libinput-gestures &
/home/oscar/scripts/github-sync.sh &
brightnessctl s 50%
syndaemon -i 0.5 -k &
emacs --daemon &
setxkbmap -option caps:swapescape
ulauncher --hide-window &
#onboard &
