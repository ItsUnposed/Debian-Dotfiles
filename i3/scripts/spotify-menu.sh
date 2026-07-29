#!/bin/bash

OPTION=$(printf "⏮ Previous\n⏯ Play/Pause\n⏭ Next\n⏹ Stop" | rofi -dmenu -p "Spotify" -theme-str 'window {width: 200px;}')

case "$OPTION" in
    "⏮ Previous") playerctl -p spotify previous ;;
    "⏯ Play/Pause") playerctl -p spotify play-pause ;;
    "⏭ Next") playerctl -p spotify next ;;
    "⏹ Stop") playerctl -p spotify stop ;;
esac
