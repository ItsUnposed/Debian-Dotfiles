#!/bin/bash
export PATH="/usr/local/bin:/usr/bin:/bin"
E="$HOME/.config/ember"

LIST=$(ls "$E/palettes"/*.conf | xargs -n1 basename | sed 's/\.conf$//' \
       | sed 's/^./\U&/' | sort)

CH=$(printf '%s\n' "$LIST" | rofi -dmenu -i -no-custom -p "Colors" \
     -lines 14 -theme "$HOME/.config/rofi/ember.rasi")
[ -z "$CH" ] && exit 0

"$E/apply.sh" "$(printf '%s' "$CH" | tr 'A-Z' 'a-z')"
