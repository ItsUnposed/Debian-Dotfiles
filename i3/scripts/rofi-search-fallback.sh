#!/bin/bash

choice=$(rofi -show drun -dmenu -p "Search: ")

if [ -z "$choice" ]; then
    exit 0
fi

if command -v "$choice" &> /dev/null; then
    $choice &
else
    chromium "https://www.google.com/search?q=$(echo "$choice" | sed 's/ /+/g')" &
fi
