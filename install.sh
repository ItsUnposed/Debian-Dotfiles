#!/usr/bin/env bash
# Debian-Dotfiles Installer
# Getestet auf einer frischen Debian 13 (Trixie) Installation.
set -uo pipefail
R="$(cd "$(dirname "$0")" && pwd)"

_h2a(){ printf '38;2;%d;%d;%d' 0x${1:1:2} 0x${1:3:2} 0x${1:5:2}; }
if [ -f "$HOME/.config/chroma/current.conf" ]; then
    . "$HOME/.config/chroma/current.conf"
    _C=$(_h2a "${C_ACC:-#FF6B5E}")
else
    _C='38;2;255;107;94'
fi
say(){ printf "\033[${_C}m>> %s\033[0m\n" "$*"; }
warn(){ printf "\033[38;2;255;180;0m   ! %s\033[0m\n" "$*"; }

[ "$(id -u)" -eq 0 ] && { echo "Nicht als root ausfuehren."; exit 1; }
command -v sudo >/dev/null || { echo "sudo fehlt: apt install sudo"; exit 1; }

# ----------------------------------------------------------------------
say "1/7  Basis-Pakete (Desktop-Grundgeruest)"
# ----------------------------------------------------------------------
sudo apt update
CORE=(
    xorg xinit
    i3 i3status
    lightdm lightdm-gtk-greeter
    picom rofi
    xterm qterminal
    thunar
    xfce4-panel xfce4-appfinder xfce4-whiskermenu-plugin xfce4-genmon-plugin
    xfce4-settings xfce4-power-manager
    network-manager network-manager-gnome
    flameshot brightnessctl playerctl
    fonts-firacode fonts-noto-color-emoji
    papirus-icon-theme arc-theme
    btop cava pipes-sh
    plymouth plymouth-themes
    git curl wget jq xdotool x11-utils
    python3 python3-pip pipx
    nano bc
)
for p in "${CORE[@]}"; do
    sudo apt install -y "$p" >/dev/null 2>&1 && echo "     $p" || warn "fehlgeschlagen: $p"
done

# fastfetch ist nicht in allen Repos
sudo apt install -y fastfetch >/dev/null 2>&1 || warn "fastfetch nicht im Repo - manuell nachinstallieren"

# ----------------------------------------------------------------------
say "2/7  Weitere Pakete aus der Liste"
# ----------------------------------------------------------------------
LIST="$R/packages/apt-manual.txt"
if [ -f "$LIST" ]; then
    FAIL=0
    while read -r p; do
        [ -z "$p" ] && continue
        case "$p" in kali*|gcc-16*) continue ;; esac
        sudo apt install -y "$p" >/dev/null 2>&1 || { FAIL=$((FAIL+1)); }
    done < "$LIST"
    [ "$FAIL" -gt 0 ] && warn "$FAIL Pakete aus der Liste nicht verfuegbar (uebersprungen)"
else
    warn "packages/apt-manual.txt fehlt"
fi

# ----------------------------------------------------------------------
say "3/7  Flatpak"
# ----------------------------------------------------------------------
sudo apt install -y flatpak >/dev/null 2>&1
flatpak remote-add --if-not-exists flathub \
    https://flathub.org/repo/flathub.flatpakrepo >/dev/null 2>&1
if [ -f "$R/packages/flatpak.txt" ]; then
    while read -r p; do
        [ -z "$p" ] && continue
        flatpak install -y flathub "$p" >/dev/null 2>&1 || warn "flatpak: $p"
    done < "$R/packages/flatpak.txt"
fi

