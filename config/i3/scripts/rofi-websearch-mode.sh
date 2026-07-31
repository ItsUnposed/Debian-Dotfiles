#!/bin/bash

if [ -n "$1" ]; then
    coproc ( xdg-open "https://www.google.com/search?q=$(echo "$1" | sed 's/ /+/g')" > /dev/null 2>&1 )
    exit 0
fi

echo "Suche eingeben..."
