#!/bin/bash

PROGRAMS=(
	### HEADERS ###
	#linux-headers
	#linux-lts-headers
	#linux-hardened-headers
	linux-zen-headers
	#linux-rt-headers
	#linux-rt-lts-headers
	
	nvidia-dkms
	nvidia-settings
	nvidia-utils
	opencl-nvidia
	libglvnd
	lib32-libglvnd
	lib32-nvidia-utils
	lib32-opencl-nvidia
)

installed=0
attempts=0
max_install_attempts=3

install_software() {
	for program in "${PROGRAMS[@]}"; do
		if ! pacman -Qi "$program" &> /dev/null; then
			pacman -S --noconfirm "$program"
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

if [ "$installed" -eq 0 ]; then
	echo "Nvidia drivers already installed."
	exit 1
fi

sed -i "/^MODULES=/ s/()/($(echo -n "nvidia nvidia_modeset nvidia_uvm nvidia_drm"))/" /etc/mkinitcpio.conf
mkinitcpio -P

mkdir /etc/pacman.d/hooks
touch /etc/pacman.d/hooks/nvidia.hook
echo '[Trigger]
Operation=Install
Operation=Upgrade
Operation=Remove
Type=Package
Target=nvidia

[Action]
Description=Update NVIDIA module in initcpio
Depends=mkinitcpio
When=PostTransaction
Exec=/usr/bin/mkinitcpio -P' > /etc/pacman.d/hooks/nvidia.hook

touch /etc/X11/xorg.conf.d/20-nvidia.conf
echo 'Section "Device"
Identifier "NVIDIA Card"
Driver     "nvidia"
VendorName "NVIDIA Corporation"
BoardName  "GeForce GTX 1050 Ti"
EndSection

Section "Screen"
Identifier     "Screen0"
Device         "Device0"
Monitor        "Monitor0"
Option         "ForceFullCompositionPipeline" "on"
Option         "AllowIndirectGLXProtocol" "off"
Option         "TripleBuffer" "on"
EndSection' > /etc/X11/xorg.conf.d/20-nvidia.conf

if [ "$installed" -gt 0 ]; then
	echo "Nvidia drivers installation complete. REBOOT NOW! "
fi
