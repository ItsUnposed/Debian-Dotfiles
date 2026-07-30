#!/bin/bash
printf '\033]0;Matrix\007'
UM="$HOME/.local/bin/unimatrix"

# Akzentfarbe aus der aktiven Palette laden
if [ -f "$HOME/.config/ember/current.conf" ]; then
    . "$HOME/.config/ember/current.conf"
    h=${C_ACC#\#}
    R=$((0x${h:0:2})); G=$((0x${h:2:2})); B=$((0x${h:4:2}))
    # ANSI-Rot-Steckplatz mit der Palettenfarbe ueberschreiben
    printf '\e]4;1;rgb:%02x/%02x/%02x\e\\' $R $G $B
    printf '\e]4;9;rgb:%02x/%02x/%02x\e\\' $R $G $B
fi

if   [ -x "$UM" ];                    then "$UM" -c red -o -s 95
elif command -v unimatrix >/dev/null; then unimatrix -c red -o -s 95
elif command -v cmatrix   >/dev/null; then cmatrix -a -C red
fi

# Steckplatz nach Beenden zuruecksetzen
printf '\e]4;1;rgb:ff/00/00\e\\'
printf '\e]4;9;rgb:ff/55/55\e\\'
printf '\033]0;Matrix\007'
echo; echo "beendet - Taste zum Schliessen"; read -r -n1
