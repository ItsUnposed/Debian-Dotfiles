#!/usr/bin/env python3
import fcntl, os, signal, sys, time

# --- nur eine Instanz: alte beenden, dann Sperre uebernehmen ---
_lf = open('/tmp/autotile-i3.lock', 'a+')
try:
    fcntl.flock(_lf, fcntl.LOCK_EX | fcntl.LOCK_NB)
except OSError:
    _lf.seek(0)
    _alt = _lf.read().strip()
    if _alt.isdigit():
        try:
            os.kill(int(_alt), signal.SIGTERM)
        except OSError:
            pass
    for _ in range(20):
        try:
            fcntl.flock(_lf, fcntl.LOCK_EX | fcntl.LOCK_NB)
            break
        except OSError:
            time.sleep(0.1)
    else:
        sys.exit(0)
_lf.seek(0); _lf.truncate(); _lf.write(str(os.getpid())); _lf.flush()

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
