#!/bin/bash
# Dev-Layout: IDE links, Matrix oben rechts, pipes unten rechts
S="$HOME/.config/i3/scripts"
R="$HOME/.config/rofi/chroma.rasi"
A="$HOME/.local/share/applications"

ico() { grep -h "^Icon=" "$A"/jetbrains-$1-*.desktop 2>/dev/null | head -1 | cut -d= -f2; }
I_PY=$(ico pycharm); I_ID=$(ico idea); I_CL=$(ico clion)

CHOICE=$(printf '%b' \
  "PyCharm\0icon\x1f${I_PY}\n" \
  "IntelliJ IDEA\0icon\x1f${I_ID}\n" \
  "CLion\0icon\x1f${I_CL}\n" \
  | rofi -dmenu -i -p "IDE" -show-icons -theme "$R")
[ -z "$CHOICE" ] && exit 0

find_bin() {
    for c in "$@"; do
        [ -x "$HOME/.local/share/JetBrains/Toolbox/scripts/$c" ] && \
            { echo "$HOME/.local/share/JetBrains/Toolbox/scripts/$c"; return; }
        command -v "$c" >/dev/null && { command -v "$c"; return; }
    done
}

case "$CHOICE" in
    PyCharm*)  BIN=$(find_bin pycharm pycharm-professional charm) ;;
    IntelliJ*) BIN=$(find_bin idea intellij-idea-ultimate) ;;
    CLion*)    BIN=$(find_bin clion) ;;
esac

[ -z "$BIN" ] && { rofi -e "Kein Binary fuer $CHOICE gefunden" -theme "$R"; exit 1; }

wcount() { i3-msg -t get_tree | grep -o '"window":[0-9]\+' | wc -l; }

wait_new() {
    local before="$1" i
    for i in $(seq 1 300); do
        sleep 0.1
        [ "$(wcount)" -gt "$before" ] && return 0
    done
    return 1
}

# --- 1) IDE starten, 5 Sekunden warten ---
B=$(wcount)
i3-msg "exec --no-startup-id $BIN" >/dev/null
wait_new "$B" || exit 1
sleep 5
i3-msg 'mark ide' >/dev/null

# --- 2) rechts daneben: Matrix ---
i3-msg '[con_mark="ide"] focus; split h' >/dev/null
B=$(wcount)
i3-msg "exec --no-startup-id $S/hotkey-matrix.sh" >/dev/null
wait_new "$B" || exit 1
sleep 0.5
i3-msg 'mark mx' >/dev/null

# --- 3) unter Matrix: pipes ---
i3-msg '[con_mark="mx"] focus; split v' >/dev/null
B=$(wcount)
i3-msg "exec --no-startup-id $S/hotkey-pipes.sh" >/dev/null
wait_new "$B" || exit 1
sleep 0.5
i3-msg 'mark pp' >/dev/null

# --- 4) Groessen ---
i3-msg '[con_mark="ide"] focus; resize set width 80 ppt' >/dev/null
i3-msg '[con_mark="mx"]  focus; resize set height 50 ppt' >/dev/null

# --- 5) Fokus auf die IDE ---
i3-msg '[con_mark="ide"] focus' >/dev/null