# ----------------------------------------------------------------------
say "4/7  Configs verlinken"
# ----------------------------------------------------------------------
mkdir -p "$HOME/.config"
for E in "$R"/config/*; do
    N=$(basename "$E"); T="$HOME/.config/$N"
    [ -L "$T" ] && rm "$T"
    [ -e "$T" ] && mv "$T" "$T.vor-install-$(date +%s)"
    ln -s "$E" "$T"; echo "     $N"
done

# ----------------------------------------------------------------------
say "5/7  Home-Dateien und eigene Skripte"
# ----------------------------------------------------------------------
for B in .bashrc .dircolors .face .xsessionrc .profile .Xresources; do
    [ -e "$R/home/$B" ] || continue
    [ -e "$HOME/$B" ] && mv "$HOME/$B" "$HOME/$B.vor-install"
    cp -a "$R/home/$B" "$HOME/$B"; echo "     $B"
done

mkdir -p "$HOME/.local/bin"
if [ -d "$R/local-bin" ]; then
    cp -a "$R"/local-bin/. "$HOME/.local/bin/" 2>/dev/null
    chmod +x "$HOME"/.local/bin/* 2>/dev/null
    echo "     ~/.local/bin"
fi

# unimatrix wird per pipx installiert, falls nicht vorhanden
if [ ! -x "$HOME/.local/bin/unimatrix" ]; then
    pipx install unimatrix >/dev/null 2>&1 && echo "     unimatrix" \
        || warn "unimatrix nicht installiert (pipx install unimatrix)"
fi

# langsame pipes-Variante
if [ -f /usr/games/pipes ] && [ ! -f "$HOME/.local/bin/pipes-slow" ]; then
    cp /usr/games/pipes "$HOME/.local/bin/pipes-slow"
    sed -i '2i trap "exit 0" HUP TERM INT' "$HOME/.local/bin/pipes-slow"
    sed -i 's|read -t 0.0\$((1000 / f)) -n 1 2>/dev/null|read -t ${PIPES_DELAY:-0.12} -n 1 2>/dev/null|' \
        "$HOME/.local/bin/pipes-slow"
    chmod +x "$HOME/.local/bin/pipes-slow"
    echo "     pipes-slow"
fi

chmod +x "$HOME"/.config/i3/scripts/*.sh "$HOME"/.config/chroma/*.sh 2>/dev/null

# ----------------------------------------------------------------------
say "6/7  System (GRUB, LightDM, Plymouth, Panel)"
# ----------------------------------------------------------------------
if [ -f "$R/system/grub" ]; then
    sudo cp "$R/system/grub" /etc/default/grub
    # Debian gibt beim Booten immer "Loading Linux ..." aus
    sudo sed -i 's/^quiet_boot="0"$/quiet_boot="1"/' /etc/grub.d/10_linux 2>/dev/null
    sudo update-grub >/dev/null 2>&1 && echo "     GRUB"
fi

[ -d "$R/themes/grub" ] && sudo cp -r "$R/themes/grub"/* /usr/share/grub/themes/ 2>/dev/null

for L in lightdm.conf lightdm-gtk-greeter.conf; do
    [ -f "$R/system/$L" ] && sudo cp "$R/system/$L" /etc/lightdm/ && echo "     $L"
done

if [ -f "$HOME/.face" ]; then
    sudo mkdir -p /var/lib/AccountsService/icons
    sudo cp "$HOME/.face" /var/lib/AccountsService/icons/"$USER"
    sudo chmod 644 /var/lib/AccountsService/icons/"$USER"
    echo "     Profilbild"
fi

sudo plymouth-set-default-theme -R spinner >/dev/null 2>&1 \
    || sudo /usr/sbin/plymouth-set-default-theme -R spinner >/dev/null 2>&1 \
    && echo "     Plymouth"

mkdir -p "$HOME/.config/xfce4/xfconf/xfce-perchannel-xml"
cp -a "$R/xfce/xfce-perchannel-xml/." \
    "$HOME/.config/xfce4/xfconf/xfce-perchannel-xml/" 2>/dev/null && echo "     xfce4-panel"

sudo systemctl enable lightdm >/dev/null 2>&1
sudo systemctl set-default graphical.target >/dev/null 2>&1

# ----------------------------------------------------------------------
say "7/7  Farbpalette anwenden"
# ----------------------------------------------------------------------
if [ -x "$HOME/.config/chroma/apply.sh" ]; then
    "$HOME/.config/chroma/apply.sh" black >/dev/null 2>&1 && echo "     Palette: black" \
        || warn "apply.sh fehlgeschlagen - manuell: ~/.config/chroma/apply.sh black"
else
    warn "chroma/apply.sh nicht gefunden"
fi

echo
say "Fertig."
echo "   Neu starten, im LightDM oben rechts die Sitzung 'i3' waehlen,"
echo "   dann anmelden, Farbe wechseln danach mit Super + Minus."
