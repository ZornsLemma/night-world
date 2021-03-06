from commands import *
from trace6502 import *
import acorn

acorn.bbc()
label(0x18, "basic_page_msb")
label(0x404, "ri_a")
expr_label(0x405, "ri_a+1")
label(0x408, "ri_b")
expr_label(0x409, "ri_b+1")
label(0x45c, "ri_w")
label(0x460, "ri_x")
label(0x464, "ri_y")
label(0x468, "ri_z")
constant(0x30, "max_sprite_num")

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
byte(0x2900, 0x3508-0x2900)

comment(0x3590, "Copy screen_data onto the screen")
constant(0x5800, "mode_5_himem")
expr(0x359b, ">mode_5_himem")
label(0x1f00, "screen_data")
byte(0x1f00, 0xa00)
label(0x1f00+0xa00, "screen_data_end")
expr(0x3591, ">screen_data")
expr(0x3593, ">(screen_data_end-screen_data)")

# There is no room 0; the code at "start" lives there.
for i in range(1, 15):
    label(0x3508+i*180, "room_data_%02d" % i)
    # Use 10 columns because each byte represents two OS characters, so 10 bytes
    # is a screen row.
    byte(0x3508+i*180, 180, cols=10)
    # Luckily (deliberately?) the way the values are packed into these bytes
    # means that by expressing the data as two bit binary constants, the 1s
    # indicate where platforms exists, making the level layout kind-of visible
    # in the source.
    def custom_binary_formatter(n, bits):
        return "%"+("00"+(bin(n)[2:]))[-2:]
    set_formatter(0x3508+i*180, 180, custom_binary_formatter)

label(0x3508+15*180, "something") # TODO: bad name, just to mark end of room data

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
entry(0x4f9f, "r_subroutine")
expr(0x54dc+1*4, "r_subroutine")
entry(0x5033, "s_subroutine") # TODO: rename
expr(0x54dc+2*4, "s_subroutine")
entry(0x52e3, "t_subroutine") # TODO: rename
expr(0x54dc+3*4, "t_subroutine")
entry(0x53fb, "u_subroutine") # TODO: rename
expr(0x54dc+4*4, "u_subroutine")
entry(0x5499, "v_subroutine") # TODO: rename
expr(0x54dc+5*4, "v_subroutine")

comment(0x4f9f, "TODO: Dead code?")
comment(0x5026, "TODO: Dead code?")

# q_subroutine
comment(0x4f00, "Based on how this is called by world-2.bas, I infer that it is a collision detection subroutine which returns with X% indicating what was collided with, or 0 if nothing. The code here appears to return values in Y% and Z% but I don't think they are used by the game. W% on entry is probably the sprite we are checking for collisions with; world-2.bas always sets it to the current player sprite. Y% is also used to pass something in but I don't know what; world-2.bas always sets it to 8.")
label(0x4f66, "zero_ri_x_y_and_rts")
comment(0x4f10, "We have X=(W%-1)*2, Y=(W%-1)*4. X retains this value for the entire subroutine. Y's value is only used if the beq q_subroutine_y_loop_test_and_bump branch is taken on the first pass round q_subroutine_y_loop.")
expr(0x4f06, "max_sprite_num+1")
expr(0x4f1d, "max_sprite_num+1")
constant(0x71, "q_subroutine_ri_w_minus_1_times_2")
expr(0x4f16, "q_subroutine_ri_w_minus_1_times_2")
expr(0x4f29, "q_subroutine_ri_w_minus_1_times_2")
constant(0x70, "q_subroutine_ri_y_minus_1_times_2")
expr(0x4f25, "q_subroutine_ri_y_minus_1_times_2")
expr(0x4f5e, "q_subroutine_ri_y_minus_1_times_2")
label(0x4f28, "q_subroutine_y_loop")
comment(0x4f28, "Don't test for collision of W% with itself!")
comment(0x4f28, "TODO: This is roughly a loop over Y, bumping Y by 2 each time, although the end condition is complex - note that because Y temporarily gets copied into A for the bump by 2, the code at &4f5d has the *original* value of Y when it does cpy")
label(0x4f5d, "q_subroutine_y_loop_test_and_bump")
comment(0x4f3c, "sprite_pixel_coord_table_xy,x > sprite_pixel_coord_table_xy,y (TODO: assuming unsigned)")
comment(0x4f4f, "sprite_pixel_coord_table_xy+1,x > sprite_pixel_coord_table_xy+1,y (TODO: assuming unsigned)")
comment(0x4f5b, "always branch", inline=True)
label(0x4f83, "q_subroutine_set_ri_x_y_z_to_something_and_rts")

