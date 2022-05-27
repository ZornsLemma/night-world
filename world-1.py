from commands import *
from trace6502 import *
import acorn

load(0x1f00, "orig/World-1", "630948d4685cb15e7485103744ff95f7")
entry(0x3560, "start")

comment(0x3560, "Set PAGE=&2900 and do OLD:RUN")
expr(0x3575, ">basic")
label(0x3580, "old_run")
string(0x3580, 8)
comment(0x2900, "Tokenised BASIC")
label(0x2900, "basic")
byte(0x2900, 0x3560-0x2900)

label(0x18, "basic_page_msb")

acorn.bbc()

go()
