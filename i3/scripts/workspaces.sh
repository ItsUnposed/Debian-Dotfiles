#!/bin/bash
i3-msg -t get_workspaces | python3 -c "
import sys, json
ws = json.load(sys.stdin)
out = []
for w in ws:
    n = w['name']
    if w['focused']:
        out.append(f\"<span foreground='#E0483D' weight='bold'>[{n}]</span>\")
    elif w['urgent']:
        out.append(f\"<span foreground='#FFC96B'>{n}</span>\")
    else:
        out.append(f\"<span foreground='#8A7A72'>{n}</span>\")
print('<txt>' + ' '.join(out) + '</txt>')
"
