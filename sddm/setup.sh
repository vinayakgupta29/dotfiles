#!/bin/bash

# Exit on errors
set -e

# === CONFIGURATION ===
REPO_URL="https://github.com/vinayakgupta29/sddm-slayer.git"  # Example repo
THEME_NAME="greet_slayer"  # Folder name of the theme inside the repo
CLONE_DIR="/tmp/sddm-theme"
DEST_DIR="/usr/share/sddm/themes/$THEME_NAME"
SDDM_CONF="/etc/sddm.conf"

# === Clone the theme repository ===
echo "Cloning SDDM theme..."
rm -rf "$CLONE_DIR"
git clone --depth=1 "$REPO_URL" "$CLONE_DIR"

# === Copy theme to SDDM themes directory ===
echo "Installing theme to $DEST_DIR..."
sudo mkdir -p "$DEST_DIR"
sudo cp -r "$CLONE_DIR"/* "$DEST_DIR"

# === Set the theme in SDDM config ===
echo "Configuring SDDM to use the new theme..."

# Make sure [Theme] section exists
if ! grep -q "^\[Theme\]" "$SDDM_CONF"; then
    echo -e "\n[Theme]" | sudo tee -a "$SDDM_CONF" > /dev/null
fi

# Set current theme
if grep -q "^Current=" "$SDDM_CONF"; then
    sudo sed -i "s|^Current=.*|Current=$THEME_NAME|" "$SDDM_CONF"
else
    sudo sed -i "/^\[Theme\]/a Current=$THEME_NAME" "$SDDM_CONF"
fi


echo "✅ SDDM theme '$THEME_NAME' installed and activated!"
