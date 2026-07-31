#!/bin/bash
. "$HOME/.config/ember/current.conf"

h3() {
    h=${1#\#}
    printf '#%x%x%x' \
        $(( (0x${h:0:2}+8)/17 )) \
        $(( (0x${h:2:2}+8)/17 )) \
        $(( (0x${h:4:2}+8)/17 ))
}

A=$(h3 "$C_ACC")    # Kommentare: hell, fett
A2=$(h3 "$C_ACC2")  # Keywords: mittel, normal
A3=$(h3 "$C_ACC3"); BG=$(h3 "$C_BG"); FG=$(h3 "$C_FG")
N="$HOME/.nanorc"

# 1. bold entfernen, alle auf Keyword-Farbe setzen
sed -i -E "s|^(extendsyntax [^ ]+ color )bold,([^ ]+)|\1\2|" "$N"
sed -i -E "s|^(extendsyntax [^ ]+ color )[^ ]+|\1${A2}|" "$N"

# 2. Kommentarzeilen auf Kommentarfarbe + fett
sed -i -E "/extendsyntax .* \".*(\"|)(#|\/\/|\/\\\*|<!--)/ \
    s|^(extendsyntax [^ ]+ color )${A2}|\1bold,${A}|" "$N"

# 3. Oberflaeche
sed -i -E "s|^(set (title\|status)color +).*|\1${BG},${A}|" "$N"
sed -i -E "s|^(set keycolor +).*|\1${A}|" "$N"
sed -i -E "s|^(set numbercolor +).*|\1${A2}|" "$N"
sed -i -E "s|^(set functioncolor +).*|\1${FG}|" "$N"
sed -i -E "s|^(set promptcolor +).*|\1${FG},${BG}|" "$N"
sed -i -E "s|^(set selectedcolor +).*|\1${BG},${A}|" "$N"
sed -i -E "s|^(set errorcolor +).*|\1${FG},${A3}|" "$N"

# 4. i3-Syntax
I="$HOME/.nano/i3.nanorc"
if [ -f "$I" ]; then
    sed -i -E "s|^(color )bold,([^ ]+)|\1\2|" "$I"
    sed -i -E "s|^(color )[^ ]+|\1${A2}|" "$I"
    sed -i -E "/^color ${A2} .*#/ s|^(color )${A2}|\1bold,${A}|" "$I"
fi

# 5. Shell-spezifische Hervorhebungen per extendsyntax
A_VAR="$A2"   # $-Variablen: Keyword-Farbe
A_STR="$A"    # Strings: Kommentarfarbe
A_NUM="$A2"   # Zahlen
A_KW="$A2"    # if, for, while, do, done, then, else, fi, case, esac

for SYN in sh bash; do
    grep -q "extendsyntax $SYN" "$N" 2>/dev/null || {
        cat >> "$N" << NANO
extendsyntax $SYN color bold,$A "(^|[[:space:]])#.*"
extendsyntax $SYN color $A_KW "\<(if|fi|else|elif|for|while|do|done|case|esac|then|in|return|export|local|function|source)\>"
extendsyntax $SYN color $A_VAR "\\\$[A-Za-z_][A-Za-z0-9_]*|\\\$\{[^}]+\}|\\\$\([^)]+\)"
extendsyntax $SYN color $A_STR "\"[^\"]*\"|'[^']*'"
extendsyntax $SYN color $A_NUM "\b[0-9]+\b"
NANO
    }
done
