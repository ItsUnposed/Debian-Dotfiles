#!/bin/bash
export NO_FASTFETCH=1
clear
fastfetch -c ~/.config/fastfetch/hacker.jsonc
tput civis 2>/dev/null            # Cursor ausblenden
stty -echo -icanon 2>/dev/null    # keine Tastatureingabe sichtbar
trap '' INT TSTP                  # Strg+C und Strg+Z ignorieren
while :; do sleep 3600; done      # Fenster offen halten, ohne Shell
