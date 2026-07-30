#!/bin/bash
printf '\033]0;Matrix\007'

if [ -f "$HOME/.config/ember/current.conf" ]; then
    . "$HOME/.config/ember/current.conf"
    h=${C_ACC#\#}
    R="0x${h:0:2}"; G="0x${h:2:2}"; B="0x${h:4:2}"
    r=$(printf '%d' $R); g=$(printf '%d' $G); b=$(printf '%d' $B)
else
    r=255; g=107; b=94
fi

UM="$HOME/.local/bin/unimatrix"
CMD=""
if   [ -x "$UM" ];                    then CMD="$UM -c red -o -s 95"
elif command -v unimatrix >/dev/null; then CMD="unimatrix -c red -o -s 95"
elif command -v cmatrix   >/dev/null; then CMD="cmatrix -a -C red"
fi

xterm \
    -bg "#${C_BG#\#}" \
    -fg "rgb:$(printf '%02x/%02x/%02x' $r $g $b)" \
    -title "Matrix" \
    -fa "Fira Code" -fs 10 \
    -cr "rgb:$(printf '%02x/%02x/%02x' $r $g $b)" \
    -e "bash -c '$CMD; echo; echo beendet; read -r -n1'" &

exit 0
