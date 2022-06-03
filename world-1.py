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

load(0x35bc, "orig/world-1c", "28ab793fefbf7fa374ab6bd3957921c7")

# There is no room 0; the code at "start" lives there.
comment(0x35bc, "TODO: Once we abandon py8dis, we could probably have a beebasm macro which will take a single long binary number and split it up, allowing the screen to be more visible in the data.")
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
comment(0x4f00, "Based on how this is called by world-2.bas, I infer that it is a collision detection subroutine which returns with X% indicating what was collided with, or 0 if nothing. The code here appears to return values in Y% and Z% but I don't think they are used by the game. W% on entry is probably the sprite we are checking for collisions with; world-2.bas always sets it to the current player sprite. Y% on entry is the maximum 1-based sprite slot to check for collisions; world-2.bas always sets it to 8.")
label(0x4f66, "q_subroutine_no_collision_found")
comment(0x4f10, "We have X=(W%-1)*2, Y=(W%-1)*4. X retains this value for the entire subroutine. Y's value is only used if the beq q_subroutine_next_candidate branch is taken on the first pass round q_subroutine_y_loop.")
expr(0x4f06, "max_sprite_num+1")
expr(0x4f1d, "max_sprite_num+1")
constant(0x71, "q_subroutine_sprite_to_check_x2")
expr(0x4f16, "q_subroutine_sprite_to_check_x2")
expr(0x4f29, "q_subroutine_sprite_to_check_x2")
constant(0x70, "q_subroutine_max_candidate_sprite_x2")
expr(0x4f25, "q_subroutine_max_candidate_sprite_x2")
expr(0x4f5e, "q_subroutine_max_candidate_sprite_x2")
label(0x4f28, "q_subroutine_y_loop")
comment(0x4f28, "Don't test for collision of W% with itself!")
comment(0x4f28, "TODO: If W%=1 on entry, the first pass round the q_subroutine_y_loop will take the beq, but Y doesn't yet contain the loop variable (because of our shuffling in and out of A). As it happens, we will get away with this because Y will be (W%-1)*4=0, so it does effectively contain the loop variable 'by chance'. This isn't a big deal, but I'm noting it as may want to double-check this understanding before trying to avoid the Y-A shuffle. Actually I think there is another bug here, if (say) W%=3 and Y%=4 on entry, the loop will get stuck with A=4 and Y=2, because the increment of Y will never happen because of the Y-A shuffle. As long as W%>Y% on entry - which it is in the game - this can't happen.")
comment(0x4f28, "TODO: I suspect we could avoid shuffling Y into A and just do iny:iny and change some cmp to cpy")
label(0x4f5d, "q_subroutine_next_candidate")
comment(0x4f38, "TODO: Isn't this BMI unreliable? What if we did 0-140=-140=116, for example? Or 150-0? Wouldn't the correct test be BCC? In practice this works fine for values in the range 0-159 inclusive; I wrote a program to test all cases, but I have some vague flickering in my brain that says this is semi-obvious if you think about it. I think it might still be true the state of the carry when we're negating is sometimes wrong, but maybe it's not, and at worst it will cause an extra pixel of 'fuzz' in the collision detection.")
comment(0x4f3c, "sprite to check's X co-ordinate is >= candidate sprite's X co-ordinate.")
comment(0x4f4f, "sprite_pixel_coord_table_xy+1,x > sprite_pixel_coord_table_xy+1,y (TODO: assuming unsigned)")
comment(0x4f5b, "always branch", inline=True)
label(0x4f83, "q_subroutine_q_subroutine_collision_found")
decimal(0x5f8b)
comment(0x4f83, "Set Y% to 35-(abs_x_difference*2)-abs_y_difference, so (roughly) Y% indicates how much the sprites are overlapping - it will range from 4 if both differences are as large as possible up to 35 if the two sprites coincide perfectly. world-2.bas doesn't seem to use this.")
label(0x4f6f, "q_subroutine_sprite_to_check_x_lt_candidate_x")
#label(0x4f61, "q_subroutine_negate_x_difference")
comment(0x4f71, "TODO: As written, don't we need a clc here? I am not convinced C will always be implicitly clear (e.g. if we did 150-0 at &4f31 - N would be set, but there's no borrow so C will still be set).")
comment(0x4f6f, "Set A=-A")
comment(0x4f75, "always branch", inline=True)
label(0x4f3e, "q_subroutine_test_abs_x_difference")
comment(0x4f42, "abs(sprite_to_check.x - candidate_sprite.x) < 9 (TODO: subject to concerns about bugs in other TODOs), so we consider the sprites to be overlapping in X and we need to check Y.")
constant(0x72, "q_subroutine_abs_x_difference")
expr(0x4f43, "q_subroutine_abs_x_difference")
expr(0x4f84, "q_subroutine_abs_x_difference")
constant(0x73, "q_subroutine_abs_y_difference")
expr(0x4f5a, "q_subroutine_abs_y_difference")
expr(0x4f87, "q_subroutine_abs_y_difference")
comment(0x4f44, "TODO: same concerns as for X about this not working for some values.")
label(0x4f77, "q_subroutine_sprite_to_check_y_lt_candidate_y")
comment(0x4f77, "Set A=-A (TODO: same 'clc needed' concern as for X)")
comment(0x4f81, "always branch", inline=True)
label(0x4f55, "q_subroutine_test_abs_y_difference")
comment(0x4f59, "abs(sprite_to_check.y - candidate_sprite.y) < 16 (TODO: subject to concerns about bugs), so these two sprites overlap and we're done.")
label(0x4f9e, "q_subroutine_rts")
comment(0x4f64, "always branch", inline=True)
comment(0x4f97, "Set X% to the 1-based logical sprite number we found a collision with.")
comment(0x4f92, "Set Z% to TODO: some number indicating something about the collision. world-2.bas doesn't appear to use this, although I'm not currently absolutely certain of this.")
comment(0x4f66, "Set X% and Y% to 0 to indicate no collision found.")

