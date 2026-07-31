# dotfiles — Ember

Konfiguration eines Debian 13 (Trixie) Desktops mit i3, xfce4-panel und
einem umschaltbaren Farbsystem namens Ember.

Getestet auf: ThinkPad X13 Gen 4, AMD Ryzen 7 PRO 7840U, 1920x1200.

## Schnellstart

    sudo apt install -y git
    git clone git@github.com:ItsUnposed/dotfiles.git ~/dotfiles
    ~/dotfiles/install.sh

Danach abmelden und neu anmelden. Dauer etwa 5 Minuten.

## Aufbau

| Ordner | Ziel | Inhalt |
|---|---|---|
| config/ | ~/.config/ | i3, picom, rofi, cava, fastfetch, btop, qterminal, ember |
| home/ | ~/ | .bashrc, .profile, .nanorc, .xsessionrc |
| system/ | /etc, /usr/share | lightdm-Greeter, Grub-Theme, sudoers, XKB |
| packages/ | — | apt- und Flatpak-Listen |
| xfce/ | xfconf | Panel-Aufbau als XML |

## Farbsystem

Zentrale Ablage: ~/.config/ember/

    apply.sh          setzt eine Palette systemweit
    menu.sh           rofi-Auswahl mit Farbvorschau
    palettes/*.conf   14 Farben
    templates/        Vorlagen mit Platzhaltern
    current.conf      Laufzeitzustand, nicht im Repo

Variablen je Palette: C_ACC, C_ACC2, C_ACC3, C_BG, C_BG2, C_DIM, C_FG,
C_TERM, WALLPAPER. C_BG bleibt immer nahe Schwarz, dadurch ist der Dark
Mode bei jeder Farbe erhalten.

Skripte, die laufend aufgerufen werden (workspaces.sh, win-*.sh), lesen
current.conf zur Laufzeit. Statische Configs werden aus templates/ neu
geschrieben. Direkte Aenderungen an rofi, gtk.css oder notify.css gehen
deshalb beim naechsten Farbwechsel verloren.

Anwenden: ~/.config/ember/apply.sh aqua   oder   Strg + Minus

## Tastenbelegung

$mod = Super, Mod1 = Alt.

| Taste | Wirkung |
|---|---|
| $mod + Return | qterminal |
| $mod + d | rofi |
| $mod + e | Thunar |
| $mod + 1..0 | Workspace wechseln, mit Swipe-Animation |
| $mod + Minus | Fenster nach __min minimieren |
| $mod + Shift + Minus | zurueckholen |
| Alt + q | Fenster schliessen, swiped nach unten |
| Alt + Minus | Semi-Vollbild und zentriert umschalten |
| Strg + Minus | Farb-Menue |

## Animationen

Braucht picom 12 oder neuer wegen der rules-Syntax.

| Effekt | Ausloeser | Mechanik |
|---|---|---|
| Workspace-Swipe | ws-go.sh | setzt _MY_CUSTOM_WORKSPACE_SWITCH, 1 aufwaerts, 2 abwaerts |
| Schliessen nach unten | close-window.sh | setzt _MY_CUSTOM_CLOSE = 1 |

Die Close-Regel muss vor den Workspace-Regeln stehen, weil picom die
erste passende Regel nimmt.

Sobald ein rules-Block existiert, ignoriert picom alle alten
Ausschlusslisten wie shadow-exclude oder rounded-corners-exclude. Alles
muss in rules stehen.

## Bekannte Fallstricke

- qterminal.ini steht auf chmod 444, sonst ueberschreibt qterminal sie
  beim Beenden. Vor dem Bearbeiten 644, danach zurueck auf 444.
- Das Hackerstartup darf nicht mit exec_always laufen, sonst startet es
  bei jedem i3-Reload doppelt. apply.sh nutzt aus demselben Grund
  i3-msg reload statt restart.
- JetBrains-IDEs brauchen _JAVA_AWT_WM_NONREPARENTING=1 in .xsessionrc,
  sonst bleiben Menues leer.
- Die Workspace-Pille braucht einen Nerd Font, Zeichen U+E0B4 und U+E0B6.
- apt purge bricht komplett ab, wenn ein einziger Platzhalter kein Paket
  findet.

## Sichern

    ~/dotfiles/save.sh
