#!/bin/bash
# textfarbe "#RRGGBB"  ->  #000000 bei hellem, #FFFFFF bei dunklem Hintergrund
textfarbe() {
    local h=${1#\#}
    local r=$((16#${h:0:2})) g=$((16#${h:2:2})) b=$((16#${h:4:2}))
    local y=$(( (r*299 + g*587 + b*114) / 1000 ))
    if [ "$y" -gt 145 ]; then echo "#000000"; else echo "#FFFFFF"; fi
}
