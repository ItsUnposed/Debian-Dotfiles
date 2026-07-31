#!/bin/bash
# Ember-Farbmenue: Vorschauquadrat + More-Ebene, Auswahl ueber Index
EMBER="$HOME/.config/ember"
APPLY="$EMBER/apply.sh"
THEME="$HOME/.config/rofi/ember.rasi"
PAL="$EMBER/palettes"

# --- Reihenfolge im Hauptmenue, alles Uebrige landet unter More ---
HAUPT_ORDER=(black red green blue brown pink)

# --- Vorschaufarbe aus der Palette lesen, sehr dunkle aufhellen ---
farbe_von() {
    local f="$PAL/$1" c=""
    [ -f "$f" ] && c=$(grep -m1 '^C_ACC=' "$f" | cut -d= -f2 | tr -d "\"' ")
    [ -z "$c" ] && c="#888888"
    local h=${c#\#}
    local r=$((16#${h:0:2})) g=$((16#${h:2:2})) b=$((16#${h:4:2}))
    if [ $(( (r*299 + g*587 + b*114) / 1000 )) -lt 40 ]; then c="#3A3A3A"; fi
    printf '%s' "$c"
}

zeile() { printf '<span foreground="%s">\u25A0</span>  %s\n' "$(farbe_von "$1")" "${1^}"; }

# --- vorhandene Paletten einsammeln ---
ALLE=()
for f in "$PAL"/*; do [ -f "$f" ] && ALLE+=("$(basename "$f")"); done
[ ${#ALLE[@]} -eq 0 ] && { echo "keine Paletten in $PAL"; exit 1; }

HAUPT=(); MEHR=()
for n in "${HAUPT_ORDER[@]}"; do
    for a in "${ALLE[@]}"; do [ "$a" = "$n" ] && HAUPT+=("$n"); done
done
for a in "${ALLE[@]}"; do
    drin=0
    for h in "${HAUPT[@]}"; do [ "$h" = "$a" ] && drin=1; done
    [ $drin -eq 0 ] && MEHR+=("$a")
done

frage() {                       # frage <name...>  -> Index auf stdout
    local n
    for n in "$@"; do zeile "$n"; done \
      | rofi -dmenu -markup-rows -i -p "Farbe" -theme "$THEME" -format i
}

# --- Ebene 1: Hauptfarben plus More ---
ZEILEN=("${HAUPT[@]}")
IDX=$( { for n in "${ZEILEN[@]}"; do zeile "$n"; done; echo "More ..."; } \
       | rofi -dmenu -markup-rows -i -p "Farbe" -theme "$THEME" -format i )
[ -z "$IDX" ] && exit 0

if [ "$IDX" -ge "${#ZEILEN[@]}" ]; then
    [ ${#MEHR[@]} -eq 0 ] && exit 0
    IDX=$(frage "${MEHR[@]}")
    [ -z "$IDX" ] && exit 0
    NAME="${MEHR[$IDX]}"
else
    NAME="${ZEILEN[$IDX]}"
fi

[ -z "$NAME" ] && exit 0
exec "$APPLY" "$NAME"
