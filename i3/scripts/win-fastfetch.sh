#!/bin/bash
export NO_FASTFETCH=1
fastfetch -c ~/.config/fastfetch/hacker.jsonc
exec bash
