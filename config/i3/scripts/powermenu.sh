#!/bin/bash
CH=$(printf "Lock\nLog Out\nSuspend\nReboot\nPower Off\n" \
     | rofi -dmenu -i -no-custom -lines 5 -p "Power" \
            -theme "$HOME/.config/rofi/ember")

case "$CH" in
    "Lock")      command -v i3lock >/dev/null && i3lock -c 0d0a09 || xset s activate ;;
    "Log Out")   i3-msg exit ;;
    "Suspend")   systemctl suspend ;;
    "Reboot")    systemctl reboot ;;
    "Power Off") systemctl poweroff ;;
esac
