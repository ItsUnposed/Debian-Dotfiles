#!/usr/bin/env bash
# Debian-Dotfiles Installer
# Ziel: frische Debian 13 (Trixie) Netinstall ohne Desktopumgebung.
set -uo pipefail
R="$(cd "$(dirname "$0")" && pwd)"

_C='38;2;255;107;94'
say(){ printf "\033[${_C}m>> %s\033[0m\n" "$*"; }
ok(){  printf "     %s\n" "$*"; }
warn(){ printf "\033[38;2;255;180;0m   ! %s\033[0m\n" "$*"; }

[ "$(id -u)" -eq 0 ] && { echo "Nicht als root ausfuehren."; exit 1; }
command -v sudo >/dev/null || { echo "sudo fehlt. Als root: apt install sudo && adduser $USER sudo"; exit 1; }

sudo -v || exit 1

# ======================================================================
say "1/8  Basis-Pakete"
# ======================================================================
sudo apt update
CORE=(
    xorg xinit x11-utils x11-xserver-utils xdotool
    i3 i3status
    lightdm lightdm-gtk-greeter
    picom rofi
    xterm qterminal
    thunar thunar-archive-plugin gvfs gvfs-backends tumbler
    xfce4-panel xfce4-appfinder xfce4-whiskermenu-plugin xfce4-genmon-plugin
    xfce4-settings xfce4-power-manager xfce4-notifyd
    xfce4-pulseaudio-plugin xfce4-clipman-plugin xfce4-systemload-plugin
    xfce4-taskmanager
    xfce4-pulseaudio-plugin xfce4-clipman-plugin xfce4-systemload-plugin
    xfce4-taskmanager
    network-manager network-manager-gnome
    pulseaudio pavucontrol
    flameshot brightnessctl playerctl feh
    fonts-firacode fonts-noto fonts-noto-color-emoji
    papirus-icon-theme arc-theme adwaita-icon-theme
    btop cava pipes-sh
    plymouth plymouth-themes
    git curl wget jq bc nano
    python3 python3-pip pipx
    qt6ct
)
for p in "${CORE[@]}"; do
    sudo apt install -y "$p" >/dev/null 2>&1 && ok "$p" || warn "fehlgeschlagen: $p"
done
sudo apt install -y fastfetch >/dev/null 2>&1 && ok "fastfetch" \
    || warn "fastfetch nicht im Repo"

