#!/bin/bash
# Schliesst das fokussierte Fenster mit Swipe nach unten
W=$(i3-msg -t get_tree | jq -r 'recurse(.nodes[]?,.floating_nodes[]?)|select(.focused==true)|.window')
if [ -n "$W" ] && [ "$W" != "null" ]; then
    xprop -id "$W" -f _MY_CUSTOM_WORKSPACE_SWITCH 32c \
          -set _MY_CUSTOM_WORKSPACE_SWITCH 3 2>/dev/null
    xprop -root _NET_CURRENT_DESKTOP >/dev/null 2>&1
    sleep 0.03
fi
i3-msg kill >/dev/null
