#!/bin/bash
exec 9>/tmp/brightness-watch.lock
flock -n 9 || exit 0

export PATH="/usr/local/bin:/usr/bin:/bin"

PIDFILE="$HOME/.cache/brightness-watch.pid"
if [ -f "$PIDFILE" ]; then
    OLD=$(cat "$PIDFILE")
    [ "$OLD" != "$$" ] && kill "$OLD" 2>/dev/null
fi
echo $$ > "$PIDFILE"

DEV=$(ls -d /sys/class/backlight/* 2>/dev/null | head -1)
[ -z "$DEV" ] && exit 1

MAX=$(cat "$DEV/max_brightness")
IDFILE="$HOME/.cache/brightness-id"
LAST=$(( $(cat "$DEV/actual_brightness") * 100 / MAX ))
STAMP=0

while :; do
    CUR=$(( $(cat "$DEV/actual_brightness") * 100 / MAX ))
    if [ "$CUR" != "$LAST" ]; then
        LAST=$CUR
        NOW=$(date +%s)
        ID=$(cat "$IDFILE" 2>/dev/null)
        if [ -n "$ID" ] && [ $(( NOW - STAMP )) -lt 5 ]; then
            NEW=$(notify-send -p -r "$ID" -a brightness -u low \
                  -i display-brightness -h int:value:$CUR "Helligkeit $CUR%")
        else
            NEW=$(notify-send -p -a brightness -u low \
                  -i display-brightness -h int:value:$CUR "Helligkeit $CUR%")
        fi
        [ -n "$NEW" ] && printf '%s' "$NEW" > "$IDFILE"
        STAMP=$NOW
    fi
    sleep 0.2
done
