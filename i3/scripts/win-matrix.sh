#!/bin/bash
UM="$HOME/.local/bin/unimatrix"
if   [ -x "$UM" ];                    then "$UM" -o -s 95
elif command -v unimatrix >/dev/null; then unimatrix -o -s 95
fi
echo; echo "beendet"; read -r -n1
