#!/bin/bash

git clone https://aur.archlinux.org/paru-bin.git $HOME/paru-bin
cd $HOME/paru-bin
makepkg -csi 
cd $HOME
rm -rf paru-bin

PACKAGES=(
	### SOFTWARE ###
	# firefox
	# google-chrome
	brave-bin
	visual-studio-code-bin
	neovim
	spotify
	discord
	libreoffice-fresh
	pdfarranger
	xournalpp
	mpv

	### FONTS ###
	noto-fonts
	noto-fonts-cjk
	noto-fonts-extra
	noto-fonts-emoji
	ttf-firacode-nerd
	ttf-jetbrains-mono-nerd
	ttf-cascadia-code-nerd
	ttf-ubuntu-nerd
	ttf-ubuntu-mono-nerd
	ttf-ms-fonts

	### UTILITIES OR DEPS ###
	img2pdf
	unzip
	unrar
	p7zip
	libappindicator-gtk3
	bash-completion
	ntfs-3g
	man-db
	man-pages
	tldr
	alsa-utils
	alsa-plugins
	gnome-keyring
	plocate
)

installed=0
attempts=0
max_install_attempts=3

install_packages() {
	for pkg in "${PACKAGES[@]}"; do
		if ! paru -Qi "$pkg" &> /dev/null; then
			paru -S --noconfirm --skipreview "$pkg"
			((installed++))
		fi
	done
}

while [ $attempts -lt $max_install_attempts ]; do
	install_packages
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

sudo updatedb

if [ "$installed" -gt 0 ]; then
	echo "Installation complete."
else
	echo "All programs already installed."
fi
