#!/bin/bash

set -e
mount_windows() {
    set -e
    sudo rm -rf /etc/grub.d/40_custom

    sudo cp ./grub/windows/40_custom /etc/grub.d/40_custom
}

set_albedo_theme() {
    set -e
    REPO_URL="https://github.com/vinayakgupta29/albedo-grub-theme.git"
    CLONE_DIR="/tmp/grub-themes"
    THEME_NAME="albedo-grub-theme"
    DEST_DIR="/boot/grub/themes/$THEME_NAME"

    # === Clone the theme repository ===
    echo "Cloning theme repo... $THEME_NAME"
    rm -rf "$CLONE_DIR"
    git clone "$REPO_URL" "$CLONE_DIR"

    # === Copy theme to grub directory ===
    echo "Installing theme... $THEME_NAME"
    sudo mkdir -p "$DEST_DIR"
    sudo cp -r "$CLONE_DIR/$THEME_NAME/"* "$DEST_DIR"

    # === Set the theme in GRUB config ===
    echo "Setting GRUB theme..."
    GRUB_CFG="/etc/default/grub"
    THEME_LINE="GRUB_THEME=$DEST_DIR/theme.txt"

    # Add or replace the GRUB_THEME line
    if grep -q "^GRUB_THEME=" "$GRUB_CFG"; then
        sudo sed -i "s|^GRUB_THEME=.*|$THEME_LINE|" "$GRUB_CFG"
    else
        echo "$THEME_LINE" | sudo tee -a "$GRUB_CFG" >/dev/null
    fi

}

mount_windows
set_albedo_theme
sudo grub-mkconfig -o /boot/grub/grub.cfg
