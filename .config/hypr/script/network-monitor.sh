#!/bin/bash

SOUND="/usr/share/sounds/freedesktop/stereo/network-connectivity-established.oga"
CONNECTED="no"

while true; do
    STATUS=$(nmcli -t -f GENERAL.STATE device show | grep -q "100 (connected)" && echo "yes" || echo "no")

    if [[ "$STATUS" == "yes" && "$CONNECTED" == "no" ]]; then
        paplay "$SOUND" 2>/dev/null
        # Optional desktop notification:
        # notify-send "Network Connected"
    fi

    CONNECTED="$STATUS"
    sleep 5
done
