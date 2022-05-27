from commands import *
from trace6502 import *
import acorn

load(0x1f00, "orig/world-1", "630948d4685cb15e7485103744ff95f7")
entry(0x3560, "start")
# The embedded BASIC code CALLs this address.
entry(0x3590, "basic_entry")

comment(0x3560, "Set PAGE=&2900 and do OLD:RUN")
expr(0x3575, ">basic")
label(0x3580, "old_run")
string(0x3580, 8)
comment(0x2900, "Tokenised BASIC")
label(0x2900, "basic")
byte(0x2900, 0x3560-0x2900)
label(0x18, "basic_page_msb")

comment(0x3590, "Copy screen_data onto the screen")
constant(0x5800, "mode_5_himem")
expr(0x359b, ">mode_5_himem")
label(0x1f00, "screen_data")
byte(0x1f00, 0xa00)
label(0x1f00+0xa00, "screen_data_end")
expr(0x3591, ">screen_data")
expr(0x3593, ">(screen_data_end-screen_data)")

acorn.bbc()

go()
