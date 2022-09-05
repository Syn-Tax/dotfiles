#!/usr/bin/env bash

picom --experimental-backends --backend glx &
feh --bg-fill ~/wallpapers/0026.jpg &
dunst &
emacs --daemon &
xrdb /home/oscar/.Xresources
xinput set-prop 22 "libinput Tapping Enabled" 1
xinput set-prop 22 "libinput Natural Scrolling Enabled" 1
/home/oscar/scripts/automount-google-drive.sh
offlineimap &
sudo /home/oscar/.local/bin/kmonad /home/oscar/.config/kmonad/keymap.kbd &
setxkbmap us
