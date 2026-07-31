#!/bin/bash
export PATH="/usr/local/bin:/usr/bin:/bin"

ST=$(i3-msg -t get_tree | jq -r 'recurse(.nodes[]?, .floating_nodes[]?)
     | select(.focused==true) | .floating')

case "$ST" in
  user_on|auto_on)
      # schwebend -> zurueck ins Kacheln = Semi-Vollbild
      i3-msg 'floating disable' >/dev/null ;;
  *)
      # gekachelt -> kleines zentriertes Fenster
      i3-msg 'floating enable, resize set 70 ppt 70 ppt, move position center' >/dev/null ;;
esac
