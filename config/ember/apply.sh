#!/bin/bash
# ember/apply.sh <farbe>   -- setzt das gesamte System auf eine Palette
export PATH="/usr/local/bin:/usr/bin:/bin:$HOME/.local/bin"
E="$HOME/.config/ember"

P="$E/palettes/$1.conf"
[ -f "$P" ] || { echo "Palette $1 nicht gefunden"; exit 1; }
cp "$P" "$E/current.conf"
. "$E/current.conf"

hex2rgb() { printf '%d,%d,%d' 0x${1:1:2} 0x${1:3:2} 0x${1:5:2}; }
hex2ansi() { printf '38;2;%d;%d;%d' 0x${1:1:2} 0x${1:3:2} 0x${1:5:2}; }

# --- 1. Wallpaper ---
[ -f "$WALLPAPER" ] && feh --no-fehbg --bg-fill "$WALLPAPER"

# --- 2. cava ---
if [ -f "$HOME/.config/cava/config" ]; then
  awk '/^[[:space:]]*\[color\]/{s=1;next} s&&/^[[:space:]]*\[/{s=0} !s' \
      "$HOME/.config/cava/config" > /tmp/cava.new
  cat >> /tmp/cava.new << EOF

[color]
background = default
gradient = 1
gradient_count = 4
gradient_color_1 = '$C_ACC3'
gradient_color_2 = '$C_ACC2'
gradient_color_3 = '$C_ACC'
gradient_color_4 = '$C_FG'
EOF
  mv /tmp/cava.new "$HOME/.config/cava/config"
fi

# --- 3. fastfetch ---
FF="$HOME/.config/fastfetch"
[ -f "$FF/hacker.jsonc" ] && python3 "$E/ff-colors.py" "$FF/hacker.jsonc" "$C_ACC" "$C_ACC2" "$C_ACC3" >/dev/null 2>&1
[ -f "$FF/config.jsonc" ] && python3 "$E/ff-colors.py" "$FF/config.jsonc" "$C_ACC" "$C_ACC2" "$C_ACC3" invert >/dev/null 2>&1

# --- 4. rofi ---
if [ -f "$E/templates/ember.rasi" ]; then
  sed -e "s|@@BG@@|$C_BG|g" -e "s|@@BG2@@|$C_BG2|g" -e "s|@@DIM@@|$C_DIM|g" \
      -e "s|@@FG@@|$C_FG|g" -e "s|@@ACC@@|$C_ACC|g" -e "s|@@ACC2@@|$C_ACC2|g" \
      -e "s|@@ACC3@@|$C_ACC3|g" \
      "$E/templates/ember.rasi" > "$HOME/.config/rofi/ember.rasi"
fi

# --- 5. GTK ---
if [ -f "$E/templates/gtk.css" ]; then
  sed -e "s|@@BG@@|$C_BG|g" -e "s|@@BG2@@|$C_BG2|g" -e "s|@@DIM@@|$C_DIM|g" \
      -e "s|@@FG@@|$C_FG|g" -e "s|@@ACC@@|$C_ACC|g" -e "s|@@ACC2@@|$C_ACC2|g" \
      -e "s|@@ACC3@@|$C_ACC3|g" \
      "$E/templates/gtk.css" > "$HOME/.config/gtk-3.0/gtk.css"
  cp "$HOME/.config/gtk-3.0/gtk.css" "$HOME/.config/gtk-4.0/gtk.css"
fi

# --- 6. Benachrichtigungen ---
if [ -f "$E/templates/notify.css" ]; then
  sed -e "s|@@BG2@@|$C_BG2|g" -e "s|@@FG@@|$C_FG|g" -e "s|@@ACC@@|$C_ACC|g" \
      -e "s|@@DIM@@|$C_DIM|g" \
      "$E/templates/notify.css" > "$HOME/.themes/Ember/xfce-notify-4.0/gtk.css"
fi

# --- 7. btop ---
[ -x "$E/btop-theme.sh" ] && "$E/btop-theme.sh"

# --- 8. i3 Fensterrahmen ---
C="$HOME/.config/i3/config"
sed -i -e "s|^set \$bg .*|set \$bg     $C_BG|" \
       -e "s|^set \$fg .*|set \$fg     $C_FG|" \
       -e "s|^set \$red .*|set \$red    $C_ACC2|" \
       -e "s|^set \$orange .*|set \$orange $C_ACC|" \
       -e "s|^set \$inact .*|set \$inact  $C_BG2|" \
       -e "s|^set \$dim .*|set \$dim    $C_DIM|" \
       -e "s|^set \$ltred .*|set \$ltred  $C_ACC|" \
       -e "s|^set \$dkred .*|set \$dkred  $C_ACC3|" "$C"
sed -i "s|Pictures/Wallpapers/[A-Za-z-]*\.png|Pictures/Wallpapers/$(basename $WALLPAPER)|g" "$C"
[ -f "$HOME/.xsessionrc" ] && sed -i "s|Pictures/Wallpapers/[A-Za-z-]*\.png|Pictures/Wallpapers/$(basename $WALLPAPER)|g" "$HOME/.xsessionrc"

