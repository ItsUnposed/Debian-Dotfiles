#!/bin/bash
echo -ne "\033]0;System Info\007"
tput civis

redraw() {
  clear
  fastfetch --config ~/.config/fastfetch/minimal.jsonc
}

trap redraw SIGWINCH

# Schnelle Redraws in den ersten 5 Sekunden (gegen Verrutschen beim Start)
redraw
for i in {1.38}; do
  sleep 2
  redraw
done

# Danach alle 30 Sekunden aktualisieren
while true; do
  sleep 30
  redraw
done
