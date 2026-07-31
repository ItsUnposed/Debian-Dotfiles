#!/bin/bash

# Zu Workspace 1 wechseln
i3-msg 'workspace number 1'
sleep 0.2

# Alle Fenster auf Workspace 1 schließen
i3-msg '[workspace="1"] kill'
sleep 0.3

# Layout neu aufbauen
~/.config/i3/hacker-startup.sh
