#!/bin/bash
. "$HOME/.config/ember/current.conf"
T="/boot/grub/themes/ember"
sudo mkdir -p "$T"
sudo convert -size 1920x1200 gradient:"$C_BG"-"$C_ACC3" "$T/background.png" 2>/dev/null

sudo tee "$T/theme.txt" > /dev/null << T2
desktop-image: "background.png"
desktop-color: "$C_BG"
title-text: ""
terminal-font: "Fira Code Regular 16"

+ label {
    top = 14%
    left = 0
    width = 100%
    align = "center"
    text = "unposed @ debian"
    color = "$C_ACC"
    font = "Fira Code Bold 24"
}
+ boot_menu {
    left = 28%
    top = 32%
    width = 44%
    height = 42%
    item_font = "Fira Code Regular 18"
    item_color = "$C_DIM"
    selected_item_color = "$C_ACC"
    item_height = 36
    item_spacing = 10
    item_padding = 10
    icon_width = 0
    icon_height = 0
    scrollbar = false
}
+ label {
    top = 84%
    left = 0
    width = 100%
    align = "center"
    text = "Enter startet, e bearbeitet, c Konsole"
    color = "$C_ACC3"
    font = "Fira Code Regular 14"
}
+ progress_bar {
    id = "__timeout__"
    top = 78%
    left = 30%
    width = 40%
    height = 12
    show_text = false
    fg_color = "$C_ACC"
    bg_color = "$C_BG2"
    border_color = "$C_ACC3"
}
T2

[ -f "$T/firacode16.pf2" ] || sudo grub-mkfont -s 16 -o "$T/firacode16.pf2" /usr/share/fonts/truetype/firacode/FiraCode-Regular.ttf 2>/dev/null

sudo sed -i 's|^GRUB_THEME=.*|GRUB_THEME="/boot/grub/themes/ember/theme.txt"|' /etc/default/grub
grep -q "^GRUB_THEME=" /etc/default/grub || echo 'GRUB_THEME="/boot/grub/themes/ember/theme.txt"' | sudo tee -a /etc/default/grub >/dev/null
sudo update-grub 2>/dev/null
