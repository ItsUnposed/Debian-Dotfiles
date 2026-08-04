#!/bin/bash
# Builds a notification theme from the active palette.
. "$HOME/.config/chroma/current.conf" 2>/dev/null || exit 0

D=/usr/share/themes/Chroma-Notify/xfce-notify-4.0
sudo mkdir -p "$D"

sudo tee "$D/gtk.css" > /dev/null << T
.notification-window,
#XfceNotifyWindow {
    background-color: ${C_BG};
    border: 2px solid ${C_ACC};
    border-radius: 12px;
    padding: 10px;
}
#XfceNotifyWindow .summary,
.notification-window .summary {
    color: ${C_ACC};
    font-weight: bold;
}
#XfceNotifyWindow .body,
.notification-window .body {
    color: ${C_FG};
}
#XfceNotifyWindow label,
.notification-window label { color: ${C_FG}; }

#XfceNotifyWindow button,
.notification-window button {
    background-image: none;
    background-color: ${C_BG2};
    color: ${C_ACC};
    border: 1px solid ${C_ACC3};
    border-radius: 8px;
    padding: 4px 10px;
}
#XfceNotifyWindow button:hover,
.notification-window button:hover {
    background-color: ${C_ACC3};
    color: ${C_FG};
}

#XfceNotifyWindow progressbar trough,
.notification-window progressbar trough {
    background-color: ${C_BG2};
    border: 1px solid ${C_ACC3};
    border-radius: 6px;
}
#XfceNotifyWindow progressbar progress,
.notification-window progressbar progress {
    background-color: ${C_ACC};
    border-radius: 6px;
}
T

xfconf-query -c xfce4-notifyd -p /theme -s "Chroma-Notify" --create -t string 2>/dev/null
pkill -x xfce4-notifyd 2>/dev/null
