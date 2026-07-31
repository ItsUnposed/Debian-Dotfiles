#!/bin/bash
export PATH="/usr/local/bin:/usr/bin:/bin"
E="$HOME/.config/ember"
THEME="$HOME/.config/rofi/ember.rasi"
FAV="aqua orange yellow darkblue silver white"

hex() { sed -n "s/^C_ACC=[\"']\{0,1\}\([^\"']*\).*/\1/p" "$E/palettes/$1.conf" | head -1; }
cap() { printf '%s' "$1" | sed 's/^./\U&/'; }

rows() {
    for p in $1; do
        [ -f "$E/palettes/$p.conf" ] || continue
        printf "<span foreground='%s'>\u25a0\u25a0</span>  %s\n" "$(hex "$p")" "$(cap "$p")"
    done
}

pick() {
    local list="$1" n
    n=$(printf '%s' "$list" | grep -c .)
    printf '%s' "$list" | rofi -dmenu -i -no-custom -markup-rows \
        -p "Colors" -lines "$n" -theme "$THEME"
}

ALL=$(ls "$E/palettes"/*.conf | xargs -n1 basename | sed 's/\.conf$//' | sort)

MAIN=$(rows "$FAV")
MAIN="$MAIN$(printf "<span foreground='#8A7A72'>\u25be\u25be</span>  More\n")"
CH=$(pick "$MAIN")
[ -z "$CH" ] && exit 0

if [ "${CH##*  }" = "More" ]; then
    REST=""
    for p in $ALL; do
        case " $FAV " in *" $p "*) continue ;; esac
        REST="$REST $p"
    done
    CH=$(pick "$(rows "$REST")")
    [ -z "$CH" ] && exit 0
fi

NAME=$(printf '%s' "$CH" | sed 's/.*>  //' | tr 'A-Z' 'a-z')
[ -f "$E/palettes/$NAME.conf" ] && exec "$E/apply.sh" "$NAME"
