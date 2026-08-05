#!/bin/bash
# Generates one wallpaper per palette from its own colours.
# No external images, so nothing to worry about licence wise.
P="$HOME/.config/chroma/palettes"
W="$HOME/Pictures/Wallpapers"
mkdir -p "$W"
SIZE="1920x1200"

for f in "$P"/*.conf; do
    name=$(basename "$f" .conf)
    ( . "$f"
      bg=${C_BG:-#0A0A0A}; bg2=${C_BG2:-#1C1C1C}
      acc=${C_ACC:-#FF6B5E}; acc3=${C_ACC3:-#6E6E6E}
      out=${WALLPAPER:-$W/${name^}.png}
      out=${out/#\~/$HOME}

      magick -size "$SIZE" \
          radial-gradient:"$acc3"-"$bg" \
          -modulate 100,100 \
          \( -size "$SIZE" gradient:"$bg2"-"$bg" \) \
          -compose overlay -composite \
          \( -size "$SIZE" xc:"$acc" -alpha set -channel A -evaluate set 7% +channel \) \
          -compose over -composite \
          -attenuate 0.25 +noise Gaussian \
          -blur 0x1 \
          "$out" 2>/dev/null \
        && echo "     $(basename "$out")" \
        || echo "     failed: $name"
    )
done
echo ">> done"