# ======================================================================
say "2/8  Weitere Pakete aus der Liste"
# ======================================================================
LIST="$R/packages/apt-manual.txt"
if [ -f "$LIST" ]; then
    # In Bloecken installieren statt einzeln - sonst dauert es ewig.
    # Faellt ein Block, werden dessen Pakete einzeln nachgereicht.
    mapfile -t PKGS < <(grep -v '^\s*#' "$LIST" | awk '{print $1}' \
                        | grep -v '^$' | grep -v '^kali' | grep -v '^gcc-16' | sort -u)
    TOTAL=${#PKGS[@]}; FAIL=0; i=0
    while [ "$i" -lt "$TOTAL" ]; do
        CHUNK=("${PKGS[@]:$i:40}")
        printf "\r     %d/%d" "$i" "$TOTAL"
        if ! sudo apt install -y "${CHUNK[@]}" >/dev/null 2>&1; then
            for q in "${CHUNK[@]}"; do
                sudo apt install -y "$q" >/dev/null 2>&1 || FAIL=$((FAIL+1))
            done
        fi
        i=$((i+40))
    done
    printf "\r%-40s\r" ""
    ok "$((TOTAL-FAIL))/$TOTAL installiert"
    [ "$FAIL" -gt 0 ] && warn "$FAIL nicht verfuegbar (uebersprungen)"
else
    warn "packages/apt-manual.txt fehlt"
fi

# ======================================================================
say "3/8  Flatpak"
# ======================================================================
sudo apt install -y flatpak >/dev/null 2>&1
flatpak remote-add --if-not-exists flathub \
    https://flathub.org/repo/flathub.flatpakrepo >/dev/null 2>&1 && ok "flathub"
if [ -f "$R/packages/flatpak.txt" ]; then
    while read -r p; do
        [ -z "$p" ] && continue
        flatpak install -y flathub "$p" >/dev/null 2>&1 && ok "$p" || warn "flatpak: $p"
    done < "$R/packages/flatpak.txt"
fi

# ======================================================================
say "4/8  Configs verlinken"
# ======================================================================
mkdir -p "$HOME/.config"
for E in "$R"/config/*; do
    N=$(basename "$E"); T="$HOME/.config/$N"
    [ -L "$T" ] && rm "$T"
    [ -e "$T" ] && mv "$T" "$T.vor-install-$(date +%s)"
    ln -s "$E" "$T"; ok "$N"
done

# nano-Syntax fuer die i3-Config
if [ -f "$R/i3.nanorc" ]; then
    mkdir -p "$HOME/.nano"
    cp "$R/i3.nanorc" "$HOME/.nano/"
    grep -q "i3.nanorc" "$HOME/.nanorc" 2>/dev/null \
        || echo 'include "~/.nano/i3.nanorc"' >> "$HOME/.nanorc"
    ok "nano-Syntax"
fi

# ======================================================================
say "5/8  Home, Wallpapers, eigene Skripte"
# ======================================================================
for B in .bashrc .dircolors .face .xsessionrc .profile .Xresources; do
    [ -e "$R/home/$B" ] || continue
    [ -e "$HOME/$B" ] && mv "$HOME/$B" "$HOME/$B.vor-install"
    cp -a "$R/home/$B" "$HOME/$B"; ok "$B"
done

# Wallpapers - werden von den Paletten referenziert
if [ -d "$R/wallpaper" ]; then
    mkdir -p "$HOME/Pictures/Wallpapers"
    cp -a "$R"/wallpaper/. "$HOME/Pictures/Wallpapers/"
    ok "Wallpapers -> ~/Pictures/Wallpapers"
else
    warn "wallpaper/ fehlt im Repo"
fi
mkdir -p "$HOME/Pictures/Screenshots"

mkdir -p "$HOME/.local/bin"
[ -d "$R/local-bin" ] && cp -a "$R"/local-bin/. "$HOME/.local/bin/" 2>/dev/null
chmod +x "$HOME"/.local/bin/* 2>/dev/null && ok "~/.local/bin"

# PATH sicherstellen
grep -q '.local/bin' "$HOME/.bashrc" 2>/dev/null \
    || echo 'export PATH="$HOME/.local/bin:$PATH"' >> "$HOME/.bashrc"

# unimatrix
if [ ! -x "$HOME/.local/bin/unimatrix" ]; then
    pipx install unimatrix >/dev/null 2>&1 && ok "unimatrix" \
        || { pip3 install --break-system-packages --user unimatrix >/dev/null 2>&1 \
             && ok "unimatrix (pip)" || warn "unimatrix fehlgeschlagen"; }
fi
pipx ensurepath >/dev/null 2>&1

# langsame pipes-Variante
if [ -f /usr/games/pipes ]; then
    cp /usr/games/pipes "$HOME/.local/bin/pipes-slow"
    sed -i '2i trap "exit 0" HUP TERM INT' "$HOME/.local/bin/pipes-slow"
    sed -i 's|read -t 0.0\$((1000 / f)) -n 1 2>/dev/null|read -t ${PIPES_DELAY:-0.12} -n 1 2>/dev/null|' \
        "$HOME/.local/bin/pipes-slow"
    chmod +x "$HOME/.local/bin/pipes-slow"
    ok "pipes-slow"
else
    warn "/usr/games/pipes fehlt"
fi

chmod +x "$HOME"/.config/i3/scripts/*.sh "$HOME"/.config/chroma/*.sh 2>/dev/null

# ======================================================================
say "6/8  xfce4-panel"
# ======================================================================
# xfconfd muss weg, sonst ueberschreibt es die kopierten XML-Dateien
pkill -x xfce4-panel 2>/dev/null
pkill -x xfconfd 2>/dev/null
sleep 1
XD="$HOME/.config/xfce4/xfconf/xfce-perchannel-xml"
mkdir -p "$XD"
if [ -d "$R/xfce/xfce-perchannel-xml" ]; then
    cp -a "$R/xfce/xfce-perchannel-xml/." "$XD/" && ok "Panel-Konfiguration"
else
    warn "xfce/xfce-perchannel-xml fehlt"
fi
[ -d "$R/qt6ct" ] && mkdir -p "$HOME/.config/qt6ct" \
    && cp -a "$R"/qt6ct/. "$HOME/.config/qt6ct/" && ok "qt6ct"

# ======================================================================
say "7/8  System (GRUB, LightDM, Plymouth)"
# ======================================================================
if [ -d "$R/themes" ]; then
    sudo mkdir -p /usr/share/grub/themes /usr/share/themes
    [ -d "$R/themes/grub" ]   && sudo cp -r "$R/themes/grub"/*   /usr/share/grub/themes/ 2>/dev/null && ok "GRUB-Theme"
    [ -d "$R/themes/greeter" ] && sudo cp -r "$R/themes/greeter"/* /usr/share/themes/ 2>/dev/null && ok "Greeter-Theme"
fi

G=""
[ -f "$R/system/grub" ]        && G="$R/system/grub"
[ -f "$R/grub-default" ]       && G="$R/grub-default"
if [ -n "$G" ]; then
    sudo cp "$G" /etc/default/grub
    sudo sed -i 's/^quiet_boot="0"$/quiet_boot="1"/' /etc/grub.d/10_linux 2>/dev/null
    sudo update-grub >/dev/null 2>&1 && ok "GRUB"
fi

for L in lightdm.conf lightdm-gtk-greeter.conf; do
    [ -f "$R/system/$L" ] && sudo cp "$R/system/$L" /etc/lightdm/ && ok "$L"
done

if [ -f "$HOME/.face" ]; then
    sudo mkdir -p /var/lib/AccountsService/icons /var/lib/AccountsService/users
    sudo cp "$HOME/.face" /var/lib/AccountsService/icons/"$USER"
    sudo chmod 644 /var/lib/AccountsService/icons/"$USER"
    printf '[User]\nSession=\nXSession=i3\nIcon=/var/lib/AccountsService/icons/%s\nSystemAccount=false\n' \
        "$USER" | sudo tee /var/lib/AccountsService/users/"$USER" >/dev/null
    ok "Profilbild"
fi

PS=$(command -v plymouth-set-default-theme || echo /usr/sbin/plymouth-set-default-theme)
[ -x "$PS" ] && sudo "$PS" -R spinner >/dev/null 2>&1 && ok "Plymouth"

sudo systemctl enable lightdm >/dev/null 2>&1
sudo systemctl set-default graphical.target >/dev/null 2>&1
ok "LightDM aktiviert"

# ======================================================================
say "8/8  Farbpalette anwenden"
# ======================================================================
A="$HOME/.config/chroma/apply.sh"
if [ -x "$A" ]; then
    "$A" black >/dev/null 2>&1 && ok "Palette: black" \
        || warn "apply.sh fehlgeschlagen - manuell: $A black"
else
    warn "chroma/apply.sh nicht gefunden"
fi

echo
say "Fertig."
echo "   1. sudo reboot"
echo "   2. Im Anmeldebildschirm oben rechts die Sitzung 'i3' waehlen"
echo "   3. Anmelden. Farbe wechseln mit Super + Minus."
echo
echo "   Falls das Panel leer ist: xfce4-panel -r"
