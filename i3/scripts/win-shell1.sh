#!/bin/bash
if   command -v btop  >/dev/null; then btop
elif command -v htop  >/dev/null; then htop
else echo "FEHLER: weder btop noch htop installiert"
fi
echo; echo "beendet - Taste zum Schliessen"; read -r -n1
