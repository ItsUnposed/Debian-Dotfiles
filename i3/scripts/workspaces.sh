#!/bin/bash
# i3-Workspaces fuer xfce4-genmon

FOC="#FF6B5E"   # aktiv
VIS="#D64318"   # sichtbar auf anderem Monitor
INA="#8A7A72"   # existiert, nicht sichtbar
URG="#FFC96B"   # dringend

out=""
while IFS=$'\t' read -r name foc vis urg; do
    if   [ "$urg" = "true" ]; then c="$URG"; w="bold"
    elif [ "$foc" = "true" ]; then c="$FOC"; w="bold"
    elif [ "$vis" = "true" ]; then c="$VIS"; w="normal"
    else                            c="$INA"; w="normal"
    fi
    esc=$(printf '%s' "$name" | sed 's/&/\&amp;/g; s/</\&lt;/g')
    out="$out<span foreground='$c' weight='$w'> $esc </span>"
done < <(i3-msg -t get_workspaces 2>/dev/null \
         | jq -r '.[] | "\(.name)\t\(.focused)\t\(.visible)\t\(.urgent)"')

echo "<txt>$out</txt>"
echo "<tool>i3 Workspaces</tool>"
