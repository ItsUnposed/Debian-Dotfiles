#!/usr/bin/env bash
set -uo pipefail
R="$HOME/dotfiles"
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

say "1/5  ~/.config"
for E in "$R"/config/*; do
    N=$(basename "$E"); T="$HOME/.config/$N"
    if [ -L "$T" ]; then echo "     symlink, skipped: $N"; continue; fi
    if [ ! -e "$T" ];  then echo "     missing im System:     $N"; continue; fi
    if [ -d "$T" ]; then rsync -a --delete "$T/" "$E/"; else cp -a "$T" "$E"; fi
    echo "     saved: $N"
done

say "2/5  Home"
mkdir -p "$R/home"
for F in .bashrc .bash_aliases .dircolors .face .xsessionrc .profile .Xresources; do
    [ -e "$HOME/$F" ] && cp -a "$HOME/$F" "$R/home/$F" && echo "     $F"
done

# --- Wallpapers ---
# Wallpapers-Repo holds the generated set that gets published.
# Wallpapers itself may contain private images and stays local.
WPSRC="$HOME/Pictures/Wallpapers-Repo"
[ -d "$WPSRC" ] || WPSRC="$HOME/Pictures/Wallpapers"
mkdir -p "$R/wallpaper"
rsync -a --delete "$WPSRC/" "$R/wallpaper/" 2>/dev/null || cp -a "$WPSRC"/. "$R/wallpaper/"
echo "     Wallpapers"

say "3/5  /etc"
mkdir -p "$R/system"
for S in /etc/default/grub /etc/lightdm/lightdm.conf /etc/lightdm/lightdm-gtk-greeter.conf; do
    [ -f "$S" ] && sudo cp "$S" "$R/system/$(basename $S)" && echo "     $S"
done
sudo chown -R "$USER:$USER" "$R/system"

say "4/5  Packages"
mkdir -p "$R/packages"
apt-mark showmanual > "$R/packages/apt-manual.txt"
dpkg --get-selections | awk '$2=="install"{print $1}' > "$R/packages/apt-alle.txt"
flatpak list --app --columns=application > "$R/packages/flatpak.txt" 2>/dev/null

say "5/5  xfce4-panel"
mkdir -p "$R/xfce/xfce-perchannel-xml"
cp -a "$HOME/.config/xfce4/xfconf/xfce-perchannel-xml/." "$R/xfce/xfce-perchannel-xml/" 2>/dev/null

cd "$R"
git add -A
printf "\033[${_C}m>> commit message (empty = timestamp): \033[0m"
read -r COMMIT_MSG
[ -z "$COMMIT_MSG" ] && COMMIT_MSG="backup $(date '+%F %H:%M')"
git commit -m "$COMMIT_MSG" && git push && say "pushed" || say "nothing to commit"
