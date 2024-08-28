#!/bin/sh

nitrogen --restore &
picom &
/usr/lib/polkit-gnome/polkit-gnome-authentication-agent-1 &
nm-applet &
setxkbmap -layout us -variant altgr-intl &
xfce4-power-manager &
flameshot &
dunst &