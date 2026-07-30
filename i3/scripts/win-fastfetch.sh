#!/bin/bash
export NO_FASTFETCH=1
printf '\033]0;Debian\007'
tput civis 2>/dev/null
stty -echo -icanon 2>/dev/null
trap '' INT TSTP

while :; do
    clear
    fastfetch -c "$HOME/.config/fastfetch/hacker.jsonc"
    sleep 30
done
