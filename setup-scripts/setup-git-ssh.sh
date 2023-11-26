#!/usr/bin/env bash

mkdir $HOME/.ssh
echo "Host github.com
Hostname ssh.github.com
Port 443" > $HOME/.ssh/config

rm $HOME/.gitconfig
echo "Setting up Git for you..."
echo "Enter your name:"
read name
echo "Enter your email:"
read email
echo "Enter your text editor:"
read editor

git config --global user.name "$name"
git config --global user.email "$email"
git config --global core.editor "$editor"
git config --global init.defaultBranch main

ssh-keygen -t ed25519 -C "$email"
eval "$(ssh-agent -s)"
ssh-add $HOME/.ssh/id_ed25519
cat $HOME/.ssh/id_ed25519.pub
echo "Add this SSH key to your GitHub Account"
echo "Done? (Y,N)"
read opt

if [ $opt = 'Y' ]; then
    ssh -T git@github.com
else
    echo "Remember to run ssh -T git@github.com later."
fi
