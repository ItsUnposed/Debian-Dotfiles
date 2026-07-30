#!/bin/bash
. "$HOME/.config/ember/current.conf"
low() { printf '%s' "$1" | tr 'A-F' 'a-f'; }
A=$(low "$C_ACC"); A2=$(low "$C_ACC2"); A3=$(low "$C_ACC3")
BG=$(low "$C_BG"); FG=$(low "$C_FG")

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
