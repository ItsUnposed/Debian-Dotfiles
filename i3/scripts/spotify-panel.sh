#!/bin/bash
export PATH="/usr/local/bin:/usr/bin:/bin"
[ -z "$DBUS_SESSION_BUS_ADDRESS" ] && \
    export DBUS_SESSION_BUS_ADDRESS="unix:path=/run/user/$(id -u)/bus"

WIDTH=22           # sichtbare Zeichen
SIZE="medium"      # x-small, small, medium, large
COVERPX=28         # Bildgroesse in Pixel
CACHE="$HOME/.cache/spotify-panel"
mkdir -p "$CACHE"

PLAYER=$(playerctl -l 2>/dev/null | grep -i -m1 spotify)
[ -z "$PLAYER" ] && { echo "<txt></txt>"; exit 0; }

STATUS=$(playerctl -p "$PLAYER" status 2>/dev/null)
[ -z "$STATUS" ] && { echo "<txt></txt>"; exit 0; }

ARTIST=$(playerctl -p "$PLAYER" metadata artist 2>/dev/null)
TITLE=$(playerctl -p "$PLAYER" metadata title  2>/dev/null)
ART=$(playerctl -p "$PLAYER" metadata mpris:artUrl 2>/dev/null)

FULL="$TITLE - $ARTIST"
SHOW="${FULL:0:$WIDTH}"
[ "${#FULL}" -gt "$WIDTH" ] && SHOW="$SHOW..."

esc() { printf '%s' "$1" | sed 's/&/\&amp;/g; s/</\&lt;/g; s/>/\&gt;/g'; }
SHOW=$(esc "$SHOW")
TOOL=$(esc "$FULL")

COVER="$CACHE/cover.png"
if [[ "$ART" == http* ]] && command -v convert >/dev/null; then
    if [ "$ART" != "$(cat "$CACHE/last_url" 2>/dev/null)" ]; then
        curl -sf --max-time 3 "$ART" -o "$CACHE/raw.jpg" \
          && convert "$CACHE/raw.jpg" -resize ${COVERPX}x${COVERPX} "$COVER" 2>/dev/null \
          && printf '%s' "$ART" > "$CACHE/last_url"
    fi
fi

[ -f "$COVER" ] && echo "<img>$COVER</img>"
echo "<txt><span foreground='#FF6B5E' size='$SIZE'>  $SHOW </span></txt>"
echo "<tool>$TOOL</tool>"
