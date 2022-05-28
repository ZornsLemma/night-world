#!/bin/bash
set -e

# TODO: Probably wouldn't be a bad idea to have another directory to put build artefacts
# like *.lst files and *.tok files into.

# TODO: world-1 contains embedded BASIC and eventually we might want to split it up and
# handle the two parts separately, but let's not worry about that for now.
python world-1.py > src/world-1.asm
beebasm -v -o world-1.new -i src/world-1.asm > world-1.lst
cmp orig/world-1 world-1.new || (echo world-1 not rebuilt correctly > /dev/stderr; exit 1)

# TODO: It would probably be possible to use beebasm's PUTBASIC for this, but I have
# hopes of later being able to manually "unpack" world-2.bas and use meaningful variable/
# procedure names and have basictool crunch this at build time.
basictool -t src/world-2.bas world-2.tok

# world-2.asm has been manually modified so world-2.py is now "frozen" as just
# an artefact of the disassembly process.
# python world-2.py > src/world-2.asm
beebasm -v -o world-2.new -i src/world-2.asm > world-2.lst
cmp orig/world-2 world-2.new || (echo world-2 not rebuilt correctly > /dev/stderr; exit 1)
