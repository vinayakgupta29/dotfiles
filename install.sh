#!/bin/bash

set -e
install_yay() {
    git clone https://aur.archlinux.org/yay.git
    cd yay
    makepkg -si
}

install_packages() {
    sudo pacman -S --needed --noconfirm $(<packagelist)
}

enable_services() {
    sudo systemctl enable NetworkManager.service
    sudo systemctl start NetworkManager.service
}

install_AUR_packages() {
    install_yay

    yay -S --needed $(<AUR_PACKAGES)
}
symlink_create() {
    if pacman -Q hyprland &>/dev/null; then
        ln -s $(pwd)/.config/hypr $HOME/.config/hypr
        chmod +x $HOME/.config/hypr/*.sh
    else
        echo "hyprland is not installed"
    fi

    if pacman -Q waybar &>dev/null; then
        ln -s $(pwd)/.config/waybar $HOME/.cofig/waybar
        chmod +x $(pwd)/.config/waybar/*.sh
    else
        echo "waybar is not installed"
    fi

    if pacman -Q range &>dev/null; then
        ln -s $(pwd)/.config/ranger $HOME/.config/ranger
        chmod +x $(pwd)/.config/ranger/*.sh
    else
        echo "Ranger is not installed"
    fi

    if pacman -Q rofi &>dev/null; then
        ln -s $(pwd)/.config/rofi $HOME/.config/rofi
        chmod +x $(pwd)/.config/rofi/*.sh
    else
        echo "Rofi is not installed"
    fi

    if pacman -Q mako &>dev/null; then
        ln -s $(pwd)/.config/mako $HOME/.config/mako
    else
        echo "Mako is not installed..."
    fi

    if pacman -Q kitty &>dev/null; then
        ln $(pwd)/.config/kity $HOME/.config/kitty
    else
        echo "Kitty is not installed"
    fi
    echo "Created all Symlinks... 😄"
}


find $(pwd) -type f -name "*.sh" -exec chmod +x {} \; #find . -type f -name "*.sh" -exec chmod +x {} \;

install_packages

enable_services

install_AUR_packages

symlink_create

chmod +x "$(pwd)/scripts/ipconf"
chmod +x "$(pwd)/scripts/oye"



echo "Look into notes to setup sddm and Grub themes..."
exit 0
