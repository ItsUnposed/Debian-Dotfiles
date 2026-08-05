#!/bin/bash
# Vollbackup der Konfiguration vor groesseren Aenderungen
D="$HOME/backups/$(date +%Y-%m-%d_%H-%M)"
mkdir -p "$D/config" "$D/home" "$D/system" "$D/local-bin"

echo ">> Backup nach $D"

# ~/.config (Symlinks als echte Dateien mitnehmen)
for N in i3 chroma picom.conf rofi cava fastfetch btop flameshot \
         gtk-3.0 qterminal.org qt6ct xfce4; do
    [ -e "$HOME/.config/$N" ] && cp -aL "$HOME/.config/$N" "$D/config/" 2>/dev/null \
        && echo "   config/$N"
done

# Home-Dateien
for F in .bashrc .dircolors .face .gitconfig .xsessionrc .profile \
         .Xresources .nanorc; do
    [ -e "$HOME/$F" ] && cp -a "$HOME/$F" "$D/home/" && echo "   $F"
done
[ -d "$HOME/.nano" ] && cp -a "$HOME/.nano" "$D/home/"

# eigene Skripte
[ -d "$HOME/.local/bin" ] && cp -a "$HOME"/.local/bin/. "$D/local-bin/" 2>/dev/null \
    && echo "   ~/.local/bin"

# Systemdateien
sudo cp /etc/default/grub "$D/system/" 2>/dev/null && echo "   /etc/default/grub"
sudo cp /etc/lightdm/lightdm.conf "$D/system/" 2>/dev/null
sudo cp /etc/lightdm/lightdm-gtk-greeter.conf "$D/system/" 2>/dev/null && echo "   lightdm"
sudo cp /etc/grub.d/10_linux "$D/system/" 2>/dev/null && echo "   10_linux"

# Paketstand
dpkg --get-selections > "$D/dpkg-selections.txt"
apt-mark showmanual > "$D/apt-manual.txt"
flatpak list --app --columns=application > "$D/flatpak.txt" 2>/dev/null
echo "   Paketlisten"

sudo chown -R "$USER:$USER" "$D"

# Archiv
tar -czf "$D.tar.gz" -C "$(dirname "$D")" "$(basename "$D")" 2>/dev/null \
    && echo ">> Archiv: $D.tar.gz"

echo ">> Fertig. Wiederherstellen: cp -a $D/config/. ~/.config/"
