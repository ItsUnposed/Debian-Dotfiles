#!/bin/bash
# Stellt das Ember-Ricing auf einem frischen Debian 13 her.
# Aufruf: git clone git@github.com:ItsUnposed/dotfiles.git ~/dotfiles && ~/dotfiles/install.sh
set -e
D="$HOME/dotfiles"
echo ">>> 1/7 Pakete"
sudo apt update
sudo apt install -y i3 picom rofi feh xfce4-panel xfce4-genmon-plugin xfce4-whiskermenu-plugin \
    xfsettingsd thunar qterminal cava fastfetch btop nano git jq xdotool x11-utils wmctrl rsync unzip \
    lightdm lightdm-gtk-greeter imagemagick flameshot papirus-icon-theme fonts-firacode xterm
[ -f "$D/packages/apt.txt" ] && \
    sudo apt install -y $(grep -vE '^(linux-image|linux-headers)' "$D/packages/apt.txt" | tr '\n' ' ') || true

echo ">>> 2/7 Nerd Font"
if ! fc-list | grep -qi nerd; then
    mkdir -p ~/.local/share/fonts && cd /tmp
    wget -q https://github.com/ryanoasis/nerd-fonts/releases/latest/download/FiraCode.zip
    unzip -oq FiraCode.zip -d ~/.local/share/fonts/FiraCodeNF && fc-cache -f
fi

echo ">>> 3/7 ~/.config"
mkdir -p "$HOME/.config"
rsync -a "$D/config/" "$HOME/.config/"
chmod +x "$HOME"/.config/i3/*.sh "$HOME"/.config/i3/scripts/*.sh "$HOME"/.config/ember/*.sh 2>/dev/null || true

echo ">>> 4/7 Home"
rsync -a "$D/home/." "$HOME/"

echo ">>> 5/7 System"
sudo mkdir -p /usr/share/themes /etc/lightdm /usr/share/X11/xkb/symbols
[ -f "$D/system/lightdm/lightdm-gtk-greeter.conf" ] && sudo cp "$D/system/lightdm/lightdm-gtk-greeter.conf" /etc/lightdm/
[ -d "$D/system/themes/Ember-Greeter" ] && sudo cp -r "$D/system/themes/Ember-Greeter" /usr/share/themes/
[ -f "$D/system/sudoers.d/ember-theme" ] && { sudo cp "$D/system/sudoers.d/ember-theme" /etc/sudoers.d/; sudo chmod 440 /etc/sudoers.d/ember-theme; }
[ -f "$D/system/deumlaut" ] && sudo cp "$D/system/deumlaut" /usr/share/X11/xkb/symbols/
[ -f "$D/system/grub" ] && { sudo cp "$D/system/grub" /etc/default/grub; sudo update-grub; }
[ -d "$D/system/grub-silver" ] && sudo cp -r "$D/system/grub-silver" /boot/grub/themes/silver

echo ">>> 6/7 Xfce-Panel"
xfce4-panel --quit 2>/dev/null || true
sleep 1
while read -r prop val; do
    case "$prop" in /*) ;; *) continue ;; esac
    [ -z "$val" ] && continue
    xfconf-query -c xfce4-panel -p "$prop" -n -t string -s "$val" 2>/dev/null || \
    xfconf-query -c xfce4-panel -p "$prop" -s "$val" 2>/dev/null || true
done < "$D/xfce/panel.txt"

echo ">>> 7/7 Flatpaks"
if [ -f "$D/packages/flatpak.txt" ]; then
    sudo apt install -y flatpak
    flatpak remote-add --if-not-exists flathub https://flathub.org/repo/flathub.flatpakrepo
    xargs -r -a "$D/packages/flatpak.txt" flatpak install -y flathub || true
fi

"$HOME/.config/ember/apply.sh" red
echo
echo "FERTIG. Jetzt einmal abmelden und neu anmelden."
