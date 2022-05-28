from commands import *
from trace6502 import *
import acorn

acorn.bbc()
label(0x18, "basic_page_msb")
label(0x45c, "ri_w")
label(0x460, "ri_x")
label(0x464, "ri_y")

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
# TODO: If these are all permanently set, can get rid of the "initial_" in the labels
comment(0x54a3, "TODO: S% at least is effectively a way for this machine code to communicate its internal addresses to the BASIC - quite a neat trick. Other variables here may well work the same way")
label(0x54dc, "initial_qrstuv_values") 
label(0x54dc+0x18, "initial_qrstuv_values_end")
expr(0x54a6, "initial_qrstuv_values-1")
for i in range(6):
    label(0x54dc+i*4, "initial_%s_value" % chr(ord("q")+i))
    word(0x54dc+i*4, 2)
entry(0x4f00, "q_subroutine") # TODO: rename
expr(0x54dc+0*4, "q_subroutine")
comment(0x54dc+1*4, "TODO: never used?")
entry(0x5033, "s_subroutine") # TODO: rename
expr(0x54dc+2*4, "s_subroutine")
entry(0x52e3, "t_subroutine") # TODO: rename
expr(0x54dc+3*4, "t_subroutine")
entry(0x53fb, "u_subroutine") # TODO: rename
expr(0x54dc+4*4, "u_subroutine")
entry(0x5499, "v_subroutine") # TODO: rename
expr(0x54dc+5*4, "v_subroutine")

# q_subroutine
label(0x4f66, "zero_ri_x_y_and_rts")

# TODO: What "data" is this, though? There's presumably a suggestion that the data at unpacked_data[n*2] and zero_data[n] is related.
comment(0x54ae, "TODO: This code probably initialises some game state; if this is one-off initialisation I think it could just have been done at build time, but if it changes during gameplay it makes sense to have code to reset things when a new game starts.")
label(0x5700, "packed_data")
#label(0x5700+0x30*2, "packed_data_end")
label(0x5600, "unpacked_data")
expr_label(0x5601, "unpacked_data+1")
label(0x5600+0x30*4, "unpacked_data_end")
label(0x5760, "zero_data") # TODO: very poor name, I think
expr_label(0x5761, "zero_data+1")
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
