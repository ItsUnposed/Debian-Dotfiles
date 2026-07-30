#!/bin/bash
[ -f "$HOME/.config/ember/current.conf" ] && . "$HOME/.config/ember/current.conf"
export PATH="/usr/local/bin:/usr/bin:/bin"
SIZE="medium"

LINE=$(nmcli -t -f ACTIVE,SSID,SIGNAL dev wifi 2>/dev/null | grep '^yes:' | head -1)
[ -z "$LINE" ] && { echo "<txt><span foreground='#8A7A72' size='$SIZE'> kein WLAN </span></txt>"; exit 0; }

SSID=$(printf '%s' "$LINE" | cut -d: -f2 | cut -c1-12)
SIG=$(printf  '%s' "$LINE" | cut -d: -f3)

if   [ "$SIG" -ge 70 ]; then C="#FFD93D"
elif [ "$SIG" -ge 40 ]; then C="#FF8C42"
else                         C="#E0483D"
fi

SSID=$(printf '%s' "$SSID" | sed 's/&/\&amp;/g; s/</\&lt;/g; s/>/\&gt;/g')
echo "<txt><span foreground='$C' size='$SIZE'> $SSID $SIG% </span></txt>"
echo "<tool>$SSID, Signal $SIG Prozent</tool>"
echo "<txtclick>nm-connection-editor</txtclick>"
