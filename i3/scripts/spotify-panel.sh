#!/bin/bash
# Spotify-Modul fuer xfce4-genmon

PLAYER=$(playerctl -l 2>/dev/null | grep -i -m1 spotify)
[ -z "$PLAYER" ] && exit 0

STATUS=$(playerctl -p "$PLAYER" status 2>/dev/null)
[ -z "$STATUS" ] && exit 0

ARTIST=$(playerctl -p "$PLAYER" metadata artist 2>/dev/null)
TITLE=$(playerctl -p "$PLAYER" metadata title  2>/dev/null)
ART=$(playerctl -p "$PLAYER" metadata mpris:artUrl 2>/dev/null)

# Pango-Sonderzeichen entschaerfen, sonst bricht die Anzeige bei "AC/DC & Co"
esc() { printf '%s' "$1" | sed 's/&/\&amp;/g; s/</\&lt;/g; s/>/\&gt;/g'; }

SHORT=$(printf '%s' "$TITLE" | cut -c1-22)
[ "${#TITLE}" -gt 22 ] && SHORT="$SHORT..."
SHORT=$(esc "$SHORT")
TOOL="$(esc "$ARTIST") - $(esc "$TITLE")"

case "$STATUS" in
    Playing) ICON="▶" ;;
    Paused)  ICON="‖" ;;
    *)       ICON="■" ;;
esac

CACHE="$HOME/.cache/spotify-panel"
COVER="$CACHE/cover.png"
mkdir -p "$CACHE"

if [[ "$ART" == http* ]] && command -v convert >/dev/null; then
    if [ "$ART" != "$(cat "$CACHE/last_url" 2>/dev/null)" ]; then
        curl -sf --max-time 3 "$ART" -o "$CACHE/raw.jpg" \
          && convert "$CACHE/raw.jpg" -resize 22x22 "$COVER" 2>/dev/null \
          && printf '%s' "$ART" > "$CACHE/last_url"
    fi
fi

[ -f "$COVER" ] && echo "<img>$COVER</img>"
echo "<txt><span foreground='#FF6B5E'>$ICON $SHORT</span></txt>"
echo "<tool>$TOOL</tool>"
echo "<txtclick>playerctl -p $PLAYER play-pause</txtclick>"
