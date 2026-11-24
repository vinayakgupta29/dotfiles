#!/usr/bin/env bash

warning_level=30
critical_level=15
CHECK_INTERVAL=30 # 30 sec

sent_warning=0
sent_critical=0

BATTERY_PATH=(/sys/class/power_supply/BAT*)

if [[ -e "${BATTERY_PATH[0]}" ]]; then
	BATTERY="${BATTERY_PATH[0]}"

	while true; do
		capacity="$(<"$BATTERY/capacity")"
		STATUS="$(<"$BATTERY/status")"

		if [[ "$STATUS" == "Discharging" ]]; then

			if ((capacity <= critical_level)) && ((sent_critical == 0)); then
				notify-send -u critical "Battery Critical" "Connect your charger! ($capacity%)"
				paplay /usr/share/sounds/freedesktop/stereo/dialog-warning.oga
				sent_critical=1

			elif ((capacity <= warning_level)) && ((sent_warning == 0)); then
				notify-send -u normal "Battery Low" "Battery is low ($capacity%)."
				paplay /usr/share/sounds/freedesktop/stereo/dialog-information.oga
				sent_warning=1
			fi
		else
			sent_critical=0
			sent_warning=0

		fi

		sleep "$CHECK_INTERVAL"
	done

else
	printf 'No battery detected.\n' >&2
	exit 1
fi
