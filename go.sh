#!/bin/bash
set -e

# TODO: world-1 contains embedded BASIC and eventually we might want to split it up and
# handle the two parts separately, but let's not worry about that for now.
python world-1.py > asm/world-1.asm
beebasm -v -o world-1.new -i asm/world-1.asm > world-1.lst
cmp orig/World-1 world-1.new || (echo world-1 not rebuilt correctly > /dev/stderr; exit 1)
