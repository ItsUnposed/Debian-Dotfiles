#!/bin/bash
[ -f "$HOME/.config/chroma/current.conf" ] && . "$HOME/.config/chroma/current.conf"
export PATH="/usr/local/bin:/usr/bin:/bin"
SIZE="medium"

VOL=$(pactl get-sink-volume @DEFAULT_SINK@ 2>/dev/null | grep -oP '\d+(?=%)' | head -1)
MUTE=$(pactl get-sink-mute @DEFAULT_SINK@ 2>/dev/null | grep -o 'yes\|no')

[ -z "$VOL" ] && { echo "<txt></txt>"; exit 0; }

if [ "$MUTE" = "yes" ]; then
    echo "<txt><span foreground='#8A7A72' size='$SIZE'> MUTE </span></txt>"
    echo "<tool>Stumm</tool>"
else
    if   [ "$VOL" -ge 80 ]; then C="#E0483D"
    elif [ "$VOL" -ge 40 ]; then C="#FF8C42"
    else                         C="#FFD93D"
    fi
    echo "<txt><span foreground='$C' size='$SIZE'> VOL $VOL% </span></txt>"
    echo "<tool>Lautstaerke $VOL Prozent</tool>"
fi
echo "<txtclick>pavucontrol</txtclick>"