# r_subroutine
label(0x57f0, "r_subroutine_inkey_code_1")
label(0x57f1, "r_subroutine_inkey_code_2")
label(0x57f2, "r_subroutine_inkey_code_3")
label(0x57f3, "r_subroutine_inkey_code_4")
label(0x57f4, "r_subroutine_foo")

# s_subroutine
label(0x5025, "s_subroutine_rts")
label(0x511b, "s_subroutine_rts2")
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
comment(0x512b, "Set l0076 (low) and l0078 (high) to the first resident integer variable for this sprite divided by 8, which converts from OS coordinates (0-1279) to pixel coordinates (0-159). Similarly, divide the second resident integer variable by 4 to get Y pixel coordinates (0-255) at l0077 (low) and l0079 (high).")
# TODO: Let's just assume these addresses are single-use
label(0x76, "sprite_pixel_x_lo")
label(0x78, "sprite_pixel_x_hi")
label(0x77, "sprite_pixel_y_lo")
label(0x79, "sprite_pixel_y_hi")
constant(0x72, "sprite_pixel_current_x")
expr(0x5154, "sprite_pixel_current_x")
constant(0x73, "sprite_pixel_current_y")
expr(0x5159, "sprite_pixel_current_y")
expr(0x514f, "get_sprite_details_sprite_index")
expr(0x511d, "get_sprite_details_sprite_index")
constant(0x7c, "get_sprite_details_sprite_index")
comment(0x515a, "TODO: Won't sprite_pixel_x_hi always be 0, since if it's on-screen it will have been reduced to the range 0-159 after dividing by 8?")
label(0x516e, "sprite_pixel_x_hi_zero")
label(0x51b8, "sprite_pixel_y_hi_zero")
comment(0x5168, "TODO: cmp #&80 redundant? we just did LDA which will have set N so we can use beq/bne instead")
#label(0x5182, "sprite_pixel_x_hi_1_to_7f")
comment(0x519d, "always branch", inline=True)
label(0x55f8, "constant_2")
label(0x5164, "sprite_check_y_position")
label(0x51c6, "sprite_y_position_adjusted")
label(0x517c, "sprite_x_position_ok")
comment(0x5180, "always branch", inline=True)
comment(0x5190, "always branch", inline=True)
comment(0x55fa, "TODO: This is just a constant in this game.")
label(0x55fa, "sprite_y_min")
comment(0x55fb, "TODO: This is just a constant in this game.")
label(0x55fb, "sprite_y_max")
expr(0x5121, "l007d")
constant(0x7d, "l007d")
comment(0x5120, "TODO: Is the value written to &7D ever used?")
label(0x519d, "sprite_x_position_too_far_left")
label(0x5182, "sprite_x_position_too_far_right")
label(0x51cb, "sprite_y_position_too_far_up")
label(0x51e5, "sprite_y_position_too_far_down")
label(0x5192, "force_sprite_x_position_to_rhs")
label(0x51ad, "force_sprite_x_position_to_lhs")
label(0x51f5, "force_sprite_y_position_to_constant_10")
label(0x51db, "force_sprite_y_position_to_constant_fe")
comment(0x51ab, "always branch", inline=True)
comment(0x53f6, "always branch", inline=True)

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
label(0x5256, "sprite_core_moving_outer_loop")
label(0x5258, "sprite_core_moving_inner_loop")
expr(0x50d5, "sprite_ptr2")
expr(0x50dc, "sprite_ptr2+1")
expr(0x525d, "sprite_ptr2")
expr(0x526b, "sprite_ptr2")
expr(0x5279, "sprite_ptr2")
expr(0x5263, "sprite_ptr")
expr(0x5271, "sprite_ptr")
expr(0x527f, "sprite_ptr")

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
        byte(sprite_addr, 0xc0)
        # byte(sprite_addr, n=TODO, cols=TODO)
    label(sprite_addr, sprite_labels[sprite_addr])
    byte(addr, n=2)
    expr(addr, ">%s" % sprite_labels[sprite_addr])
    expr(addr+1, "<%s" % sprite_labels[sprite_addr])
