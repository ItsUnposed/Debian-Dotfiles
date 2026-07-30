#!/bin/bash
. "$HOME/.config/ember/current.conf"

# #RRGGBB -> #rgb, weil nano nur dreistellige Hexcodes kennt
h3() {
    h=${1#\#}
    r=$((0x${h:0:2})); g=$((0x${h:2:2})); b=$((0x${h:4:2}))
    printf '#%x%x%x' $(( (r+8)/17 )) $(( (g+8)/17 )) $(( (b+8)/17 ))
}

A=$(h3 "$C_ACC"); A2=$(h3 "$C_ACC2"); A3=$(h3 "$C_ACC3")
BG=$(h3 "$C_BG"); FG=$(h3 "$C_FG")

N="$HOME/.nanorc"
sed -i -E "s/^(extendsyntax [^ ]+ color )[a-zA-Z#0-9]+/\1$A/" "$N"
sed -i -E "s/^(set (title|status)color +).*/\1$BG,$A/" "$N"
sed -i -E "s/^(set errorcolor +).*/\1$FG,$A3/" "$N"
sed -i -E "s/^(set keycolor +).*/\1$A/" "$N"
sed -i -E "s/^(set numbercolor +).*/\1$A2/" "$N"
sed -i -E "s/^(set functioncolor +).*/\1$FG/" "$N"
sed -i -E "s/^(set promptcolor +).*/\1$FG,$BG/" "$N"
sed -i -E "s/^(set selectedcolor +).*/\1$BG,$A/" "$N"

I="$HOME/.nano/i3.nanorc"
[ -f "$I" ] && sed -i -E "s/color [a-zA-Z#0-9]+ /color $A /g" "$I"
