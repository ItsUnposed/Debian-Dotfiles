#!/bin/bash
# Sichert den aktuellen Systemzustand ins Repo. Aufruf: ~/dotfiles/save.sh
set -e
D="$HOME/dotfiles"
mkdir -p "$D"/{config,home,system,packages,xfce}

# --- ~/.config ---
for x in i3 ember rofi fastfetch cava btop flameshot gtk-3.0 qterminal.org; do
    [ -e "$HOME/.config/$x" ] && rsync -a --delete "$HOME/.config/$x" "$D/config/"
done
cp "$HOME/.config/picom.conf" "$D/config/" 2>/dev/null || true

# --- Home ---
for f in .bashrc .profile .nanorc .xsessionrc; do
    [ -f "$HOME/$f" ] && cp "$HOME/$f" "$D/home/"
done
[ -d "$HOME/.nano" ] && rsync -a --delete "$HOME/.nano" "$D/home/"

# --- System ---
mkdir -p "$D/system/lightdm" "$D/system/themes" "$D/system/sudoers.d"
sudo cp /etc/lightdm/lightdm-gtk-greeter.conf "$D/system/lightdm/" 2>/dev/null || true
sudo cp -r /usr/share/themes/Ember-Greeter "$D/system/themes/" 2>/dev/null || true
sudo cp /etc/sudoers.d/ember-theme "$D/system/sudoers.d/" 2>/dev/null || true
sudo cp /etc/default/grub "$D/system/" 2>/dev/null || true
sudo cp -r /usr/share/X11/xkb/symbols/deumlaut "$D/system/" 2>/dev/null || true
sudo chown -R "$USER:$USER" "$D/system"

# --- Pakete ---
apt-mark showmanual > "$D/packages/apt.txt"
flatpak list --app --columns=application > "$D/packages/flatpak.txt" 2>/dev/null || true

# --- Xfce-Panel ---
xfconf-query -c xfce4-panel -lv > "$D/xfce/panel.txt"
xfconf-query -c xsettings   -lv > "$D/xfce/xsettings.txt"

cd "$D" && git add -A
git commit -m "backup $(date +%F' '%H:%M)" || echo "nichts geaendert"
git push
