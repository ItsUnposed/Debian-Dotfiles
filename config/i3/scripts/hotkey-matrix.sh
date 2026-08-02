#!/bin/bash
[ -f "$HOME/.config/chroma/current.conf" ] && . "$HOME/.config/chroma/current.conf"
h=${C_ACC:-#FF6B5E}; h=${h#\#}
FG="$(printf '%02x/%02x/%02x' $((0x${h:0:2})) $((0x${h:2:2})) $((0x${h:4:2})))"
exec xterm -name "matrix-xterm" -title "Matrix" \
    -bg "rgb:00/00/00" -fg "rgb:$FG" \
    -fa "Fira Code" -fs 10 +sb \
    -e "$HOME/.local/bin/unimatrix -c terminal -o -s 97"
