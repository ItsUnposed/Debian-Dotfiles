#!/bin/bash
export PATH="/usr/local/bin:/usr/bin:/bin"

BOX="#FF6B5E"    # Box des aktuellen Workspace
BOXFG="#0D0A09"  # Text darin, dunkel fuer Kontrast
ACT="#E0483D"    # existiert, nicht aktiv
EMPTY="#4A4340"  # existiert nicht

RAW=$(i3-msg -t get_workspaces 2>/dev/null)
ACTIVE=$(printf '%s' "$RAW" | grep -o '"name":"[^"]*"' | sed 's/.*:"//; s/"//')
CUR=$(printf '%s' "$RAW" \
      | grep -o '"name":"[^"]*"[^}]*"focused":true' \
      | grep -o '"name":"[^"]*"' | head -1 | sed 's/.*:"//; s/"//')

out=""
for n in 1 2 3 4 5 6 7 8 9 10; do
    if [ "$n" = "$CUR" ]; then
        out="$out<span background='$BOX' foreground='$BOXFG' weight='bold'> $n </span>"
    elif printf '%s\n' "$ACTIVE" | grep -qx "$n"; then
        out="$out<span foreground='$ACT' weight='bold'> $n </span>"
    else
        out="$out<span foreground='$EMPTY'> $n </span>"
    fi
    out="$out<span> </span>"
done

echo "<txt>$out</txt>"
echo "<tool>i3 Workspaces</tool>"
