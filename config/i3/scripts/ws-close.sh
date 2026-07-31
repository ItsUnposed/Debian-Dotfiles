#!/bin/bash
# Schliesst das fokussierte Fenster mit Swipe nach unten
W=$(i3-msg -t get_tree | jq -r 'recurse(.nodes[]?,.floating_nodes[]?)|select(.focused==true)|.window')

if [ -n "$W" ] && [ "$W" != "null" ]; then
    xprop -id "$W" -f _MY_CUSTOM_WORKSPACE_SWITCH 32c \
          -set _MY_CUSTOM_WORKSPACE_SWITCH 3 2>/dev/null
    xprop -root _NET_CURRENT_DESKTOP >/dev/null 2>&1

    # aus dem Kachel-Layout loesen: liegt danach ueber den Nachbarn
    i3-msg floating enable >/dev/null
    sleep 0.05
fi

i3-msg kill >/dev/null
