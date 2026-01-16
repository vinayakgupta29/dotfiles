#!/usr/bin/env bash

warning_level=30
critical_level=15
CHECK_INTERVAL=1

sent_warning=0
sent_critical=0

BATTERY=$(ls /sys/class/power_supply | grep -m1 BAT)

while true; do
  capacity=$(< /sys/class/power_supply/$BATTERY/capacity)
  STATUS=$(< /sys/class/power_supply/$BATTERY/status)

  if [[ "$STATUS" == "Discharging" ]]; then

    if (( capacity <= critical_level )) && (( sent_critical == 0 )); then
      notify-send -u critical "Battery Critical" "Connect your charger! ($capacity%)"
      paplay /usr/share/sounds/freedesktop/stereo/dialog-warning.oga
      sent_critical=1

    elif (( capacity <= warning_level )) && (( sent_warning == 0 )); then
      notify-send -u normal "Battery Low" "Battery is low ($capacity%)."
      paplay /usr/share/sounds/freedesktop/stereo/dialog-information.oga
      sent_warning=1
    fi

  fi

  sleep "$CHECK_INTERVAL"
done

