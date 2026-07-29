#!/bin/bash

STATUS=$(playerctl -p spotify status 2>/dev/null)

if [ -z "$STATUS" ]; then
    exit 0
fi

ARTIST=$(playerctl -p spotify metadata artist 2>/dev/null)
TITLE=$(playerctl -p spotify metadata title 2>/dev/null)
ART_URL=$(playerctl -p spotify metadata mpris:artUrl 2>/dev/null)
SHORT=$(echo "$TITLE" | cut -c1-20)

COVER="$HOME/.cache/spotify-panel/cover.png"
mkdir -p "$HOME/.cache/spotify-panel"

if [[ "$ART_URL" == http* ]]; then
    curl -s "$ART_URL" -o "$HOME/.cache/spotify-panel/cover_raw.jpg" 2>/dev/null
    # Bild auf feste, kleine Größe zuschneiden (passend zur Panel-Höhe)
    convert "$HOME/.cache/spotify-panel/cover_raw.jpg" -resize 24x24 "$COVER" 2>/dev/null
fi

if [ -f "$COVER" ]; then
    echo "<img>$COVER</img>"
fi

echo "<txt> <span foreground='#ffffff'>$SHORT</span> </txt>"
echo "<tool>$ARTIST — $TITLE</tool>"
