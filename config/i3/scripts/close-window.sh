#!/bin/bash
export PATH="/usr/local/bin:/usr/bin:/bin"

W=$(xdotool getactivewindow 2>/dev/null)
if [ -n "$W" ]; then
    xprop -id "$W" -f _MY_CUSTOM_CLOSE 32c -set _MY_CUSTOM_CLOSE 1
    xprop -id "$W" _MY_CUSTOM_CLOSE >/dev/null 2>&1   # Roundtrip, wartet auf den X-Server
fi
i3-msg kill >/dev/null
