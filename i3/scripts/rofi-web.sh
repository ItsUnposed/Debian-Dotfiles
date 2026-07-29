#!/bin/bash

choice=$(rofi -dmenu -p "Web" -kb-custom-1 "Tab")
exit_code=$?

if [ "$exit_code" -eq 10 ]; then
    # Tab gedrückt -> zurück zu App-Suche
    ~/.config/i3/scripts/rofi-apps.sh
    exit 0
fi

if [ -n "$choice" ]; then
    chromium "https://www.google.com/search?q=$(echo "$choice" | sed 's/ /+/g')" &
fi
