#!/bin/bash

i3-msg 'workspace number 1'
sleep 0.2

# Fenster 1: nvim mit i3-Config (ganz links, volle Höhe, transparent)
i3-msg 'exec --no-startup-id i3-sensible-terminal -e ~/.config/i3/scripts/win-editor.sh'
sleep 0.6
i3-msg 'mark left'

# Horizontal splitten -> Fenster 2 rechts oben: Performance (btop)
i3-msg '[con_mark="left"] focus'
i3-msg 'split h'
i3-msg 'exec --no-startup-id i3-sensible-terminal -e ~/.config/i3/scripts/win-shell1.sh'
sleep 0.6
i3-msg 'mark rtop'

# Vertikal splitten -> Fenster 3 rechts unten: Fastfetch
i3-msg '[con_mark="rtop"] focus'
sleep 0.1
i3-msg 'split v'
i3-msg 'exec --no-startup-id i3-sensible-terminal -e ~/.config/i3/scripts/win-fastfetch.sh'
sleep 0.6
i3-msg 'mark fastfetch'

# Matrix neben Fastfetch
i3-msg '[con_mark="fastfetch"] focus'
sleep 0.1
i3-msg 'split h'
i3-msg 'exec --no-startup-id i3-sensible-terminal -e ~/.config/i3/scripts/win-matrix.sh'
sleep 0.6
i3-msg 'mark matrix'

# Cava unter Fastfetch (40% Höhe)
i3-msg '[con_mark="fastfetch"] focus'
sleep 0.1
i3-msg 'split v'
i3-msg 'exec --no-startup-id i3-sensible-terminal -e ~/.config/i3/scripts/win-cava.sh'
sleep 0.4
i3-msg 'mark cava'
i3-msg '[con_mark="cava"] resize set height 40 ppt'

# Zum Schluss Fokus auf den Config-Editor
i3-msg '[con_mark="left"] focus'
