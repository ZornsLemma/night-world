from commands import *
from trace6502 import *
import acorn

acorn.bbc()

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

comment(0x5499, "Zero resident integer variables A%-Z%")
comment(0x54a3, "Initialise resident integer variables Q%-V%")
label(0x54dc, "initial_qrstuv_values")
label(0x54dc+0x18, "initial_qrstuv_values_end")
expr(0x54a6, "initial_qrstuv_values-1")
byte(0x54dc, 0x18)

# TODO: What "data" is this, though? There's presumably a suggestion that the data at unpacked_data[n*2] and zero_data[n] is related.
comment(0x54ae, "TODO: This code probably initialises some game state; if this is one-off initialisation I think it could just have been done at build time, but if it changes during gameplay it makes sense to have code to reset things when a new game starts.")
label(0x5700, "packed_data")
label(0x5700+0x30*2, "packed_data_end")
label(0x5600, "unpacked_data")
label(0x5600+0x30*4, "unpacked_data_end")
label(0x5760, "zero_data") # TODO: very poor name, I think
label(0x5760+0x30*2, "zero_data_end")
expr(0x54b8, "packed_data+0")
expr(0x54bb, "unpacked_data+2")
expr(0x54be, "packed_data+1")
expr(0x54c1, "unpacked_data+3")
expr(0x54c6, "zero_data+0")
expr(0x54c9, "zero_data+1")
expr(0x54cb, "unpacked_data+0")
expr(0x54cf, "unpacked_data+1")

go()
