#!/bin/bash
if command -v cmatrix >/dev/null; then
    cmatrix -ab -C red
else
    echo "FEHLER: cmatrix nicht installiert"
fi
echo; echo "beendet - Taste zum Schliessen"; read -r -n1
