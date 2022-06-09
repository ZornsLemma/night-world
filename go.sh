#!/bin/bash
set -e

# Don't leave an outdated .ssd lying around if the build fails. TODO: No, this is
# a nice idea, but it makes it more (?) likely b-em won't see a change.
# rm -f night-world.ssd

mkdir -p tmp
beebasm -v -o tmp/world-1c -i src/world-1c.asm > tmp/world-1c.lst
cmp orig/world-1c tmp/world-1c || (echo world-1 not rebuilt correctly > /dev/stderr; exit 1)

# TODO: It would probably be possible to use beebasm's PUTBASIC for this, but I
# have hopes of later being able to manually "unpack" world-2.bas and use
# meaningful variable/ procedure names and have basictool crunch this at build
# time.
USE_WORLD_2_ANNOTATED=1
if [ "$USE_WORLD_2_ANNOTATED" == "0" ]; then
    basictool -t src/world-2.bas tmp/world-2.tok
    cmp orig/world-2.tok tmp/world-2.tok || (echo world-2.tok not rebuilt correctly > /dev/stderr; exit 1)
else
    python preprocess.py src/world-2-annotated.bas > tmp/world-2-annotated.bas
    # TODO: Do we need --pack-singles-n?
    basictool -tp --pack-singles-n tmp/world-2-annotated.bas tmp/world-2.tok
fi


# world-2.asm has been manually modified so world-2.py is now "frozen" as just
# an artefact of the disassembly process.
# python world-2.py > src/world-2.asm
#beebasm -v -o tmp/world-2 -i src/world-2.asm > tmp/world-2.lst
#if [ "$USE_WORLD_2_ANNOTATED" == "0" ]; then
#    cmp orig/world-2 tmp/world-2 || (echo world-2 not rebuilt correctly > /dev/stderr; exit 1)
#fi

basictool -t src/nightwo.bas tmp/nightwo.tok
#cmp orig/nightwo tmp/nightwo.tok || (echo nightwo.tok not rebuilt correctly > /dev/stderr; exit 1)

basictool -2t src/world-1b.bas tmp/world-1b.tok

beebasm -do tmp/int1.ssd -title "Night World" -opt 3 -i src/disc.asm
#beebasm -do tmp/int2.ssd -di tmp/int1.ssd -D MAKE_IMAGE -i src/world-1c-wrapper.asm
#beebasm -do night-world.ssd -di tmp/int2.ssd -D MAKE_IMAGE -i src/world-2.asm
beebasm -do night-world.ssd -di tmp/int1.ssd -D MAKE_IMAGE -i src/world-1c-wrapper.asm -v > tmp/world-1c-wrapper.lst
