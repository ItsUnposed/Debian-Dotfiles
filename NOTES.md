# Notes

Small things that do not fit anywhere else. Everything important is in the
README.

## Custom keyboard layout

Copy `system/deumlaut` to `/usr/share/X11/xkb/symbols/`, then:

```bash
setxkbmap -layout deumlaut -option lv3:ralt_switch
```

The layout is deliberately **not** registered in `xkb/rules`. Copying it into
`symbols/` is enough, `setxkbmap` finds it there.

## Fonts

Fira Code lives in `/usr/share/fonts/truetype/firacode/` and is used by i3,
qterminal, the greeter and the xterm windows of the hacker startup. In i3 it
is written as `pango:Fira Code 10`.

## Panel xfconf values

The full panel configuration is stored as XML under `xfce/`. Individual values
can be inspected and set at runtime:

```bash
xfconf-query -c xsettings -l -v
xfconf-query -c xfce4-keyboard-shortcuts -l
```

The second command matters when an i3 shortcut does not react: Xfce bindings
grab the key before i3 ever sees it.
