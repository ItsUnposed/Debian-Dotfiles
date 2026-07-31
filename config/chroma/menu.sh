#!/bin/bash
# Chroma-Farbmenue: Vorschauquadrat + More-Ebene, Auswahl ueber Index
CHROMA="$HOME/.config/chroma"
APPLY="$CHROMA/apply.sh"
THEME="$HOME/.config/rofi/chroma.rasi"
PAL="$CHROMA/palettes"

HAUPT_ORDER=(black red green blue brown pink gray white)

farbe_von() {
    local f="$PAL/$1.conf" c=""
    if [ -f "$f" ]; then
        c=$(grep -m1 '^C_ACC=' "$f" | cut -d= -f2 | tr -d "\"' ")
        [ -z "$c" ] && c=$(grep -m1 -oE '#[0-9A-Fa-f]{6}' "$f")
    fi
    [ -z "$c" ] && c="#888888"
    local h=${c#\#}
    local r=$((16#${h:0:2})) g=$((16#${h:2:2})) b=$((16#${h:4:2}))
    [ $(( (r*299 + g*587 + b*114) / 1000 )) -lt 40 ] && c="#3A3A3A"
    printf '%s' "$c"
}

zeile() {
    printf '<span foreground="%s">\u25A0</span>  %s\n' "$(farbe_von "$1")" "${1^}"
}

ALLE=()
for f in "$PAL"/*.conf; do
    [ -f "$f" ] && ALLE+=("$(basename "$f" .conf)")
done
if [ ${#ALLE[@]} -eq 0 ]; then
    echo "keine Paletten in $PAL"
    exit 1
fi

HAUPT=()
MEHR=()
for n in "${HAUPT_ORDER[@]}"; do
    for a in "${ALLE[@]}"; do
        [ "$a" = "$n" ] && HAUPT+=("$n")
    done
done
for a in "${ALLE[@]}"; do
    drin=0
    for h in "${HAUPT[@]}"; do
        [ "$h" = "$a" ] && drin=1
    done
    [ $drin -eq 0 ] && MEHR+=("$a")
done

frage() {
    local n
    for n in "$@"; do zeile "$n"; done \
      | rofi -dmenu -markup-rows -i -p "Farbe" -theme "$THEME" -format i
}

IDX=$( { for n in "${HAUPT[@]}"; do zeile "$n"; done; echo "More ..."; } \
       | rofi -dmenu -markup-rows -i -p "Farbe" -theme "$THEME" -format i )
[ -z "$IDX" ] && exit 0

if [ "$IDX" -ge "${#HAUPT[@]}" ]; then
    [ ${#MEHR[@]} -eq 0 ] && exit 0
    IDX=$(frage "${MEHR[@]}")
    [ -z "$IDX" ] && exit 0
    NAME="${MEHR[$IDX]}"
else
    NAME="${HAUPT[$IDX]}"
fi

[ -z "$NAME" ] && exit 0
exec "$APPLY" "$NAME"
