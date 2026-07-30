#!/bin/bash
# Hackerstartup
#  +----------------+-------------------------------+
#  |                |          taskmanager          |
#  |   i3 config    +---------------+---------------+
#  |   50% Breite   |  fastfetch 35%|               |
#  |   70% Deckkraft+---------------+    matrix     |
#  |                |  cava      65%|               |
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

# launch_xterm: startet xterm direkt mit Palettenfarbe
launch_xterm() {
    local mark="$1" script="$2" before i
    [ -f "$HOME/.config/ember/current.conf" ] && . "$HOME/.config/ember/current.conf"

    local fg=${C_ACC:-#FF6B5E}; fg=${fg#\#}
    local bg=${C_BG:-#0D0A09};  bg=${bg#\#}
    local FGrgb="rgb:${fg:0:2}/${fg:2:2}/${fg:4:2}"
    local BGrgba="rgba:${bg:0:2}/${bg:2:2}/${bg:4:2}/55"

    before=$(wcount)
    xterm -name "matrix-xterm" -title "Matrix" \
        -xrm "xterm*depth: 32" \
        -xrm "xterm*boldColors: false" \
        -bg "$BGrgba" \
        -fg "$FGrgb" \
        -xrm "xterm*color1: $FGrgb" \
        -xrm "xterm*color9: $FGrgb" \
        -fa "Fira Code" -fs 10 +sb \
        -e bash -c "exec $script" &
    for i in $(seq 1 60); do
        sleep 0.1
        [ "$(wcount)" -gt "$before" ] && break
    done
    sleep 0.3
    i3-msg "mark $mark" >/dev/null
}

pkill -x cava    2>/dev/null
pkill -f unimatrix 2>/dev/null

i3-msg "workspace $WS" >/dev/null
sleep 0.3

# 1) Editor ganz links
launch left "$S/win-editor.sh" "i3-config" 70

# 2) rechte Haelfte, oben der Taskmanager
i3-msg '[con_mark="left"] focus; split h' >/dev/null
launch rtop "$S/win-shell1.sh" "taskmanager"

# 3) unter dem Taskmanager: fastfetch
i3-msg '[con_mark="rtop"] focus; split v' >/dev/null
launch ff "$S/win-fastfetch.sh" "Debian"

# 4) rechts daneben: matrix (xterm mit Palettenfarbe)
i3-msg '[con_mark="ff"] focus; split h' >/dev/null
launch_xterm mx "$S/win-matrix.sh" "Matrix"

# 5) unter fastfetch: cava
i3-msg '[con_mark="ff"] focus; split v' >/dev/null
launch cava "$S/win-cava.sh" "Cava"

# 6) Groessen setzen
i3-msg '[con_mark="ff"]   focus; resize set height 35 ppt' >/dev/null
i3-msg '[con_mark="left"] focus; resize set width  50 ppt' >/dev/null

# 7) Titelleisten einschalten
for m in left rtop ff mx cava; do
    i3-msg "[con_mark=\"$m\"] border normal 2" >/dev/null
done

i3-msg '[con_mark="left"] focus' >/dev/null
