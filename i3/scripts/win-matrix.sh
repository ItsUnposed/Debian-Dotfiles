#!/bin/bash
printf '\033]0;matrix\007'
if command -v cmatrix >/dev/null; then
    cmatrix -ab -C red
else
    echo "FEHLER: cmatrix nicht installiert"
fi
printf '\033]0;matrix\007'
echo; echo "beendet - Taste zum Schliessen"; read -r -n1