# --- 9. qterminal ---
Q="$HOME/.local/share/qtermwidget6/color-schemes/Ember.colorscheme"
if [ -f "$Q" ]; then
  sed -i -e "0,/^\[Background\]/{}" "$Q"
  python3 - "$Q" "$C_BG" "$C_FG" "$C_ACC" "$C_ACC2" << 'PY'
import sys,re
p,bg,fg,acc,acc2=sys.argv[1:6]
def rgb(h): return "%d,%d,%d"%(int(h[1:3],16),int(h[3:5],16),int(h[5:7],16))
s=open(p).read()
s=re.sub(r'(\[Background\]\nColor=)[\d,]+', r'\g<1>'+rgb(bg), s)
s=re.sub(r'(\[Foreground\]\nColor=)[\d,]+', r'\g<1>'+rgb(fg), s)
s=re.sub(r'(\[Color1\]\nColor=)[\d,]+', r'\g<1>'+rgb(acc2), s)
s=re.sub(r'(\[Color1Intense\]\nColor=)[\d,]+', r'\g<1>'+rgb(acc), s)
open(p,'w').write(s)
PY
fi

# --- 10. flameshot ---
F="$HOME/.config/flameshot/flameshot.ini"
[ -f "$F" ] && { pkill flameshot 2>/dev/null; \
  sed -i -e "s|^uiColor=.*|uiColor=$C_ACC|" -e "s|^contrastUiColor=.*|contrastUiColor=$C_ACC3|" \
         -e "s|^drawColor=.*|drawColor=$C_ACC|" "$F"; }

# --- 11. Uhr in der Bar ---
xfconf-query -c xfce4-panel -p /plugins/plugin-19/digital-time-format \
  -s "<span foreground=\"$C_ACC\" size=\"large\"><b>%H:%M:%S</b></span>" 2>/dev/null

# --- 12. neu laden ---
pkill xfsettingsd 2>/dev/null; sleep 1; setsid xfsettingsd --daemon >/dev/null 2>&1 &
pkill -x cava 2>/dev/null
pkill xfce4-notifyd 2>/dev/null
if pgrep -x xfce4-panel >/dev/null; then
  xfce4-panel --quit 2>/dev/null; sleep 2
fi
setsid xfce4-panel --disable-wm-check >/dev/null 2>&1 &
i3-msg reload >/dev/null 2>&1

notify-send -a ember "Theme gewechselt" "Palette: $NAME"


# --- 13. matrix fest auf rot-steckplatz ---

# --- 14. nano ---
if [ -f "$HOME/.nanorc" ]; then
  sed -i -E "s/^(extendsyntax [^ ]+ color )(bright)?[a-z]+/\\1$T/" "$HOME/.nanorc"
  sed -i -E "s/^(set (title|status)color +)[a-z]+,[a-z]+/\\1white,$T/" "$HOME/.nanorc"
  sed -i -E "s/^(set keycolor +).*/\\1bright$T/" "$HOME/.nanorc"
  sed -i -E "s/^(set numbercolor +).*/\\1$T/" "$HOME/.nanorc"
  sed -i -E "s/^(set selectedcolor +)[a-z]+,[a-z]+/\\1black,bright$T/" "$HOME/.nanorc"
fi
if [ -f "$HOME/.nano/i3.nanorc" ]; then
  sed -i -E "s/color (bright)?[a-z]+ /color $T /g" "$HOME/.nano/i3.nanorc"
fi

# --- 15. Workspace 1 zuruecksetzen ---
LOCK="/tmp/ember-ws-reset.lock"
if [ -x "$HOME/.config/i3/hacker-startup.sh" ] && mkdir "$LOCK" 2>/dev/null; then
  ( sleep 2
    i3-msg "workspace number 1" >/dev/null 2>&1
    sleep 0.5
    for i in 1 2 3 4 5 6; do
      i3-msg '[workspace="__focused__"] kill' >/dev/null 2>&1
      sleep 0.4
    done
    sleep 1.5
    pkill -x cava 2>/dev/null
    pkill -f unimatrix 2>/dev/null
    "$HOME/.config/i3/hacker-startup.sh"
    rmdir "$LOCK" 2>/dev/null
  ) &
fi

# --- 16. Terminal, nano, ls ---
[ -x "$E/term-scheme.sh" ] && "$E/term-scheme.sh"
[ -x "$E/nano-colors.sh" ] && "$E/nano-colors.sh"
[ -x "$E/dircolors.sh" ]   && "$E/dircolors.sh"

# --- 16. Terminal, nano, ls ---
[ -x "$E/term-scheme.sh" ] && "$E/term-scheme.sh"
[ -x "$E/nano-colors.sh" ] && "$E/nano-colors.sh"
[ -x "$E/dircolors.sh" ]   && "$E/dircolors.sh"

# --- 17. qterminal schema sperren ---
chmod 444 "$HOME/.config/qterminal.org/qterminal.ini" 2>/dev/null

# --- 18. grub und login mitwechseln ---

# --- 18. login mitwechseln ---
sudo /usr/local/sbin/ember-boot-theme "$E/current.conf" "$WALLPAPER" >/dev/null 2>&1 &

# --- 19. thunar neu laden ---
thunar -q 2>/dev/null; pkill -f "thunar --daemon" 2>/dev/null
