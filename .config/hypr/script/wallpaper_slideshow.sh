#!/bin/bash

# Directory containing wallpapers
WALLPAPER_DIR="$HOME/wallpapers"
# Interval between wallpaper changes (in seconds)
# 3 minutes = 180 seconds
INTERVAL=60

COLORS_FILE="$HOME/.config/hypr/hyprcolors.conf"

# Check if hyprpaper is running, if not start it
if ! pgrep -x "hyprpaper" > /dev/null; then
    hyprpaper &
    sleep 1
fi

# 1. Get all wallpapers and shuffle them ONCE at the start
WALLPAPER_LIST=$(find "$WALLPAPER_DIR" -type f \( -name "*.jpg" -o -name "*.png" -o -name "*.jpeg" -o -name "*.webp" \) | shuf)

# Check if any wallpapers were found
if [ -z "$WALLPAPER_LIST" ]; then
    echo "No wallpapers found in $WALLPAPER_DIR"
    exit 1
fi

update_colors() {
    local WALL="$1"

    wal -i "$WALL" -n -q -s -t

    ACCENT1=$(sed -n '1p' ~/.cache/wal/colors)
    ACCENT2=$(sed -n '2p' ~/.cache/wal/colors)

    cat > "$COLORS_FILE" <<EOF
\$accent1 = rgba(${ACCENT1#\#}ff)
\$accent2 = rgba(${ACCENT2#\#}ff)
EOF

    hyprctl reload >/dev/null
}


# 2. Iterate through the shuffled list
while true; do
    while IFS= read -r WALLPAPER; do
        if [ -n "$WALLPAPER" ]; then
            # Preload the selected wallpaper
            # hyprctl hyprpaper preload "$WALLPAPER"
            # Set the wallpaper for all monitors
           
           #hyprctl hyprpaper wallpaper ",$WALLPAPER"

            update_colors "$WALLPAPER"
            # Wait for the specified interval
            sleep "$INTERVAL"
            
            # Unload wallpapers to keep RAM usage low
            # (Unloads everything except the one currently active)
            # hyprctl hyprpaper unload all
        fi
    done <<< "$WALLPAPER_LIST"
    
    # Optional: If you want to keep the SAME order forever, the loop continues.
    # If you want to re-shuffle AFTER finishing the whole list, you can move 
    # the 'shuf' command inside the 'while true' but outside the 'while read'.
done
