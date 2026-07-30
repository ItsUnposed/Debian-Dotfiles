#!/bin/bash
. "$HOME/.config/ember/current.conf"
WP="$WALLPAPER"
[ -f "$WP" ] || WP="$HOME/Pictures/Wallpapers/Red.png"
sudo convert "$WP" -brightness-contrast -30x0 /usr/share/backgrounds/login-bg.png 2>/dev/null

sudo mkdir -p /usr/share/themes/Ember-Greeter/gtk-3.0
sudo tee /usr/share/themes/Ember-Greeter/gtk-3.0/gtk.css > /dev/null << T
@import url("/usr/share/themes/Adwaita-dark/gtk-3.0/gtk.css");
#panel_window { background-color: $C_BG; color: $C_FG; border-bottom: 1px solid $C_ACC; }
#clock_label { color: $C_ACC; font-weight: bold; }
#login_window {
    background-color: $C_BG;
    border: 2px solid $C_ACC;
    border-radius: 14px;
    color: $C_FG;
    padding: 22px;
}
#user_image { border: 3px solid $C_ACC; border-radius: 50%; padding: 3px; }
entry {
    background-color: $C_BG2;
    background-image: none;
    color: $C_FG;
    border: 1px solid $C_ACC3;
    border-radius: 8px;
    caret-color: $C_ACC;
    padding: 8px;
}
entry:focus { border-color: $C_ACC; }
button {
    background-image: none;
    background-color: $C_BG2;
    color: $C_ACC;
    border: 1px solid $C_ACC;
    border-radius: 8px;
    padding: 6px 14px;
}
button:hover { background-color: $C_ACC3; color: $C_FG; }
label { color: $C_FG; }
#shutdown_dialog, #restart_dialog {
    background-color: $C_BG;
    border: 2px solid $C_ACC;
    border-radius: 12px;
}
T

sudo tee /etc/lightdm/lightdm-gtk-greeter.conf > /dev/null << T
[greeter]
background=/usr/share/backgrounds/login-bg.png
theme-name=Ember-Greeter
icon-theme-name=Papirus-Dark
font-name=Fira Code 11
cursor-theme-name=Adwaita
cursor-theme-size=24
xft-antialias=true
xft-hintstyle=hintslight
user-background=false
hide-user-image=false
round-user-image=true
default-user-image=/usr/share/backgrounds/omen-avatar.png
clock-format=%H:%M   %A, %d. %B
indicators=~host;~spacer;~clock;~spacer;~session;~power
position=50%,center 50%,center
panel-position=top
T
