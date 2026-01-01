##!/bin/bash

# List engines in desired cycle order
engines=(
    "keyboard-us"
    "m17n_hi_itrans"
    "m17n_sa_itrans"
    "mozc"
)
# Get current engine
current=$(fcitx5-remote -n)  # returns the current engine name

# Find current engine index and switch to next
for i in "${!engines[@]}"; do
    if [[ "${engines[$i]}" == "$current" ]]; then
        next=$(( (i + 1) % ${#engines[@]} ))
        fcitx5-remote -s "${engines[$next]}"
        echo "Switched to: ${engines[$next]}"
        exit 0
    fi
done

# If unknown engine, default to first
fcitx5-remote -s "${engines[0]}"
echo "Switched to: ${engines[0]}"

