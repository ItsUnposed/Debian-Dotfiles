#!/bin/bash
# Hackerstartup: 2x2-Grid auf Workspace 1
#   links oben: fastfetch (kleines Fenster)   rechts oben:  btop
#   links unten: cava (grosses Fenster)       rechts unten: cmatrix

WS="1"          # Name deines Workspace, ggf. anpassen
D=1.6           # Wartezeit pro Fenster in Sekunden

# Alte Instanzen aufraeumen, damit nichts doppelt laeuft
pkill -x cava    2>/dev/null
pkill -x cmatrix 2>/dev/null

i3-msg "workspace $WS" >/dev/null
sleep 0.5

# 1) Fenster A: normales Terminal. Fastfetch kommt aus der .bashrc
qterminal &
sleep $D

# 2) Fenster B rechts daneben: btop
i3-msg "split h" >/dev/null
qterminal -e bash -c 'btop' &
sleep $D

# 3) zurueck nach links, Fenster C darunter: cava
i3-msg "focus left" >/dev/null
i3-msg "split v" >/dev/null
qterminal -e bash -c 'cava' &
sleep $D

# 4) cava bekommt den frei gewordenen Platz von fastfetch
i3-msg "resize grow height 15 px or 15 ppt" >/dev/null

# 5) rechte Spalte, Fenster D darunter: cmatrix in Rot
i3-msg "focus right" >/dev/null
i3-msg "split v" >/dev/null
qterminal -e bash -c 'cmatrix -ab -C red' &
sleep $D

# 6) Fokus zurueck auf das Terminal links oben
i3-msg "focus left" >/dev/null
i3-msg "focus up"   >/dev/null
