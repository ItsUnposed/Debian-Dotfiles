#!/bin/bash
# btop-theme.sh -- erzeugt chroma.theme aus der aktiven Palette
. "$HOME/.config/chroma/current.conf"
OUT="$HOME/.config/btop/themes/chroma.theme"
mkdir -p "$(dirname "$OUT")"

cat > "$OUT" << T
theme[main_bg]=""
theme[main_fg]="$C_ACC"
theme[title]="$C_FG"
theme[hi_fg]="$C_ACC2"
theme[selected_bg]="$C_BG2"
theme[selected_fg]="$C_ACC"
theme[inactive_fg]="$C_DIM"
theme[graph_text]="$C_FG"
theme[meter_bg]="$C_BG2"
theme[proc_misc]="$C_ACC2"
theme[cpu_box]="$C_ACC3"
theme[mem_box]="$C_ACC3"
theme[net_box]="$C_ACC3"
theme[proc_box]="$C_ACC3"
theme[div_line]="$C_DIM"
T

for k in temp cpu used available free cached process download upload; do
    cat >> "$OUT" << T
theme[${k}_start]="$C_ACC3"
theme[${k}_mid]="$C_ACC2"
theme[${k}_end]="$C_ACC"
T
done
