#!/bin/bash
export NO_FASTFETCH=1
printf '\033]0;Debian\007'
clear
fastfetch -c ~/.config/fastfetch/hacker.jsonc
tput civis 2>/dev/null
stty -echo -icanon 2>/dev/null
trap '' INT TSTP
while :; do sleep 3600; done
