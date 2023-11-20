#!/bin/bash

PROGRAMS=(
	xorg
	sddm
	qtile
	alacritty
	lxappearance
	pcmanfm
	lxsession
	xarchiver
	rofi
	picom
	nitrogen
	xfce4-notifyd
	xfce4-power-manager
	volumeicon
	flameshot
	gpicview
	network-manager-applet
	gvfs
	xdg-user-dirs
	pavucontrol
	mypy
)

installed=0
attempts=0
max_install_attempts=3

install_software() {
	for program in "${PROGRAMS[@]}"; do
		if ! pacman -Qi "$program" &> /dev/null; then
			sudo pacman -S --noconfirm "$program"
			((installed++))
		fi
	done
}

while [ $attempts -lt $max_install_attempts ]; do
	install_software
	if [ $? -eq 0 ]; then
		break
	else
		((attempts++))
		echo "Error. Trying again...($attempts/3)"
		sleep 3

		if [ $attempts -eq $max_install_attempts ]; then
			echo "Installation failed."
			exit 1
		fi
	fi
done

sudo systemctl enable sddm.service
sudo systemctl enable fstrim.timer

if [ "$installed" -gt 0 ]; then
	echo "Installation complete."
else
	echo "All programs already installed."
fi
