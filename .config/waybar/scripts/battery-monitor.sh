#!/bin/bash

# Define thresholds
warning_level=30
critical_level=15

# Get battery info
capacity=$(cat /sys/class/power_supply/BAT1/capacity)
status=$(cat /sys/class/power_supply/BAT1/status)

# Use notify-send (via mako) if battery is low and discharging
if [[ "$status" == "Discharging" ]]; then
  if (( capacity <= critical_level )); then
    canberra-gtk-play -f ~/.local/sounds/custom/low_battery.ogg
    notify-send -u critical "Battery Critical" "⚠️ Connect your charger! ($capacity%)"
    paplay /usr/share/sounds/freedesktop/stereo/dialog-warning.oga
  elif (( capacity <= warning_level )); then
    notify-send -u normal "Battery Low" "🔋 Battery is low ($capacity%)."
    paplay /usr/share/sounds/freedesktop/stereo/dialog-information.oga
  fi
fi
if [["$status" == "Charging"]]; then
  canberra-gtk-play -f ~/.local/sounds/custom/power-up-mario.ogg

