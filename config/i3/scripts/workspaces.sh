#!/bin/bash
export PATH="/usr/local/bin:/usr/bin:/bin"
[ -f "$HOME/.config/ember/current.conf" ] && . "$HOME/.config/ember/current.conf"

ACC="${C_ACC:-#FF6B5E}"   # Theme-Farbe: Pille und alle inaktiven
TXT="${C_BG:-#0D0A09}"    # Text in der Pille, dunkel fuer Kontrast
L=$'\ue0b6'               # linke Halbrundung
R=$'\ue0b4'               # rechte Halbrundung

RAW=$(i3-msg -t get_workspaces 2>/dev/null)
NAMES=$(printf '%s' "$RAW" | grep -o '"name":"[^"]*"' | sed 's/.*:"//; s/"//')
CUR=$(printf '%s' "$RAW" \
      | grep -o '"name":"[^"]*"[^}]*"focused":true' \
      | grep -o '"name":"[^"]*"' | head -1 | sed 's/.*:"//; s/"//')

out=""
while read -r n; do
    [ -z "$n" ] && continue
    if [ "$n" = "$CUR" ]; then
        out="$out<span foreground='$ACC'>$L</span>"
        out="$out<span background='$ACC' foreground='$TXT' weight='bold'>$n</span>"
        out="$out<span foreground='$ACC'>$R</span>"
    else
        out="$out<span foreground='$ACC' weight='bold'> $n </span>"
    fi
    out="$out<span> </span>"
done <<< "$NAMES"

echo "<txt>$out</txt>"
echo "<tool>i3 Workspaces</tool>"
