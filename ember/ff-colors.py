#!/usr/bin/env python3
import sys, json, re, os

path, acc, acc2, acc3 = sys.argv[1:5]

def a(h):
    h = h.lstrip('#')
    return "38;2;%d;%d;%d" % (int(h[0:2],16), int(h[2:4],16), int(h[4:6],16))

WHITE = "38;2;255;255;255"

raw = open(path).read()
d = json.loads(re.sub(r'^\s*//.*$', '', raw, flags=re.M))

lg = d.setdefault('logo', {}).setdefault('color', {})
if str(lg.get('1','')).startswith(WHITE):
    lg['1'], lg['2'] = WHITE, a(acc3)
else:
    lg['1'], lg['2'] = a(acc3), WHITE

d.setdefault('display', {}).setdefault('color', {})['keys'] = a(acc3)

mods = d.get('modules', [])
for i, m in enumerate(mods):
    if m == 'title':
        mods[i] = {'type': 'title'}
        m = mods[i]
    if isinstance(m, dict) and m.get('type') == 'title':
        m['color'] = {'user': '1;'+a(acc), 'at': '1;'+WHITE, 'host': '1;'+a(acc2)}

open(path, 'w').write(json.dumps(d, indent=2))
print("ok:", os.path.basename(path))
