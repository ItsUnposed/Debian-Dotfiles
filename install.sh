#!/usr/bin/env bash
set -uo pipefail
R="$(cd "$(dirname "$0")" && pwd)"
# --- Farbe aus der aktiven Chroma-Palette ---
_h2a(){ printf '38;2;%d;%d;%d' 0x${1:1:2} 0x${1:3:2} 0x${1:5:2}; }
if [ -f "$HOME/.config/chroma/current.conf" ]; then
    . "$HOME/.config/chroma/current.conf"
    _C=$(_h2a "${C_ACC:-#FF6B5E}")
else
    _C='38;2;255;107;94'
fi
say(){ printf "[${_C}m>> %s[0m
" "$*"; }

say "1/6  APT-Pakete"
sudo apt update
grep -v "^kali\|^gcc-16" "$R/packages/apt-manual.txt" | xargs -r sudo apt install -y

say "2/6  Flatpak"
sudo apt install -y flatpak
flatpak remote-add --if-not-exists flathub https://flathub.org/repo/flathub.flatpakrepo
[ -f "$R/packages/flatpak.txt" ] && xargs -r -a "$R/packages/flatpak.txt" flatpak install -y flathub

say "3/6  Configs verlinken"
mkdir -p "$HOME/.config"
for E in "$R"/config/*; do
    N=$(basename "$E"); T="$HOME/.config/$N"
    [ -L "$T" ] && rm "$T"
    [ -e "$T" ] && mv "$T" "$T.vor-install-$(date +%s)"
    ln -s "$E" "$T"; echo "     $N"
done

say "4/6  Home"
for B in .bashrc .dircolors .face .gitconfig .xsessionrc .profile .Xresources; do
    [ -e "$R/home/$B" ] || continue
    [ -e "$HOME/$B" ] && mv "$HOME/$B" "$HOME/$B.vor-install"
    cp -a "$R/home/$B" "$HOME/$B"; echo "     $B"
done

say "5/6  System"
[ -f "$R/system/grub" ] && sudo cp "$R/system/grub" /etc/default/grub && sudo update-grub
for L in lightdm.conf lightdm-gtk-greeter.conf; do
    [ -f "$R/system/$L" ] && sudo cp "$R/system/$L" /etc/lightdm/
done
[ -f "$HOME/.face" ] && sudo mkdir -p /var/lib/AccountsService/icons \
    && sudo cp "$HOME/.face" /var/lib/AccountsService/icons/"$USER"

say "6/6  xfce4-panel"
mkdir -p "$HOME/.config/xfce4/xfconf/xfce-perchannel-xml"
cp -a "$R/xfce/xfce-perchannel-xml/." "$HOME/.config/xfce4/xfconf/xfce-perchannel-xml/" 2>/dev/null
chmod +x "$HOME"/.config/i3/scripts/*.sh "$HOME"/.config/chroma/*.sh 2>/dev/null

say "Fertig. Jetzt abmelden und in i3 neu anmelden."
