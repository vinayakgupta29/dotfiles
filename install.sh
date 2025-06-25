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

set_dolphin_mime() {
    curl -L https://raw.githubusercontent.com/KDE/plasma-workspace/master/menu/desktop/plasma-applications.menu -o "$HOME/.config/menus/applications.menu"
    kbuildsycoca6;
}
install_sounds() {
    DEST_DIR="$HOME/.local/sounds"
    rm -rf "$DEST_DIR"
    mkdir -p "$DEST_DIR"
    ln -s $(pwd)/sounds/custom "$DEST_DIR"

    echo "Moved the sounds to $DEST_DIR"
}

enable_services() {
    enable_and_start_service NetworkManager

    enable_and_start_service iwd

    enable_and_start_service avahi-daemon

    enable_and_start_service firewalld

    enable_and_start_service bluetooth

    enable_and_start_service polkit

    enable_and_start_service docker

    enable_and_start_service dbus-broker

    enable_and_start_service wireplumber

    enable_and_start_service pipewire

}

enable_and_start_service() {
    SERVICE=$1
    sudo systemctl enable "$SERVICE.service"
    sudo systemctl start "$SERVICE.service"
    echo "Enabled and Started $SERVICE.service..."
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
        ln -s $(pwd)/.config/kity $HOME/.config/kitty
    else
        echo "Kitty is not installed"
    fi
    if pacman -Q fastfetch &>dev/null; then
        ln -s $(pwd)/.config/fastfetch $HOME/.config/fastfetch
    else
        echo "Fastfetch is not installed"
    fi

    echo "Created all Symlinks... 😄"
}

install_font() {
    mkdir $HOME/.local/share/fonts/
    ln -s $(pwd)/fonts $HOME/.local/share/fonts
    fc-cache -fv

}

find $(pwd) -type f -name "*.sh" -exec chmod +x {} \; #find . -type f -name "*.sh" -exec chmod +x {} \;

install_packages

enable_services

install_AUR_packages

symlink_create

install_font

install_sounds

set_dolphin_mime

chmod +x "$(pwd)/scripts/ipconf"
chmod +x "$(pwd)/scripts/oye"

echo "Look into notes to setup sddm and Grub themes..."
exit 0
