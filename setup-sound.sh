#!/bin/bash

sudo pacman -S alsa-utils

aplay -l

speaker-test -c 2

echo "Now add your username to the audio group"

sudo usermod -aG audio $(whoami)

echo "Added $USER to audio group"

systemctl --user enable pipewire-pulse pipewire wireplumber

systemctl --user start pipewire-pulse pipewire wireplumber

