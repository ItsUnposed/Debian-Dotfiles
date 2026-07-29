#!/bin/bash
printf '\033]0;Task-Manager\007'
if   command -v btop >/dev/null; then btop
elif command -v htop >/dev/null; then htop
else echo "FEHLER: weder btop noch htop installiert"
fi
printf '\033]0;Task-Manager\007'
echo; echo "beendet - Taste zum Schliessen"; read -r -n1
