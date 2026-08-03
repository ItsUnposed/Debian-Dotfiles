# Notes

Kleinkram, der nirgends sonst hinpasst. Alles Wichtige steht im README.

## Eigenes Tastaturlayout

`system/deumlaut` nach `/usr/share/X11/xkb/symbols/` kopieren, dann:

```bash
setxkbmap -layout deumlaut -option lv3:ralt_switch
```

Das Layout ist bewusst **nicht** in `xkb/rules` registriert. Das reine
Kopieren nach `symbols/` genuegt, `setxkbmap` findet es dort.

## Schriften

Fira Code liegt unter `/usr/share/fonts/truetype/firacode/` und wird von
i3, qterminal, dem Greeter und den xterm-Fenstern des Hackerstartups
verwendet. In i3 heisst sie `pango:Fira Code 10`.

## xfconf-Werte des Panels

Die vollstaendige Panel-Konfiguration liegt als XML unter `xfce/`. Einzelne
Werte lassen sich zur Laufzeit pruefen und setzen:

```bash
xfconf-query -c xsettings -l -v
xfconf-query -c xfce4-keyboard-shortcuts -l
```

Der zweite Befehl ist wichtig, wenn ein i3-Tastenkuerzel nicht reagiert:
Xfce-Zuweisungen greifen die Taste ab, bevor i3 sie sieht.