# s_subroutine
label(0x5025, "s_subroutine_rts")
comment(0x5033, "Entered with a sprite slot number in W%.\n\nIf Y%=2 or slot W% has invalid coordinates, if the sprite is on on screen and is eor-plotted to remove it and sprite_screen_and_data_addrs updated to reflect this. This is a no-op if the sprite is not on screen.\n\nIf Y% is not 2, the sprite is eor-plotted at its new position and sprite_screen_and_data_addrs updated to reflect this. If Y% is also not 1, the sprite is eor-plotted at its old position.\n\nEffectively Y%=1 means 'show sprite', Y%=0 means 'move sprite' and Y%=2 means 'remove sprite'.")
comment(0x519a, "TODO: I believe this is effectively a jmp and nothing cares about the fact we've cleared carry.")
# TODO: I believe this address is only ever read from, but maybe there's something that can modify it.
label(0x55f9, "constant_96")
label(0x50e1, "clc_jmp_sprite_core")
label(0x50e5, "remove_sprite_from_screen") # TODO: poor name!
label(0x502f, "clc_remove_sprite_from_screen")
label(0x511c, "get_sprite_details")
comment(0x5129, "TODO: I don't think the value written to l0075 here is ever used?")
comment(0x511c, "Entered with A=W%-1; 0<=A<=&2F")
comment(0x511c, "TODO: After the initial shifts, we have set Y=A*8 and then anded it with &38=%00111000. We then use Y as an offset from ri_a, so we are effectively addressing A% (A=0/Y=0), C% (A=1/Y=8), E% (A=2/Y=16), ... here. Similarly, the offset from ri_b will address the next resident integer variable, i.e. B% if A=0/Y=0, D% if A=1/Y=8, etc.")
for a in range(0x30):
    y = (a << 3) & 0x38
    comment(0x511c, "    W%%=&%02X => A=&%02X => Y=&%02X => %s%%" % (a+1, a, y, chr(ord('A')+(y/4))))
comment(0x512b, "Set l0076 (low) and l0078 (high) to the first resident integer variable for this sprite divided by 8, which converts from OS coordinates (0-1279) to pixel coordinates (0-319). Similarly, divide the second resident integer variable by 4 to get Y pixel coordinates (0-255) at l0077 (low) and l0079 (high).")
# TODO: Let's just assume these addresses are single-use
label(0x76, "sprite_pixel_x_lo")
label(0x78, "sprite_pixel_x_hi")
label(0x77, "sprite_pixel_y_lo")
label(0x79, "sprite_pixel_y_hi")

# TODO: (for py8dis) this overrides things like "sprite_ptr+1" even outside the context region indicated. I vaguely see why this is happening, but it doesn't feel right.
#def our_label_maker(addr, context, suggestion):
#    if 0x52e3 <= context <= 0x53eb and addr < 0x100:
#        return "TODO%04x" % addr
#    return None
#set_label_maker_hook(our_label_maker)

# t_subroutine
comment(0x52e3, "Takes sprite slot in W%. No-op if Z% is 5, &A or &14. Otherwise appears to be responsible for moving the selected sprite according to some internal rules. Set Y%=0 (move) and calls s_subroutine after moving.")
label(0x52bb, "cli_rts")
expr(0x52e9, "max_sprite_num+1")
# TODO: Hack to work around over-zealous global naming of these addresses, which don't apply to t_subroutine.
label(0x70, "l0070")
label(0x71, "l0071")
label(0x76, "l0076")
label(0x7e, "l007e")
label(0x7f, "l007f")
expr(0x530c, "l0070")
expr(0x5316, "l007f")
expr(0x531a, "l007e")
expr(0x5328, "l007e")
expr(0x532f, "l007f")
expr(0x531f, "l0076")
expr(0x5345, "l0071")
expr(0x5360, "l0076")
expr(0x5362, "l0071")
expr(0x5399, "l0071")
label(0x537e, "t_subroutine_invalid_sprite_pixel_coord")
label(0x55c0, "sprite_something_table_two_bytes_per_sprite")
expr_label(0x55c1, "sprite_something_table_two_bytes_per_sprite+1")

