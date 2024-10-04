#!/bin/bash

# Exit immediately if a command exits with a non-zero status
set -e

# Function to install paru if it is not already installed
install_paru() {
    if ! command -v paru &> /dev/null; then
        echo "paru is not installed. Starting installation of paru-bin from AUR..."

        # Check if 'base-devel' and 'git' are installed
        if ! pacman -Qs base-devel &> /dev/null; then
            echo "Installing base-devel and git..."
            sudo pacman -S --needed --noconfirm base-devel git
        fi

        # Create a temporary directory for installation
        TMP_DIR=$(mktemp -d)
        cd "$TMP_DIR"

        # Clone the paru-bin repository from AUR
        echo "Cloning paru-bin from AUR..."
        git clone https://aur.archlinux.org/paru-bin.git
        cd paru-bin

        # Build and install paru-bin
        echo "Building and installing paru-bin..."
        makepkg -si --noconfirm

        # Clean up the temporary directory
        cd ~
        rm -rf "$TMP_DIR"
    fi
}

# Function to update the system
update_system() {
    echo "Updating the system..."
    paru -Syu --noconfirm
    echo "System update completed."
}

# Function to install packages
install_packages() {
    # List of packages to install, organized by category
    packages=(
        ######################
        # Web Browsers
        ######################
        firefox
        google-chrome
        brave-bin

        ######################
        # Development Tools
        ######################
        visual-studio-code-bin
        neovim
        android-studio
        jdk21-openjdk
        netbeans
        intellij-idea-community-edition
        alacritty

        ######################
        # Productivity
        ######################
        discord
        onlyoffice-bin
        pdfarranger
        xournalpp
        gimp
        inkscape

        ######################
        # Multimedia
        ######################
        spotify
        mpv
        vlc

        ######################
        # Themes and Icons
        ######################
        papirus-icon-theme

        ######################
        # Fonts
        ######################
        noto-fonts
        noto-fonts-cjk
        noto-fonts-extra
        noto-fonts-emoji
        ttf-firacode-nerd
        ttf-jetbrains-mono-nerd
        ttf-hack-nerd
        ttf-cascadia-code-nerd
        ttf-ubuntu-font-family
        ttf-ubuntu-mono-nerd
        ttf-ms-fonts

        ######################
        # Utilities
        ######################
        zsh
        oh-my-posh-bin
        bat
        eza
        stow
        bluez
        bluez-utils
        bluez-tools
        libappindicator-gtk3
        bash-completion
        ntfs-3g
        man-db
        man-pages
        tldr
        alsa-utils
        alsa-plugins
        plocate
        xclip
        img2pdf
        unzip
        unrar
        p7zip
    )

    # Array to store packages that need to be installed
    to_install=()

    # Check each package to see if it is installed
    echo "Checking installed packages..."
    for package in "${packages[@]}"; do
        # Ignore empty lines and comments
        if [[ -z "$package" || "$package" == \#* ]]; then
            continue
        fi

        if ! paru -Qi "$package" &> /dev/null; then
            to_install+=("$package")
        fi
    done

    # Install the packages
    if [ ${#to_install[@]} -ne 0 ]; then
        echo "Installing packages: ${to_install[@]}"
        paru -S --noconfirm "${to_install[@]}"
        echo "Package installation completed."
    else
        echo "All packages are already installed."
    fi
}

main() {
    install_paru
    update_system
    install_packages
}

main
