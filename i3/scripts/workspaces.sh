#!/bin/bash
export PATH="/usr/local/bin:/usr/bin:/bin"

FOC="#FF6B5E"; VIS="#D64318"; INA="#8A7A72"; URG="#FFC96B"; EMPTY="#4A4340"

DATA=$(i3-msg -t get_workspaces 2>/dev/null)
out=""
for n in 1 2 3 4 5 6 7 8 9 10; do
    row=$(printf '%s' "$DATA" | jq -r --arg n "$n" \
          '.[] | select(.name==$n) | "\(.focused)\t\(.visible)\t\(.urgent)"')
    if [ -z "$row" ]; then
        c="$EMPTY"; w="normal"
    else
        foc=$(printf '%s' "$row" | cut -f1)
        vis=$(printf '%s' "$row" | cut -f2)
        urg=$(printf '%s' "$row" | cut -f3)
        if   [ "$urg" = "true" ]; then c="$URG"; w="bold"
        elif [ "$foc" = "true" ]; then c="$FOC"; w="bold"
        elif [ "$vis" = "true" ]; then c="$VIS"; w="normal"
        else                            c="$INA"; w="normal"
        fi
    fi
    out="$out<span foreground='$c' weight='$w'> $n </span>"
done

echo "<txt>$out</txt>"
echo "<tool>i3 Workspaces</tool>"
