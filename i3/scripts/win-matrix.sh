#!/bin/bash
printf '\033]0;Matrix\007'
UM="$HOME/.local/bin/unimatrix"
if   [ -x "$UM" ];                    then "$UM" -o -s 95
elif command -v unimatrix >/dev/null; then unimatrix -o -s 95
elif command -v cmatrix   >/dev/null; then cmatrix -a
fi
printf '\033]0;Matrix\007'
echo; echo "beendet - Taste zum Schliessen"; read -r -n1
