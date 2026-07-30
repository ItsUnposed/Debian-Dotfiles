#!/bin/bash
[ -f "$HOME/.config/ember/current.conf" ] && . "$HOME/.config/ember/current.conf"
COL="${C_TERM:-green}"
UM="$HOME/.local/bin/unimatrix"
if   [ -x "$UM" ];                    then "$UM" -c "$COL" -o -s 95
elif command -v unimatrix >/dev/null; then unimatrix -c "$COL" -o -s 95
fi
echo; echo "beendet"; read -r -n1
