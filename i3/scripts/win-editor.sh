#!/bin/bash
export NO_FASTFETCH=1
if   command -v nvim >/dev/null; then EDIT=nvim
elif command -v vim  >/dev/null; then EDIT=vim
else                                  EDIT=nano
fi
"$EDIT" ~/.config/i3/config
cd ~/.config/i3 || exit
exec bash
