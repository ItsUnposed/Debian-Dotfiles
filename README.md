# dotfiles — Chroma

Debian 13 (Trixie) · i3wm · xfce4-panel · picom v12 · qterminal

Dunkles Farbschema mit umschaltbarer Palette. Alle Programme
teilen sich dieselben Farben, gesteuert über ein zentrales Skript.

## Schnellstart auf einem frischen System

```bash
sudo apt install -y git
git clone git@github.com:ItsUnposed/dotfiles.git ~/dotfiles
~/dotfiles/install.sh
```

Danach abmelden und die Sitzung **i3** wählen.

## Aufbau

| Ordner      | Inhalt                                        |
|-------------|-----------------------------------------------|
| `config/`   | wird nach `~/.config/<name>` verlinkt         |
| `home/`     | Dateien direkt in `~`                         |
| `system/`   | `/etc/default/grub`, LightDM                  |
| `packages/` | APT- und Flatpak-Listen                       |
| `xfce/`     | xfconf-XML der Panel-Konfiguration            |

`config/i3`, `config/cava`, `config/fastfetch` und `config/rofi` sind
Symlinks — Änderungen unter `~/.config` landen sofort im Repo.
Alle anderen werden von `save.sh` kopiert.

## Skripte

| Befehl        | Wirkung                                      |
|---------------|----------------------------------------------|
| `./save.sh`   | sichert alles und pusht                      |
| `./install.sh`| stellt ein leeres System wieder her          |

## Tastenbelegung

| Taste             | Wirkung                        |
|-------------------|--------------------------------|
| `Alt+Return`      | Terminal                       |
| `Alt+d`           | rofi                           |
| `Alt+q`           | Fenster schliessen, Swipe unten|
| `Alt+1..0`        | Workspace, Swipe seitlich      |
| `Alt+-`           | Semi-Vollbild umschalten       |
| `Alt+m`           | Fenster minimieren             |
| `Alt+Shift+h`     | Hackerstartup                  |

Neue Fenster kacheln automatisch nach den Proportionen des
fokussierten Fensters (Fibonacci). Zustaendig ist der Dienst
`config/i3/scripts/autotile.py`, gestartet per `exec_always`.
| `Alt+Shift+e`     | Power-Menue                    |
| `Strg+-`          | Farbpalette wechseln           |

## Farbpaletten

```bash
~/.config/chroma/apply.sh red      # oder green, silver, ...
```

`apply.sh` schreibt die Farben in i3, cava, rofi, qterminal, nano,
fastfetch und die Panel-Skripte. Direkte Aenderungen an diesen
Dateien werden beim naechsten Wechsel ueberschrieben — Anpassungen
gehoeren in `apply.sh`.

## Bekannte Fallstricke

- `~/.config/qterminal.org/qterminal.ini` steht auf `chmod 444`,
  sonst ueberschreibt qterminal Aenderungen beim Beenden.
- picom v12 mischt `opacity-rule` und `rules` nicht. Alles gehoert
  in `rules`, Deckkraft dort als Bruchteil (`0.55`), nicht als Prozent.
- i3 vor jedem Reload pruefen: `i3 -C -c ~/.config/i3/config`
