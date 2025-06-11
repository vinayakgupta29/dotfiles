#!/bin/bash

# Check if VLC is running and in fullscreen mode
if pgrep vlc > /dev/null; then
    # Check if VLC is playing
    status=$(playerctl --player=vlc status 2>/dev/null)
    fullscreen=$(hyprctl clients | grep -A10 "vlc" | grep "fullscreen: true")

    if [[ "$status" == "Playing" && -n "$fullscreen" ]]; then
        # VLC is fullscreen and playing, skip lock
        exit 0
    fi
fi

# If not playing or not fullscreen, lock screen
waylock

