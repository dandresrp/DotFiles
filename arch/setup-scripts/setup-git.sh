#!/bin/bash

# Directorio SSH
sshDir="$HOME/.ssh"

# Crear el directorio .ssh si no existe
[ ! -d "$sshDir" ] && mkdir -p "$sshDir" && chmod 700 "$sshDir"

# Crear archivo de configuración SSH si no existe
configFile="$sshDir/config"
if [ ! -f "$configFile" ]; then
    echo -e "Host github.com\n\tHostname ssh.github.com\n\tPort 443" > "$configFile"
fi

# Configuración de Git
read -p "Enter your name: " name
read -p "Enter your email: " email
read -p "Enter your text editor: " editor

git config --global user.name "$name"
git config --global user.email "$email"
git config --global core.editor "$editor"
git config --global init.defaultBranch main
git config --global color.ui auto
git config --global pull.rebase false

# Iniciar ssh-agent si no está corriendo
if ! pgrep -u "$USER" ssh-agent > /dev/null; then
    eval "$(ssh-agent -s)"
fi

# Generar clave SSH si no existe
sshKey="$sshDir/id_ed25519"
if [ ! -f "$sshKey" ]; then
    ssh-keygen -t ed25519 -C "$email" -f "$sshKey" -N ""
    ssh-add "$sshKey"
fi

# Mostrar la clave pública
cat "${sshKey}.pub"
echo "Add this SSH key to your GitHub Account: https://github.com/settings/keys"

# Verificar si el usuario ha añadido la clave
read -p "Have you added the SSH key to your GitHub account? (Y/N): " opt

if [[ "$opt" =~ ^[Yy]$ ]]; then
    ssh -T git@github.com
else
    echo "Remember to run 'ssh -T git@github.com' later once you've added the SSH key."
fi
