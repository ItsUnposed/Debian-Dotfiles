#!/bin/bash

choice=$(rofi -show drun -dmenu -p "Apps" -kb-custom-1 "Tab")
exit_code=$?

if [ "$exit_code" -eq 10 ]; then
    # Tab gedrückt -> zu Web-Suche wechseln
    ~/.config/i3/scripts/rofi-web.sh
    exit 0
fi

if [ -n "$choice" ]; then
    if command -v "$choice" &> /dev/null; then
        $choice &
    fi
fi