# u_subroutine
# TODO: I think I have been getting slightly mixed up with sprites. Need to tweak all comments later once this is clearer. Roughly speaking I think there are sprite "slots" (1-&30 inclusive) and sprite "images" (1-&30 inclusive). Each slot remembers what was last plotted there (using the sprite address in sprite_screen_and_data_addrs for the relevant slot).")
comment(0x53fb, "If X%=0 on entry, update the resident integer variables for sprite slot W% with that sprite's current OS coordinates. Otherwise, remove the existing sprite in slot W% from the screen and replace it with sprite image X%, effectively changing its appearance in place. TODO: There are probably some subtleties here, but I think that's broadly right.")
expr(0x5401, "max_sprite_num+1") # TODO: DO THIS ELSEWHERE &31 APPEARS
expr(0x540d, "max_sprite_num+1")
label(0x53eb, "u_subroutine_rts")
label(0x5498, "u_subroutine_rts2")
label(0x545f, "u_subroutine_ri_x_0")
comment(0x5424, "Get the sprite's X pixel coordinate and use its low two bits to select one of the four pre-shifted variants, assuming it is a two character cell (8 pixel) wide sprite.")
#constant(0x73, "u_subroutine_sprite_pixel_coord_table_xy_y_and_3_times_16")
#expr(0x542e, "u_subroutine_sprite_pixel_coord_table_xy_y_and_3_times_16")
#expr(0x5431, "u_subroutine_sprite_pixel_coord_table_xy_y_and_3_times_16")
#constant(0x72, "u_subroutine_sprite_pixel_coord_table_xy_y_and_3_times_48")
#expr(0x5433, "u_subroutine_sprite_pixel_coord_table_xy_y_and_3_times_48")
#expr(0x5449, "u_subroutine_sprite_pixel_coord_table_xy_y_and_3_times_48")

# Sprite core code.
# TODO: This is probably a good thing to focus on now - even a first glance at this makes it a lot more obvious what some other code is setting up in the zero page locations, and working back from this sprite core is probably helpful.
comment(0x51ff, "Sprite plot routine. EORs a 3-byte (12 pixel) wide sprite onto the screen, writing data starting at the address pointed to by screen_ptr and taking sprite data from the address pointed to by sprite_ptr. There's provision for wrapping around onto next screen character row as required and I think in principle sprites can be arbitrarily many screen character rows tall; it looks as though l0075 is used to control this, although in practice it is probably always 1 as I can't see any entry point which would change this. (The caller will have adjusted the start screen address to allow for arbitrary Y pixel positioning; the sprite data itself is not adjusted - I think this is obvious really but it confused me for a while.)\n\nThere seems to be a slightly odd desire to keep carry clear all the time instead of just clearing it before we need it to be clear, but I may be missing something.")
label(0x51ff, "sprite_core")
label(0x5203, "sprite_core_outer_loop")
label(0x5205, "sprite_core_inner_loop")
label(0x524c, "sprite_core_low_byte_wrapped")
label(0x522b, "sprite_core_low_byte_wrap_handled")
label(0x5239, "sprite_core_no_carry")
comment(0x524a, "always branch", inline=True)
comment(0x524f, "always branch", inline=True)
constant(320, "bytes_per_screen_line")
expr(0x5241, "<(bytes_per_screen_line-7)")
expr(0x5246, ">(bytes_per_screen_line-7)")
label(0x5227, "sprite_core_screen_ptr_updated")
label(0x523e, "sprite_core_next_row")
blank(0x5251)
comment(0x5251, "TODO: This looks like an 'alternate version' of sprite_core? I haven't been over the code properly yet, but I suspect it is a 'erase at old location, replot immediately at new location' variant, to handle moving sprites more efficiently.")
# TODO: Provisionally assuming these zp locations are single-use
label(0x7a, "screen_ptr")
expr_label(0x7b, "screen_ptr+1")
label(0x70, "sprite_ptr")
expr_label(0x71, "sprite_ptr+1")
label(0x7c, "screen_ptr2")
expr_label(0x7d, "screen_ptr2+1")
label(0x7e, "sprite_ptr2")
expr_label(0x7f, "sprite_ptr2+1")
constant(0x75, "sprite_y_offset_within_row")
expr(0x5065, "sprite_y_offset_within_row")
expr(0x506b, "sprite_y_offset_within_row")
label(0x5251, "sprite_core_moving")

