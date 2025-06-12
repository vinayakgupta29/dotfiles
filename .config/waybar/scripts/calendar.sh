#!/bin/bash

yad --calendar \
    --title="Calendar" \
    --class="dropdown-calendar" \
    --width=300 --height=250 \
    --close-on-unfocus --skip-taskbar \
    --undecorated --on-top --no-buttons &
