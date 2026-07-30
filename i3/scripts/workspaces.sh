#!/bin/bash
[ -f "$HOME/.config/ember/current.conf" ] && . "$HOME/.config/ember/current.conf"
export PATH="/usr/local/bin:/usr/bin:/bin"

CUR_C="${C_ACC:-#FF6B5E}"
OTH_C="${C_FG:-#F2E4DC}"
PAD=$'\u00a0'          # 1x geschuetztes Leerzeichen je Seite

RAW=$(i3-msg -t get_workspaces 2>/dev/null)
CUR=$(printf '%s' "$RAW" | grep -o '"name":"[^"]*"[^}]*"focused":true' \
      | grep -o '"name":"[^"]*"' | head -1 | sed 's/.*:"//; s/"//')

out=""
while read -r n; do
    [ -z "$n" ] && continue
    esc=$(printf '%s' "$n" | sed 's/&/\&amp;/g; s/</\&lt;/g; s/>/\&gt;/g')
    if [ "$n" = "$CUR" ]; then
        out="$out<span foreground='$CUR_C' weight='bold'>${PAD}${esc}${PAD}</span>"
    else
        out="$out<span foreground='$OTH_C'>${PAD}${esc}${PAD}</span>"
    fi
done < <(printf '%s' "$RAW" | grep -o '"name":"[^"]*"' | sed 's/.*:"//; s/"//')

echo "<txt>$out</txt>"
echo "<tool>i3 Workspaces</tool>"
