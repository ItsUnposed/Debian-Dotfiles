#!/bin/bash
# term-scheme.sh -- schreibt Ember.colorscheme aus der aktiven Palette
. "$HOME/.config/ember/current.conf"
OUT="$HOME/.local/share/qtermwidget6/color-schemes/Ember.colorscheme"
mkdir -p "$(dirname "$OUT")"

mix() { # mix <hex> <anteil_bg_prozent>
  h=${1#\#}; b=${C_BG#\#}
  r=$(( (0x${h:0:2}*(100-$2) + 0x${b:0:2}*$2)/100 ))
  g=$(( (0x${h:2:2}*(100-$2) + 0x${b:2:2}*$2)/100 ))
  bl=$(( (0x${h:4:2}*(100-$2) + 0x${b:4:2}*$2)/100 ))
  printf '%d,%d,%d' $r $g $bl
}

rgb() { h=${1#\#}; printf '%d,%d,%d' 0x${h:0:2} 0x${h:2:2} 0x${h:4:2}; }

cat > "$OUT" << T
[General]
Description=Ember
Opacity=1

[Background]
Color=$(rgb $C_BG)
[BackgroundIntense]
Color=$(rgb $C_BG2)
[Foreground]
Color=$(rgb $C_FG)
[ForegroundIntense]
Color=255,255,255

[Color0]
Color=$(rgb $C_BG2)
[Color0Intense]
Color=$(rgb $C_DIM)
[Color1]
Color=$(mix $C_ACC 4)
[Color1Intense]
Color=$(rgb $C_ACC)
[Color2]
Color=$(rgb $C_ACC3)
[Color2Intense]
Color=$(rgb $C_ACC)
[Color3]
Color=$(rgb $C_ACC)
[Color3Intense]
Color=$(rgb $C_FG)
[Color4]
Color=$(rgb $C_ACC3)
[Color4Intense]
Color=$(rgb $C_ACC)
[Color5]
Color=$(rgb $C_ACC)
[Color5Intense]
Color=$(rgb $C_ACC)
[Color6]
Color=$(rgb $C_ACC)
[Color6Intense]
Color=$(rgb $C_ACC)
[Color7]
Color=$(rgb $C_FG)
[Color7Intense]
Color=255,255,255
T
