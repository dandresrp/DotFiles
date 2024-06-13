#!/usr/bin/env bash

browser="brave-browser.desktop"
files="pcmanfm.desktop"
images="org.xfce.ristretto.desktop"

xdg-settings set default-web-browser $browser
xdg-mime default $files inode/directory
xdg-mime default $images image/jpeg
xdg-mime default $images image/jpg
xdg-mime default $images image/png