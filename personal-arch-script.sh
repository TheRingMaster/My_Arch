#!/usr/bin/env bash

# Script to setup an android build environment on Arch Linux and derivative distributions

clear
# Uncomment the multilib repo, incase it was commented out
sudo sed -i "/\[multilib\]/,/Include/"'s/^#//' /etc/pacman.conf
echo Installing Dependencies!
# Update
sudo pacman -Syyu

#install git
sudo pacman -S git --noconfirm

#install my apps
yay -S matcha-gtk-theme sardi-icons android-studio fbreader mintstick-git picom 

#install a few dependencies
sudo pacman -S lzop pngcrush imagemagick 

# Install Android dependencies
sudo pacman -S base-devel git wget multilib-devel cmake svn clang lzip patchelf inetutils python2-distlib
# Install ncurses5-compat-libs, lib32-ncurses5-compat-libs, aosp-devel, xml2, and lineageos-devel
for package in ncurses5-compat-libs lib32-ncurses5-compat-libs aosp-devel xml2 lineageos-devel; do
    git clone https://aur.archlinux.org/"${package}"
    cd "${package}" || continue
    makepkg -si --skippgpcheck
    cd - || break
    rm -rf "${package}"
done

# For all those distro hoppers, lets setup your git credentials
GIT_USERNAME="$(git config --get user.name)"
GIT_EMAIL="$(git config --get user.email)"
echo "Configuring git"
if [[ -z ${GIT_USERNAME} ]]; then
    echo -n "Enter your name: "
    read -r NAME
    git config --global user.name "${NAME}"
fi
if [[ -z ${GIT_EMAIL} ]]; then
    echo -n "Enter your email: "
    read -r EMAIL
    git config --global user.email "${EMAIL}"
fi
git config --global credential.helper "cache --timeout=7200"
echo "git identity setup successfully!"

echo "Installing repo"
sudo curl --create-dirs -L -o /usr/local/bin/repo -O -L https://storage.googleapis.com/git-repo-downloads/repo
sudo chmod a+rx /usr/local/bin/repo

echo -e "Installing platform tools & udev rules for adb!"
sudo pacman -S android-tools android-udev
