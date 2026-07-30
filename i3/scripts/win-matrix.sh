#!/bin/bash
[ -f "$HOME/.config/ember/current.conf" ] && . "$HOME/.config/ember/current.conf"

tohex() {
    h=${1:-#FF6B5E}; h=${h#\#}
    printf '%02x/%02x/%02x' $((0x${h:0:2})) $((0x${h:2:2})) $((0x${h:4:2}))
}

FG=$(tohex "${C_ACC:-#FF6B5E}")
BG=$(tohex "${C_BG:-#0D0A09}")

UM="$HOME/.local/bin/unimatrix"
if   [ -x "$UM" ];                    then CMD="$UM -o -s 95"
elif command -v unimatrix >/dev/null; then CMD="unimatrix -o -s 95"
else                                       CMD="cmatrix -a -C red"; fi

exec xterm -name "matrix-xterm" -title "Matrix" \

    -fg "rgb:$FG" \
    -fa "Fira Code" -fs 10 +sb \
    -e bash -c "$CMD; echo; read -r -n1"
