# dotfiles — Chroma

Debian 13 (Trixie) · i3wm · xfce4-panel · picom v12 · qterminal

Dunkles Setup mit **14 umschaltbaren Farbpaletten**. Ein Hotkey wechselt
die Akzentfarbe systemweit: i3-Rahmen, Rofi, Terminal, cava, nano, fastfetch,
Panel, GRUB und der Login-Screen ziehen alle mit.

## Screenshots

<!-- Screenshots nach ~/dotfiles/screenshots/ legen und Pfade anpassen -->
![Desktop](screenshots/desktop.png)
![Hackerstartup](screenshots/hackerstartup.png)
![Rofi](screenshots/rofi.png)

## Schnellstart auf einem frischen System

```bash
sudo apt install -y git
git clone https://github.com/ItsUnposed/Debian-Dotfiles.git ~/dotfiles
~/dotfiles/install.sh
```

Der Installer richtet alles ein: i3, LightDM, picom, Panel, Themes und
Farbpalette. Danach neu starten, im Anmeldebildschirm oben rechts die
Sitzung **i3** wählen und anmelden.

Getestet auf einer frischen Debian-13-Netinstall ohne Desktopumgebung.

## Farbsystem

Alle Paletten liegen als einfache Key-Value-Dateien in `config/chroma/palettes/`:

```
aqua   black   blue   brown   darkblue   gray   green
orange   pink   purple   red   silver   white   yellow
```

Jede Palette definiert dieselben Variablen:

| Variable    | Bedeutung                          |
|-------------|------------------------------------|
| `C_ACC`     | Hauptakzent (Rahmen, Highlights)   |
| `C_ACC2`    | Zweitakzent (Keywords, Details)    |
| `C_ACC3`    | Dritter Akzent (Rahmen, dezent)    |
| `C_BG`      | Hintergrund                        |
| `C_BG2`     | Hintergrund zweite Ebene           |
| `C_DIM`     | Gedimmter Text                     |
| `C_FG`      | Vordergrund / Standardtext         |
| `C_TERM`    | Terminal-Basisfarbe                |
| `WALLPAPER` | Zugehöriges Hintergrundbild        |

`config/chroma/apply.sh <name>` schreibt diese Werte über Templates in alle
Zielkonfigurationen und lädt die betroffenen Programme neu. Die aktive Palette
liegt in `current.conf` (nicht im Repo, wird lokal erzeugt).

Umschalten per Menü: <kbd>Super</kbd>+<kbd>-</kbd>

## Tastenkürzel

Modifier ist die **Super-Taste** (Windows).

### Programme

| Kombination                       | Aktion                         |
|-----------------------------------|--------------------------------|
| <kbd>Super</kbd>+<kbd>Return</kbd>| Terminal (qterminal)           |
| <kbd>Super</kbd>+<kbd>e</kbd>     | Dateimanager (Thunar)          |
| <kbd>Super</kbd>+<kbd>d</kbd>     | Rofi (drun)                    |
| <kbd>Super</kbd>+<kbd>Space</kbd> | Rofi-Launcher mit Websuche     |
| <kbd>Super</kbd>+<kbd>m</kbd>     | Whisker-Menü                   |
| <kbd>Super</kbd>+<kbd>n</kbd>     | NetworkManager-Applet          |
| <kbd>Druck</kbd>                  | Screenshot (Flameshot)         |

### Fenster

| Kombination                                   | Aktion                    |
|-----------------------------------------------|---------------------------|
| <kbd>Super</kbd>+<kbd>q</kbd>                 | Fenster schließen         |
| <kbd>Super</kbd>+<kbd>f</kbd>                 | Vollbild                  |
| <kbd>Super</kbd>+<kbd>t</kbd>                 | Semi-Vollbild             |
| <kbd>Super</kbd>+<kbd>Shift</kbd>+<kbd>Space</kbd> | Floating an/aus      |
| <kbd>Super</kbd>+<kbd>Pfeil</kbd>             | Fokus bewegen             |
| <kbd>Super</kbd>+<kbd>Shift</kbd>+<kbd>Pfeil</kbd> | Fenster verschieben  |
| <kbd>Super</kbd>+<kbd>Strg</kbd>+<kbd>Pfeil</kbd> | Größe ändern          |
| <kbd>Super</kbd>+<kbd>h</kbd> / <kbd>v</kbd>  | Horizontal / vertikal teilen |
| <kbd>Super</kbd>+<kbd>s</kbd> / <kbd>w</kbd>  | Stacking / Tabbed         |
| <kbd>Super</kbd>+<kbd>a</kbd>                 | Elternfenster fokussieren |
| <kbd>Super</kbd>+<kbd>Tab</kbd>               | Tiling/Floating wechseln  |

### Workspaces

| Kombination                                 | Aktion                       |
|---------------------------------------------|------------------------------|
| <kbd>Super</kbd>+<kbd>1</kbd>…<kbd>0</kbd>  | Workspace wechseln (animiert)|
| <kbd>Super</kbd>+<kbd>Shift</kbd>+<kbd>1</kbd>…<kbd>0</kbd> | Fenster verschieben |

