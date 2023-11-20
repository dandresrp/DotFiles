#!/usr/bin/env bash

killall variety
killall volumeicon

xsetroot -cursor_name left_ptr
setxkbmap -layout us -variant altgr-intl
/usr/bin/lxpolkit &
# /usr/lib/polkit-gnome/polkit-gnome-authentication-agent-1 &
xfce4-notifyd &
xfce4-power-manager &
picom &
# variety &
volumeicon &
# parcellite &
nitrogen --restore &
flameshot &
volumeicon &
nm-applet &
pcmanfm --daemon-mode &