label(0x4d80+0xc0, "sprite_end")
#label(0x5700+0x30*2, "sprite_ref_addrs_be_end")
comment(0x5600, "This is (TODO: probably!) a table with four bytes per sprite. The first two bytes are the little-endian screen address of the sprite (0 if it is not on screen) and the second two bytes are the big-endian address of the sprite's definition. The sprite address is the address of X-offset version 0; this does not change as the sprite moves, so it needs to be offset appropriately when plotting/unplotting.")
annotate(0x5600, ".sprite_screen_and_data_addrs") # TODO: hacky
for i in range(48):
    addr = 0x5600+i*4
    byte(addr, 4)
    sprite_addr = get_u16_be(0x5600+i*4+2)
    expr(addr+2, ">%s" % sprite_labels[sprite_addr])
    expr(addr+3, "<%s" % sprite_labels[sprite_addr])
    comment(addr, "sprite %d" % i, inline=True)
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
label(0x5760+0x30*2, "constant_1_per_sprite_table")
expr(0x54b8, "sprite_ref_addrs_be+0")
#expr(0x54bb, "sprite_screen_and_data_addrs+2")
expr(0x54be, "sprite_ref_addrs_be+1")
#expr(0x54c1, "sprite_screen_and_data_addrs+3")
expr(0x54c6, "sprite_pixel_coord_table_xy+0")
expr(0x54c9, "sprite_pixel_coord_table_xy+1")
#expr(0x54cb, "sprite_screen_and_data_addrs+0")
#expr(0x54cf, "sprite_screen_and_data_addrs+1")

comment(0x4e40, "TODO: This appears to be mode 5 graphics data showing '< 1 > Load ' (just *LOAD World1c 5800 to see this), so this is almost certainly junk/a build artefact/spare space.")
comment(0x57c0, "TODO: This table appears to be read-only and since every byte is 1, we can probably replace accesses to it with immediate constants and get rid of it.")

go()
