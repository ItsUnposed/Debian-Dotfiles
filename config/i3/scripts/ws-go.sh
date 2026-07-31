#!/bin/bash
# ws-go.sh <zielnummer>   Workspace-Wechsel mit Richtungs-Animation
TARGET="$1"
[ -z "$TARGET" ] && exit 1

CUR=$(i3-msg -t get_workspaces | jq -r '.[] | select(.focused) | .num')
[ "$CUR" = "$TARGET" ] && exit 0

if [ "$TARGET" -gt "$CUR" ]; then DIR=1; else DIR=2; fi

# Alle Fenster in EINEM xprop-Aufruf pro Fenster, aber gebuendelt starten
for W in $(i3-msg -t get_tree | jq -r '..|objects|select(.window!=null)|.window'); do
    xprop -id "$W" -f _MY_CUSTOM_WORKSPACE_SWITCH 32c \
          -set _MY_CUSTOM_WORKSPACE_SWITCH "$DIR" 2>/dev/null &
done
wait

# Erzwingt einen Roundtrip zum X-Server: danach sind alle Aenderungen zugestellt
xprop -root _NET_CURRENT_DESKTOP >/dev/null 2>&1
sleep 0.04

i3-msg "workspace number $TARGET" >/dev/null
