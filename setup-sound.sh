
#!/usr/bin/env bash

set -Eeuo pipefail

# Identify the user who launched the script, not root.
TARGET_USER="${SUDO_USER:-$(id -un)}"

echo "[1/4] Installing ALSA utilities..."
sudo pacman -S --needed --noconfirm alsa-utils

echo
echo "[2/4] Checking audio devices..."
aplay -l

echo
echo "Starting speaker test..."
speaker-test -c 2 -t wav -l 1

echo
echo "[3/4] Adding '$TARGET_USER' to the audio group..."
sudo usermod -aG audio "$TARGET_USER"

echo "Added '$TARGET_USER' to the audio group."

echo
echo "[4/4] Enabling PipeWire audio services..."

systemctl --user enable --now \
    pipewire.socket \
    pipewire-pulse.socket \
    wireplumber.service

echo
echo "Audio setup completed."
echo "Log out and back in for the audio group membership to take effect."
echo "Check audio status with: wpctl status"
