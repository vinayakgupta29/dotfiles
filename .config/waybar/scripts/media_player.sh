#!/usr/bin/env bash

# Get the PID of the player
pid=$(playerctl -a metadata -f '{{pid}}' | head -n 1)

# Use hyprctl to find the workspace of the window with this PID
workspace=$(hyprctl clients -j | jq -r --arg pid "$pid" '
  .[] | select(.pid == ($pid | tonumber)) | .workspace.id')

# If we found a workspace, switch to it
if [ -n "$workspace" ]; then
  hyprctl dispatch workspace "$workspace"
else
  notify-send "Player Window" "Could not find player window."
fi
