#!/usr/bin/env bash

# Current Theme
dir="$HOME/.config/rofi"
theme='power_menu_style'

# CMDs
uptime="$(uptime -p | sed -e 's/up //g')"
host=$(uname -n)

# Options
shutdown=' '   # nf-fa-power_off
reboot=' '     # nf-fa-refresh
lock=' '       # nf-fa-lock
suspend=' '    # nf-fa-moon_o
logout=' '     # nf-fa-sign_out
yes=' '        # nf-fa-check
no=' '         # nf-fa-times

# Rofi CMD
rofi_cmd() {
    rofi -dmenu \
        -p "🥺 ${USER^^}" \
        -mesg "Uptime: $uptime" \
        -theme ${dir}/${theme}.rasi
}

# Confirmation CMD
confirm_cmd() {
    rofi -dmenu \
        -p 'Confirmation' \
        -mesg 'Seriously?' \
        -theme ${dir}/shared/confirm.rasi
}

# Ask for confirmation
confirm_exit() {
    echo -e "$yes\n$no" | confirm_cmd
}

# Pass variables to rofi dmenu
run_rofi() {
    printf "%s\n" "$lock" "$suspend" "$logout" "$reboot" "$shutdown" | rofi_cmd
}
# Execute Command
run_cmd() {
    selected="$(confirm_exit)"
    if [[ "$selected" == "$yes" ]]; then
        if [[ $1 == '--shutdown' ]]; then
            systemctl poweroff
        elif [[ $1 == '--reboot' ]]; then
            systemctl reboot
        elif [[ $1 == '--suspend' ]]; then
            mpc -q pause
            amixer set Master mute
            systemctl suspend
        elif [[ $1 == '--logout' ]]; then
            loginctl lock-session
        elif [[ $1 == "--lock" ]]; then
            hyprlock
        fi

    else
        exit 0
    fi
}
# Actions
chosen="$(run_rofi)"
case ${chosen} in
$shutdown)
    run_cmd --shutdown
    ;;
$reboot)
    run_cmd --reboot
    ;;
$lock)
   run_cmd --lock
   ;;
$suspend)
    run_cmd --suspend
    ;;
$logout)
    run_cmd --logout
    ;;
esac
