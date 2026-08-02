#!/bin/bash
[ -f "$HOME/.config/chroma/current.conf" ] && . "$HOME/.config/chroma/current.conf"
h=${C_ACC:-#FF6B5E}; h=${h#\#}
FG="$(printf '%02x/%02x/%02x' $((0x${h:0:2})) $((0x${h:2:2})) $((0x${h:4:2})))"
exec xterm -name "matrix-xterm" -title "Matrix" \
    -bg "rgb:00/00/00" -fg "rgb:$FG" \
    -fa "Fira Code" -fs 10 +sb -b 0 \
    -e bash -c "printf '\033]4;1;#${h}\007'; pipes -c 1 -B -K -R -f 100 -p 3 -r 0 & P=\$!; trap 'kill -9 \$P 2>/dev/null; exit 0' HUP TERM INT; wait \$P; exit 0"
