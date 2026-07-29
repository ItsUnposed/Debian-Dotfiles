font pango:DejaVu Sans Mono 10
/usr/share/fonts/truetype/firacode/FiraCode-Bold.ttf: Fira Code:style=Bold
/usr/share/fonts/truetype/firacode/FiraCode-SemiBold.ttf: Fira Code,Fira Code SemiBold:style=SemiBold,Regular
/usr/share/fonts/truetype/firacode/FiraCode-Retina.ttf: Fira Code,Fira Code Retina:style=Retina,Regular
/usr/share/fonts/truetype/firacode/FiraCode-Medium.ttf: Fira Code,Fira Code Medium:style=Medium,Regular
/usr/share/fonts/truetype/firacode/FiraCode-Regular.ttf: Fira Code:style=Regular
/usr/share/fonts/truetype/firacode/FiraCode-Light.ttf: Fira Code,Fira Code Light:style=Light,Regular

## Benötigte Pakete auf Ubuntu
sudo apt install i3 picom feh xcape rofi nm-applet \
  xfce4-panel fonts-dejavu playerctl cava fastfetch \
  x11-xkb-utils

## Custom Keyboard Layout
system/deumlaut nach /usr/share/X11/xkb/symbols/ kopieren
danach: setxkbmap -layout deumlaut -option lv3:ralt_switch

## Wallpaper
wallpaper/Kali-Background.jpeg nach ~/Pictures/
Layout ist NICHT in xkb/rules registriert - reines Kopieren nach symbols/ reicht
