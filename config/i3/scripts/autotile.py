#!/usr/bin/env python3
# Waehlt die Teilungsrichtung nach den Fensterproportionen -> Fibonacci-Layout
import i3ipc

i3 = i3ipc.Connection()

def switch(conn, event):
    try:
        w = conn.get_tree().find_focused()
    except Exception:
        return
    if w is None or w.type != "con":
        return
    if w.floating in ("user_on", "auto_on"):
        return
    if w.parent is not None and w.parent.layout in ("stacked", "tabbed"):
        return
    if w.fullscreen_mode:
        return
    conn.command("split " + ("h" if w.rect.width > w.rect.height else "v"))

i3.on("window::focus", switch)
i3.on("window::move", switch)
i3.main()
