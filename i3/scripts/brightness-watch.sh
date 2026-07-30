#!/bin/bash
export PATH="/usr/local/bin:/usr/bin:/bin"

DEV=$(ls -d /sys/class/backlight/* 2>/dev/null | head -1)
[ -z "$DEV" ] && exit 1

MAX=$(cat "$DEV/max_brightness")
LAST=$(( $(cat "$DEV/actual_brightness") * 100 / MAX ))

while :; do
    CUR=$(( $(cat "$DEV/actual_brightness") * 100 / MAX ))
    if [ "$CUR" != "$LAST" ]; then
        LAST=$CUR
        notify-send -a brightness -u low -i display-brightness \
            -h int:value:$CUR \
            -h string:x-canonical-private-synchronous:brightness \
            "Helligkeit $CUR%"
    fi
    sleep 0.3
done
