#!/bin/bash
. "$HOME/.config/chroma/current.conf"
a()  { h=${1#\#}; printf '38;2;%d;%d;%d' 0x${h:0:2} 0x${h:2:2} 0x${h:4:2}; }
ACC=$(a $C_ACC); ACC2=$(a $C_ACC2); ACC3=$(a $C_ACC3)
FG=$(a $C_FG);   DIM=$(a $C_DIM)

cat > "$HOME/.dircolors" << T
TERM xterm
TERM xterm-256color
TERM xterm-color
TERM screen
TERM tmux-256color

RESET 0
NORMAL 00
FILE 00
DIR 01;$ACC
LINK $ACC2
MULTIHARDLINK $ACC2
FIFO $ACC3
SOCK 01;$ACC2
DOOR 01;$ACC2
BLK $ACC2
CHR $ACC2
ORPHAN 01;$FG;48;2;120;30;30
MISSING 01;$FG;48;2;120;30;30
EXEC 01;$ACC2
SETUID 01;$FG
SETGID 01;$FG
CAPABILITY $ACC2
OTHER_WRITABLE 01;$ACC
STICKY 01;$ACC

.tar $ACC3
.tgz $ACC3
.gz  $ACC3
.xz  $ACC3
.zst $ACC3
.bz2 $ACC3
.zip $ACC3
.7z  $ACC3
.rar $ACC3
.deb $ACC3

.png  $ACC2
.jpg  $ACC2
.jpeg $ACC2
.gif  $ACC2
.svg  $ACC2
.webp $ACC2
.mp4  $ACC2
.mkv  $ACC2
.pdf  $ACC2
.mp3  $ACC2
.flac $ACC2
.wav  $ACC2

.c    $ACC
.h    $ACC
.cpp  $ACC
.hpp  $ACC
.py   $ACC
.sh   $ACC
.rs   $ACC
.java $ACC

.conf   $FG
.json   $FG
.jsonc  $FG
.rasi   $FG
.nanorc $FG
.ini    $FG
.md     $FG
.bak    $DIM
.log    $DIM
T
