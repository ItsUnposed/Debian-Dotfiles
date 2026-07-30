#!/bin/bash
export PATH="/usr/local/bin:/usr/bin:/bin"
SIZE="medium"

B=$(ls -d /sys/class/power_supply/BAT* 2>/dev/null | head -1)
[ -z "$B" ] && { echo "<txt></txt>"; exit 0; }

CAP=$(cat "$B/capacity" 2>/dev/null)
ST=$(cat "$B/status"   2>/dev/null)

if   [ "$CAP" -ge 60 ]; then C="#FFD93D"
elif [ "$CAP" -ge 25 ]; then C="#FF8C42"
else                         C="#E0483D"
fi

case "$ST" in
    Charging)    I="+" ;;
    Discharging) I="" ;;
    Full)        I="=" ;;
    *)           I="?" ;;
esac

echo "<txt><span foreground='$C' size='$SIZE'> $I$CAP% </span></txt>"
echo "<tool>Akku $CAP Prozent, $ST</tool>"
