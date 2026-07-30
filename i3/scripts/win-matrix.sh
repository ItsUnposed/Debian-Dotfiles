#!/bin/bash
UM="$HOME/.local/bin/unimatrix"
if   [ -x "$UM" ];                    then "$UM" -c red -o -s 95
elif command -v unimatrix >/dev/null; then unimatrix -c red -o -s 95
fi
echo; echo "beendet"; read -r -n1