### Spielereien und System

| Kombination                                    | Aktion                    |
|------------------------------------------------|---------------------------|
| <kbd>Super</kbd>+<kbd>-</kbd>                  | Farbpaletten-Menü         |
| <kbd>Super</kbd>+<kbd>o</kbd>                  | Hackerstartup-Layout      |
| <kbd>Super</kbd>+<kbd>i</kbd>                  | Dev-Layout (IDE-Auswahl)  |
| <kbd>Super</kbd>+<kbd>Shift</kbd>+<kbd>h</kbd> | Hackerstartup-Layout      |
| <kbd>Super</kbd>+<kbd>p</kbd>                  | pipes (Theme-Farbe)       |
| <kbd>Super</kbd>+<kbd>x</kbd>                  | unimatrix (Theme-Farbe)   |
| <kbd>Super</kbd>+<kbd>Shift</kbd>+<kbd>x</kbd> | Bildschirm sperren        |
| <kbd>Super</kbd>+<kbd>Shift</kbd>+<kbd>e</kbd> | Power-Menü                |
| <kbd>Super</kbd>+<kbd>Shift</kbd>+<kbd>c</kbd> | i3 neu laden              |
| <kbd>Super</kbd>+<kbd>Shift</kbd>+<kbd>r</kbd> | i3 neu starten            |
| <kbd>Helligkeit +/-</kbd>                      | brightnessctl             |

## Hackerstartup

<kbd>Super</kbd>+<kbd>o</kbd> baut ein fünfteiliges Layout auf:

```
+----------------+-------------------------------+
|                |          taskmanager          |
|   i3 config    +---------------+---------------+
|   50% Breite   |  fastfetch    |               |
|                +---------------+    matrix     |
|                |  cava         |               |
+----------------+---------------+---------------+
```

Alle Fenster übernehmen die aktive Palettenfarbe und laufen mit
picom-Transparenz.

## Dev-Layout

Super+i oeffnet ein Rofi mit PyCharm, IntelliJ IDEA und CLion. Die gewaehlte
IDE startet links (82% Breite), rechts daneben laufen Matrix oben und pipes
unten.

## Aufbau

| Ordner        | Inhalt                                    |
|---------------|-------------------------------------------|
| `config/`     | wird nach `~/.config/<name>` verlinkt      |
| `home/`       | Dateien direkt in `~`                      |
| `system/`     | `/etc/default/grub`, LightDM               |
| `packages/`   | APT- und Flatpak-Listen                    |
| `xfce/`       | xfconf-XML der Panel-Konfiguration         |
| `themes/`     | GRUB- und Greeter-Themes                   |
| `local-bin/`  | eigene Skripte für `~/.local/bin`          |
| `wallpaper/`  | Hintergrundbilder je Palette               |

`config/i3`, `config/cava`, `config/fastfetch` und `config/rofi` sind
Symlinks — Änderungen unter `~/.config` landen sofort im Repo.
Alle anderen werden von `save.sh` kopiert.

## Sichern

```bash
~/dotfiles/save.sh
```

Kopiert alle Nicht-Symlink-Configs ins Repo, aktualisiert die Paketlisten,
committet und pusht.

## Stolpersteine

Gesammelte Erkenntnisse aus dem Aufbau, damit sie nicht wieder gesucht werden
müssen:

- **picom v12** nutzt `rules = ()`; alte Optionen wie `opacity-rule`,
  `shadow-exclude` oder `wintypes` werden dann komplett ignoriert.
- **WM_CLASS-Matching ist case-sensitiv** — `qterminal`, nicht `QTerminal`.
- **`exec` vs `exec_always`**: Dienste, die beim i3-Neustart wieder hochkommen
  sollen, brauchen `exec_always`; das Hackerstartup dagegen `exec`, sonst
  startet es doppelt.
- **`quiet_boot` steht in Debians `/etc/grub.d/10_linux` fest auf `0`** — die
  „Loading Linux …"-Zeilen verschwinden erst, wenn man es auf `1` patcht.
  Ein `grub-common`-Update setzt das zurück.
- **xterm ignoriert `-xrm` bei umbenannter Instanz**; Farbslots setzt man
  stattdessen zur Laufzeit per OSC-Sequenz (`\033]4;1;#RRGGBB\007`).
- **`pipes` ist ein Bash-Skript** und ignoriert SIGHUP; es muss im Hintergrund
  mit `wait` laufen, damit ein `trap` beim Fensterschließen greift.
- **Xfce-Tastenkürzel laufen parallel zu i3** und fangen Kombinationen ab,
  bevor i3 sie sieht. Aufräumen mit
  `xfconf-query -c xfce4-keyboard-shortcuts -l`.

## Lizenz

MIT — siehe [LICENSE](LICENSE).
