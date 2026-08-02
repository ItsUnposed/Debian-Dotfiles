#!/bin/bash
export NO_FASTFETCH=1
printf '\033]0;Debian\007'
tput civis 2>/dev/null
stty -echo -icanon 2>/dev/null
tput smcup 2>/dev/null
trap 'tput rmcup 2>/dev/null; exit' INT TSTP EXIT

# Kurze Redraws direkt nach dem Start, damit ein spaeteres
# Resize durch i3 nicht die abgeschnittene Version stehen laesst
for i in {1..6}; do
    clear
    fastfetch -c "$HOME/.config/fastfetch/hacker.jsonc"
    sleep 0.5
done

while :; do
    clear
    fastfetch -c "$HOME/.config/fastfetch/hacker.jsonc"
    sleep 30
done
