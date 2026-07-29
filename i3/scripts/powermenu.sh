#!/bin/bash
CH=$(printf "Sperren\nAbmelden\nStandby\nNeustart\nAusschalten\n" \
     | rofi -dmenu -i -no-custom -lines 5 -p "Power" \
            -theme "$HOME/.config/rofi/ember")

case "$CH" in
    Sperren)     command -v i3lock >/dev/null && i3lock -c 0d0a09 || xset s activate ;;
    Abmelden)    i3-msg exit ;;
    Standby)     systemctl suspend ;;
    Neustart)    systemctl reboot ;;
    Ausschalten) systemctl poweroff ;;
esac
