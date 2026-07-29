#!/bin/bash
export NO_FASTFETCH=1
export WIN_TITLE="i3 config"
printf '\033]0;i3 config\007'
vim ~/.config/i3/config
cd ~/.config/i3 || exit
exec bash
