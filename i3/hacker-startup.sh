#!/bin/bash
# Hackerstartup
#  +----------------+-------------------------------+
#  |                |          taskmanager          |
#  |   i3 config    +---------------+---------------+
#  |   50% Breite   |  fastfetch 30%|               |
#  |   70% Deckkraft+---------------+    matrix     |
#  |                |  cava      70%|               |
#  +----------------+---------------+---------------+

S="$HOME/.config/i3/scripts"
WS="number 1"

wcount() { i3-msg -t get_tree | grep -o '"window":[0-9]\+' | wc -l; }

# launch <mark> <skript> <fenstername> [deckkraft_prozent]
launch() {
    local mark="$1" script="$2" wname="$3" op="$4" before i wid
    before=$(wcount)
    i3-msg "exec --no-startup-id i3-sensible-terminal -e $script" >/dev/null
    for i in $(seq 1 60); do
        sleep 0.1
        [ "$(wcount)" -gt "$before" ] && break
    done
    sleep 0.3
    i3-msg "mark $mark" >/dev/null

    wid=$(xdotool getactivewindow)
    if [ -n "$op" ]; then
        xprop -id "$wid" -f _NET_WM_WINDOW_OPACITY 32c \
              -set _NET_WM_WINDOW_OPACITY $(( 0xffffffff * op / 100 ))
    fi
}

pkill -x cava    2>/dev/null
pkill -x cmatrix 2>/dev/null

i3-msg "workspace $WS" >/dev/null
sleep 0.3

# 1) Editor ganz links, transparent
launch left "$S/win-editor.sh" "i3 config" 70

# 2) rechte Haelfte, oben der Taskmanager
i3-msg '[con_mark="left"] focus; split h' >/dev/null
launch rtop "$S/win-shell1.sh" "taskmanager"

# 3) unter dem Taskmanager: fastfetch
i3-msg '[con_mark="rtop"] focus; split v' >/dev/null
launch ff "$S/win-fastfetch.sh" "fastfetch"

# 4) rechts daneben: matrix
i3-msg '[con_mark="ff"] focus; split h' >/dev/null
launch mx "$S/win-matrix.sh" "matrix"

# 5) unter fastfetch: cava
i3-msg '[con_mark="ff"] focus; split v' >/dev/null
launch cava "$S/win-cava.sh" "cava"

# 6) Groessen setzen
i3-msg '[con_mark="ff"]   focus; resize set height 35 ppt' >/dev/null
i3-msg '[con_mark="left"] focus; resize set width  50 ppt' >/dev/null

# 7) Titelleisten einschalten, damit die Namen sichtbar sind
for m in left rtop ff mx cava; do
    i3-msg "[con_mark=\"$m\"] border normal 2" >/dev/null
done

i3-msg '[con_mark="left"] focus' >/dev/null