# TODO: What "data" is this, though? There's presumably a suggestion that the data at sprite_screen_and_data_addrs[n*2] and sprite_pixel_coord_table_xy[n] is related.
comment(0x5499, "TODO: This code probably initialises some game state; if this is one-off initialisation I think it could just have been done at build time, but if it changes during gameplay it makes sense to have code to reset things when a new game starts.")
comment(0x5700, "This appears to be a big-endian table of start addresses for the game sprites. TODO: This is inspired guesswork; note that the copy of this at sprite_screen_and_data_addrs+{2,3] does get tweaked slightly.")
label(0x5700, "sprite_ref_addrs_be")
expr_label(0x5701, "sprite_ref_addrs_be+1")
sprite_labels = {}
for i in range(0x30):
    addr = 0x5700+i*2
    sprite_addr = get_u16_be(addr)
    if sprite_addr not in sprite_labels:
        sprite_labels[sprite_addr] = "sprite_%02d" % i
        # byte(sprite_addr, n=TODO, cols=TODO)
    label(sprite_addr, sprite_labels[sprite_addr])
    byte(addr, n=2)
    expr(addr, ">%s" % sprite_labels[sprite_addr])
    expr(addr+1, "<%s" % sprite_labels[sprite_addr])
#label(0x5700+0x30*2, "sprite_ref_addrs_be_end")
comment(0x5600, "This is (TODO: probably!) a table with four bytes per sprite. The first two bytes are the little-endian screen address of the sprite (0 if it is not on screen) and the second two bytes are the big-endian address of the sprite's definition. The sprite address is the address of X-offset version 0; this does not change as the sprite moves, so it needs to be offset appropriately when plotting/unplotting.")
annotate(0x5600, ".sprite_screen_and_data_addrs") # TODO: hacky
constant(0, "screen_addr_lo")
constant(1, "screen_addr_hi")
constant(2, "sprite_addr_hi")
constant(3, "sprite_addr_lo")
expr_label(0x5600, "sprite_screen_and_data_addrs+screen_addr_lo")
expr_label(0x5601, "sprite_screen_and_data_addrs+screen_addr_hi")
expr_label(0x5602, "sprite_screen_and_data_addrs+sprite_addr_hi")
expr_label(0x5603, "sprite_screen_and_data_addrs+sprite_addr_lo")
screen_y_addr_table_addr = 0x5600+0x30*4
label(screen_y_addr_table_addr, "screen_y_addr_table") # TODO: poor name!
expr_label(screen_y_addr_table_addr+1, "screen_y_addr_table+1")
for i in range(32):
    word(screen_y_addr_table_addr+i*2)
comment(0x5760, "Table of (pixel X coordinate, pixel Y coordinate) sprite positions, two bytes per sprite")
label(0x5760, "sprite_pixel_coord_table_xy")
expr_label(0x5761, "sprite_pixel_coord_table_xy+1")
label(0x5760+0x30*2, "sprite_pixel_coord_table_xy_end")
expr(0x54b8, "sprite_ref_addrs_be+0")
#expr(0x54bb, "sprite_screen_and_data_addrs+2")
expr(0x54be, "sprite_ref_addrs_be+1")
#expr(0x54c1, "sprite_screen_and_data_addrs+3")
expr(0x54c6, "sprite_pixel_coord_table_xy+0")
expr(0x54c9, "sprite_pixel_coord_table_xy+1")
#expr(0x54cb, "sprite_screen_and_data_addrs+0")
#expr(0x54cf, "sprite_screen_and_data_addrs+1")

go()
