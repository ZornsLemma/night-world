max_sprite_num = &30
q_subroutine_sprite_to_check_x2 = &71
q_subroutine_max_candidate_sprite_x2 = &70
q_subroutine_abs_x_difference = &72
q_subroutine_abs_y_difference = &73
sprite_pixel_current_x = &72
sprite_pixel_current_y = &73
get_sprite_details_sprite_index = &7c
l007d = &7d
t_subroutine_os_x_hi = &70
t_subroutine_os_x_lo = &71
t_subroutine_os_y_hi = &72
t_subroutine_w_minus_1_times_2 = &7f
t_subroutine_w_minus_1_times_4 = &7e
t_subroutine_w_minus_1_times_8 = &76
t_subroutine_constant_1 = &73
bytes_per_screen_line = &0140
sprite_y_offset_within_row = &75
screen_addr_lo = &00
screen_addr_hi = &01
sprite_addr_hi = &02
sprite_addr_lo = &03
osbyte_inkey = &81
osbyte_clear_escape = &7c

basic_page_msb = &0018
l0070 = &0070
sprite_ptr = &0070
l0071 = &0071
l0072 = &0072
l0073 = &0073
l0074 = &0074
l0075 = &0075
sprite_pixel_x_lo = &0076
l0076 = &0076
sprite_pixel_y_lo = &0077
sprite_pixel_x_hi = &0078
sprite_pixel_y_hi = &0079
screen_ptr = &007a
screen_ptr2 = &007c
l007e = &007e
sprite_ptr2 = &007e
l007f = &007f
ri_a = &0404
ri_b = &0408
ri_q = &0444
ri_w = &045c
ri_x = &0460
ri_y = &0464
ri_z = &0468
osbyte = &fff4


    org &35bc
.pydis_start

; ENHANCE: Rooms are 20x18 mode 5 character cells in size. They are packed two
; cells to a byte; it would be possible to pack eight cells to a byte with
; slightly cleverer decompression code, which would free up some extra memory.
macro room_row n
    for i, 9, 0, -1
        equb (n >> (i*2)) and %11
    next
endmacro

.room_data_01
    room_row %11111111111111111111
    room_row %10000000000000000000
    room_row %10000000000000000000
    room_row %10000000000000000000
    room_row %11111111111111111111
    room_row %10111111111111111100
    room_row %10010101011010101000
    room_row %10010111111111101000
    room_row %10010101011010101000
    room_row %10010111011011101001
    room_row %10010011111111001001
    room_row %10010011011011001001
    room_row %10011011111111011001
    room_row %10011010011101011001
    room_row %10001010011101010001
    room_row %10001010011101010001
    room_row %10001010011101010001
    room_row %11111010011101011111
.room_data_02
    room_row %11111111111111111111
    room_row %00000000000000000001
    room_row %00000000000000000000
    room_row %00000000000000000000
    room_row %11110000000000000000
    room_row %11100011011000100111
    room_row %00000000000000000011
    room_row %00000010001000100001
    room_row %00000000000000000001
    room_row %11101010001000111001
    room_row %11000000000000010001
    room_row %10001010001000011001
    room_row %10000000000000010001
    room_row %10001010001000011000
    room_row %10000000000000010000
    room_row %10011011011000011000
    room_row %10000000000000010001
    room_row %11000011111111111111
.room_data_03
    room_row %11111111111111111111
    room_row %10000000000000000001
    room_row %00000000000000000000
    room_row %00000000000000000000
    room_row %00000000000000000000
    room_row %11100001100110000111
    room_row %11111111100111111111
    room_row %11100011100111000011
    room_row %11000001100110000001
    room_row %10000000100100000001
    room_row %10000000000100000001
    room_row %10000000000000000001
    room_row %10000000000000000001
    room_row %00000000000000000000
    room_row %00000000000000000000
    room_row %00000000000000000000
    room_row %11001100111100110011
    room_row %11111111111111111111
.room_data_04
    room_row %11111111111100000000
    room_row %10001110111110000000
    room_row %00000110011011000001
    room_row %00000100010001100011
    room_row %00000100010000111111
    room_row %10000000000000000001
    room_row %10000000000000000001
    room_row %10000000000000000001
    room_row %10000000000000000000
    room_row %10001110111000110000
    room_row %10000100010000011000
    room_row %10000000000000001111
    room_row %10000000000010000001
    room_row %00000000000001000001
    room_row %00000001000000100001
    room_row %00000011100000010001
    room_row %10000111110000000001
    room_row %11111111111110000111
.room_data_05
    room_row %00000000000000000000
    room_row %00000000000000000000
    room_row %00000000000000000000
    room_row %01000001100100010001
    room_row %11100111100110111011
    room_row %11111111111111111111
    room_row %11011100000000000011
    room_row %10001000000000000001
    room_row %00001000000000000001
    room_row %00000000111100110001
    room_row %00000000011000000011
    room_row %10000000001000000011
    room_row %11000000000000000111
    room_row %10000001000000001101
    room_row %10100011000000000001
    room_row %10000111000001100001
    room_row %11001111110011110011
    room_row %11111111111111111111
.room_data_06
    room_row %11000011111111111111
    room_row %11000000000000000011
    room_row %11000000000000000001
    room_row %11110000000000000001
    room_row %11100011100011000001
    room_row %11000011000001000001
    room_row %10000010001100000001
    room_row %10000000001000000111
    room_row %10000000100011000011
    room_row %10000001100001000001
    room_row %10000000001100000001
    room_row %10000000000100000111
    room_row %10000000110000000011
    room_row %10011000100000100001
    room_row %10111100001101100001
    room_row %10000000000100000001
    room_row %10000000000000000011
    room_row %11000011111111111111
.room_data_07
    room_row %11111111111110000111
    room_row %10000000000110000011
    room_row %10000000000010000001
    room_row %10110000000000011001
    room_row %10000011000000001011
    room_row %10000000001100000001
    room_row %10000000000000000011
    room_row %10000000000100001111
    room_row %10001000100000000011
    room_row %10010000010110000001
    room_row %10010000010000010001
    room_row %10010000010010011001
    room_row %10010000010000000001
    room_row %10011010110010000001
    room_row %10001111100000000011
    room_row %10000111000010000111
    room_row %11000010000000011111
    room_row %11111111111111111111
.room_data_08
    room_row %11000011111111111111
    room_row %11000000000000011111
    room_row %11000000000000001111
    room_row %11001111100000000011
    room_row %11000000000000000001
    room_row %11000001100000000001
    room_row %11100000000000100001
    room_row %11111000100001110011
    room_row %11111111111111111111
    room_row %11111100010101001111
    room_row %11110000000101000011
    room_row %11100000000001000001
    room_row %11100000000001000001
    room_row %11000000010000000001
    room_row %10000000010000000001
    room_row %10000000010100000011
    room_row %10000000010101001111
    room_row %11000011111111111111
.room_data_09
    room_row %11111100000000111111
    room_row %11000110100101100011
    room_row %10000011100111000001
    room_row %10000010100101000001
    room_row %10000010111101010111
    room_row %10000010011001000001
    room_row %10000011011011011001
    room_row %10000001111110000001
    room_row %10000011100111011011
    room_row %10000010000001000001
    room_row %10000011000011000011
    room_row %10000001100110000001
    room_row %11000000111100000011
    room_row %11100000011000000111
    room_row %11110000000000001111
    room_row %11111100000000111111
    room_row %11111110000001111111
    room_row %11111111000011111111
.room_data_10
    room_row %11111111111111111111
    room_row %10000001110011100111
    room_row %11111000100001000011
    room_row %10000000000000000001
    room_row %11110000000000000001
    room_row %10000000000000000001
    room_row %11100000000000000001
    room_row %10000001110011100001
    room_row %11000000000000001101
    room_row %10000100000000000001
    room_row %11000000000000000111
    room_row %10000000000000000001
    room_row %11000010100001000011
    room_row %10000000110011000001
    room_row %11100111110011111001
    room_row %10000011100001110000
    room_row %11100110000000011000
    room_row %11111111111111111111
.room_data_11
    room_row %11000011111111111111
    room_row %11000001000000000000
    room_row %10000000000000000000
    room_row %10001100000000000000
    room_row %10000000000001100111
    room_row %10001111000111111111
    room_row %10000001000000000001
    room_row %11001111100000000001
    room_row %11000001110000000001
    room_row %10001111111110010011
    room_row %10000001000000000001
    room_row %11001111000000000011
    room_row %11000001000110011111
    room_row %11100111100011111111
    room_row %00000001000000000000
    room_row %00000111110000000000
    room_row %00000001000000000000
    room_row %11111111111111111111
.room_data_12
    room_row %11111111111111111111
    room_row %00000000000000000111
    room_row %00000000000000000011
    room_row %00001010000010100001
    room_row %11000000000000000001
    room_row %10001010000010100001
    room_row %10000000000000000011
    room_row %11001010000010100111
    room_row %10000000000000000000
    room_row %10001010101010100000
    room_row %11000000000000000000
    room_row %10001010101010100111
    room_row %10000000000000000011
    room_row %11001010000000000001
    room_row %00000000000000000001
    room_row %00001010000000000011
    room_row %00000000000000000111
    room_row %11111111111111111111
.room_data_13
    room_row %11111111111111111111
    room_row %11000011000011000011
    room_row %10000001000010000001
    room_row %10000000000000000001
    room_row %10000000000000000001
    room_row %10011100110000000001
    room_row %10000000000011000011
    room_row %11011001100000000111
    room_row %00000000000001100001
    room_row %00010000000000000001
    room_row %00000000000000110001
    room_row %11010000000000000111
    room_row %10000000000000000011
    room_row %10000011100111000001
    room_row %10000001000010000001
    room_row %10000001000010000001
    room_row %11000011100111000011
    room_row %11111111111111111111
.room_data_14
    room_row %11111111111111111111
    room_row %11100000011000001111
    room_row %11000000111100000011
    room_row %10000000011000000011
    room_row %10000001111110000001
    room_row %10000001111110000001
    room_row %10000000000000000001
    room_row %10000000000000000001
    room_row %00000001111110110001
    room_row %00000101111110000011
    room_row %00000000011000000001
    room_row %10000100011000000011
    room_row %11000000111100110001
    room_row %11100100011000000011
    room_row %11110000011000000001
    room_row %11111100011000000111
    room_row %11111110011000001111
    room_row %11111111111111111111

; ENHANCE: This is just junk data and could be deleted.
    equb 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0
    equb 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0
    equb 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0
    equb 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0
    equb 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0
    equb 0, 0, 0

; Each sprite has four frames, each of which occupies 24 bytes, for a total of
; 192 bytes per sprite. The frames are pre-shifted versions of the sprite for
; the four different X offsets within a byte of mode 5 screen memory. Many
; sprites are animated "for free" by changing the design for each frame. Sprite
; 9 has four conceptually unrelated sprites in its different frames; the game
; makes sure to display these only at the appropriate offset. Sprites are
; nominally 8x16 pixels, but the sprite data is actually 12x16 pixels to allow
; for black (= transparent) pixels to accomodate the appropriate X offset.
;
; The sprite numbers used in these labels are 0-based logical numbers, as
; defined by the table at sprite_ref_addrs_be. TODO: Would it make more sense to
; use physical numbering, or to use our sprite names?
;
; ENHANCE: There might be a small performance improvement to be had by ensuring
; the sprite data (at least the sprite data for any particular frame) doesn't
; cross any page boundaries.
;
; TODO: It might be possible/worthwhile to write a beebasm macro (it would
; probably need to shift P% around internally) to allow these sprites to be
; shown in a pseudo- graphical form in the source code. It would probably be
; best if the input was a hex number which uses 0/1/2/3 for the colours and the
; macro did the necessary bit-twiddling internally to generate screen data..
;
; Final Guardian/Demon Lord
.sprite_00
    equb &cc, &ee, &aa, &aa, &aa, &aa, &aa, &aa,   0,   0,   0,   0
    equb   0,   0, &ff, &aa,   0,   0,   0,   0,   0,   0, &88, &88
    equb &aa, &aa, &aa, &aa, &aa, &aa, &ee, &cc, &aa, &aa, &88, &88
    equb &88, &88, &88, &cc, &88, &88, &88, &88, &88, &88, &88, &88
    equb &60, &70, &50, &50, &50, &50, &50, &50,   0,   0,   0,   0
    equb   0,   0, &70, &50,   0,   0,   0,   0,   0,   0, &c0, &40
    equb &50, &50, &50, &50, &50, &50, &70, &60, &50, &50, &40, &40
    equb &40, &40, &40, &60, &40, &40, &40, &40, &40, &40, &40, &40
    equb   3,   3,   2,   2,   2,   2,   2,   2,   0,   8,   8,   8
    equb   8,   8, &0b, &0a,   0,   0,   0,   0,   0,   0, &0e, &0a
    equb   2,   2,   2,   2,   2,   2,   3,   3, &0a, &0a, &0a, &0a
    equb &0a, &0a, &0a,   3, &0a, &0a,   2,   2,   2,   2,   2,   2
    equb   0,   0,   0,   0,   0,   0,   0,   0,   0,   0,   0,   0
    equb   0,   0,   0,   0,   0,   0,   0,   0,   0,   0,   0,   0
    equb   0,   0,   0,   0,   0,   0,   0,   0,   0,   0,   0,   0
    equb   0,   0,   0,   0,   0,   0,   0,   0,   0,   0,   0,   0
; Human, facing right
.sprite_08
    equb   3,   3, &17, &33, &33, &12, &21, &43,   8, &0c, &80, &88
    equb   0,   8,   8,   8,   0,   0,   0,   0,   0,   0,   0,   0
    equb &31,   3, &30,   3, &87, &87, &80,   0, &6a,   8, &80, &86
    equb &0e, &38,   0,   0,   0,   0,   0,   0,   0,   0,   0,   0
    equb   1,   1,   3, &11, &11,   1, &10, &10, &0c, &0e, &c8, &cc
    equb &88, &84, &0c, &0c,   0,   0,   0,   0,   0,   0,   0,   0
    equb   1,   1, &10,   1,   3, &43, &60,   0, &c4, &0c, &c0, &48
    equb &0e,   6,   6, &30,   0,   0,   0,   0,   0,   0,   0,   0
    equb   0,   0,   1,   0,   0,   0,   0,   0, &0e, &0f, &6c, &ee
    equb &cc, &4a, &4a, &4a,   0,   0,   0,   0,   0,   0,   0,   0
    equb   0,   0,   0,   0,   0,   0,   0,   0, &2e, &0e, &e0, &2c
    equb &0e, &0e, &0e, &f0,   0,   0,   0,   0,   0,   0,   0,   0
    equb   0,   0,   0,   0,   0,   0,   0, &10,   7,   7, &3e, &77
    equb &66, &25, &a5, &25,   0,   8,   0,   0,   0,   0,   0,   0
    equb &11,   0,   0,   0,   0, &10, &10,   0, &16,   7, &70, &16
    equb &0f, &0d, &81,   0, &88,   0,   0,   0,   8,   8,   8, &c0
; Human, facing left
.sprite_09
    equb   0,   1,   0,   0,   0,   0,   0,   0, &0e, &0e, &c7, &ee
    equb &66, &4a, &2c, &1e,   0,   0,   0,   0,   0,   0,   0,   0
    equb &32,   0,   0,   3,   3, &60,   0,   0, &6c, &0e, &e0, &86
    equb &0f, &0f,   0,   0,   0,   0,   0,   0, &80, &80, &80,   0
    equb   0,   0,   0,   0,   0,   0,   0,   0,   7, &0f, &63, &77
    equb &33, &25, &16, &16,   0,   0,   8,   0,   0,   0,   0,   0
    equb   0,   0,   0,   0,   0,   0,   0, &10, &65,   7, &70, &43
    equb &0f, &0d, &0c, &80,   0,   0,   0,   0,   8, &48, &c0,   0
    equb   0,   0,   0,   0,   0,   0,   0,   0,   3,   7, &31, &33
    equb &11, &12, &12, &12,   8,   8, &0c, &88, &88,   8,   8,   8
    equb   0,   0,   0,   0,   0,   0,   0,   0, &23,   3, &30, &21
    equb   3,   3,   3, &70,   8,   8, &80,   8,   8,   8,   8, &80
    equb   0,   0,   0,   0,   0,   0,   0,   0,   1,   3, &10, &11
    equb   0,   1,   1,   1, &0c, &0c, &8e, &cc, &cc, &84, &a4, &94
    equb   0,   0,   0,   0,   0,   0,   0,   0, &32,   1, &10, &10
    equb   3,   3,   3, &60, &1d, &0c, &c0, &0c, &0e, &16, &30,   0
; Gargoyle, facing right
.sprite_10
    equb   4, &0e,   7,   3,   7,   7, &1e, &16, &40, &80, &e0, &b4
    equb &a4, &f0, &c0, &c8,   0,   0,   0,   0,   0,   0,   0,   0
    equb &16, &16, &1e, &18, &10, &30, &20,   4, &c8, &c6, &c0, &e0
    equb &a0, &21,   0,   0,   0,   0,   0,   0,   0,   0,   0,   0
    equb   2,   3,   3,   1,   3,   3,   3,   1, &20, &40, &78, &5a
    equb &5a, &78, &e0, &e4,   0,   0,   0, &80,   0, &80,   0,   0
    equb   1,   1,   3,   2,   0,   0, &10,   1, &e4, &c6, &e0, &e0
    equb &f0, &f0, &90,   0,   0,   0,   0,   0,   0,   0,   8,   0
    equb   1,   0,   0,   0,   0,   0,   1,   0, &10, &28, &3c, &2d
    equb &25, &3c, &78, &72,   0,   0, &80, &c0, &c0, &80,   0,   0
    equb   0,   0,   0,   1,   0,   0,   0,   0, &7a, &7a, &2d, &34
    equb &30, &30, &30,   3,   0,   0,   0,   0,   0,   0,   0,   0
    equb   0,   0,   0,   0,   0,   0,   0,   0,   0, &14, &16, &12
    equb &16, &12, &30, &31, &80,   0, &c0, &68, &68, &c0, &80, &80
    equb   0,   0,   0,   0,   0,   0,   0,   0, &35, &35, &16, &16
    equb &30, &30, &60,   4, &80,   8, &80, &80, &80, &c0, &40,   4
; Gargoyle, facing left
.sprite_11
    equb &10,   0, &30, &61, &21, &70, &10, &10,   1, &83, &87, &86
    equb &87, &87, &c3, &cb,   0,   8,   0,   0,   0,   0,   8,   0
    equb &10, &13, &10, &30, &20, &24,   0,   0, &cb, &c3, &c3, &c0
    equb &c0, &60, &20,   1,   0,   0,   8,   8,   0,   0,   0,   0
    equb   0,   0, &10, &30, &10, &30,   0,   0, &80, &41, &c3, &4b
    equb &4b, &c3, &e1, &e5,   8,   8,   8,   0,   8,   8,   8,   0
    equb   0,   0,   0,   0, &10, &10, &12,   0, &e5, &6d, &e1, &e0
    equb &e0, &e0, &30,   1,   0,   0,   8,   8,   0,   0,   0,   0
    equb   0,   0,   0, &10, &10,   0,   0,   0, &40, &20, &e1, &a5
    equb &a5, &e1, &70, &72,   4,   8,   8,   8,   0,   8, &0c,   0
    equb   0,   0,   0,   0,   0,   0,   0,   0, &72, &72, &25, &61
    equb &60, &60, &60,   6,   8,   8,   8,   4,   0,   0,   0,   0
    equb   0,   0,   0,   0,   0,   0,   0,   0, &20, &10, &70, &d2
    equb &d2, &70, &30, &31,   0,   4, &0c,   8, &0c,   8, &80, &80
    equb   0,   0,   0,   0,   0,   0,   0,   0, &31, &13, &30, &30
    equb &30, &70, &40,   4, &84, &84, &0c, &0c, &80, &80, &c0,   4
; Harpy, facing right
.sprite_12
    equb   0,   0,   0,   0,   8, &7f, &ff, &ff,   0,   0,   0,   0
    equb &0e, &af, &0f, &0e,   0,   0,   0,   0,   0,   0,   8,   0
    equb &ef, &cc, &88,   0,   0,   0,   0,   0, &0c, &0c,   7,   2
    equb   0,   0,   0,   0,   0,   0,   0,   8,   0,   0,   0,   0
    equb   0,   0,   0,   0,   4, &37, &77, &77,   0,   0,   0,   0
    equb   7, &df, &8f, &0f,   0,   0,   0,   0,   0,   8, &0c,   0
    equb &44,   0,   0,   0,   0,   0,   0,   0, &0e,   6,   3,   1
    equb   0,   0,   0,   0,   0,   0,   8,   4,   0,   0,   0,   0
    equb   0, &22, &33, &33, &33, &13, &13,   1,   0,   0,   0, &88
    equb &cf, &ef, &cf, &0f,   0,   0,   0,   0,   8, &8c, &0e,   8
    equb   0,   0,   0,   0,   0,   0,   0,   0,   7,   3,   1,   0
    equb   0,   0,   0,   0,   0,   0, &0c, &0c,   0,   0,   0,   0
    equb   0,   0,   0,   0, &11,   1,   1,   0,   0,   0,   0,   0
    equb &ef, &ff, &6f, &0f,   0,   0,   0,   0, &0c, &4e, &0f, &0c
    equb   0,   0,   0,   0,   0,   0,   0,   0,   3,   1,   0,   0
    equb   0,   0,   0,   0,   8,   8, &0e,   6,   0,   0,   0,   0
; Harpy, facing left
.sprite_13
    equb   0,   0,   0,   0,   3, &27, &0f,   3,   0,   0,   0,   0
    equb   8, &ff, &7f, &7f,   0,   0,   0,   0,   8,   8, &88, &88
    equb   1,   1,   7, &0a,   0,   0,   0,   0, &3f, &19,   0,   0
    equb   0,   0,   0,   0, &88, &88, &88,   0,   0,   0,   0,   0
    equb   0,   0,   0,   0,   1, &13,   7,   1,   0,   0,   0,   0
    equb &0c, &7f, &3f, &1f,   0,   0,   0,   0,   4, &8c, &cc, &cc
    equb   0,   0,   3,   5,   0,   0,   0,   0, &0e, &0c,   8,   0
    equb   0,   0,   0,   0, &44,   0,   0,   0,   0,   0,   0,   0
    equb   0,   0,   0,   0,   0,   1,   3,   0,   0,   0,   0,   0
    equb &1f, &bf, &1f, &0f,   0, &22, &66, &ee, &ee, &ce, &ce, &0c
    equb   0,   0,   1,   1,   0,   0,   0,   0,   7,   6, &0c,   8
    equb   0,   0,   0,   0,   0,   0,   0,   0,   0,   0,   0,   0
    equb   0,   0,   0,   0,   0,   0,   1,   0,   0,   0,   0,   0
    equb   7, &5f, &0f,   7,   0,   0,   0,   0, &ff, &ef, &cf, &0e
    equb   0,   0,   0,   0,   0,   0,   0,   0,   3,   3, &0e, &0c
    equb   0,   0,   0,   0,   8,   0,   0,   0,   0,   0,   0,   0
; Winged creature
.sprite_14
    equb &10, &10,   1, &16,   7, &0f, &0d,   9, &40, &c0, &84, &c3
    equb &87, &0f, &0d, &0c,   0,   0,   0,   0,   0,   8,   8,   8
    equb   1,   3,   2,   3,   2,   0,   0,   0,   4,   6,   2,   6
    equb   2,   0,   0,   0,   0,   0,   0,   0,   0,   0,   0,   0
    equb   0,   0,   0,   7,   7,   1,   0,   0, &a0, &e0, &ea, &e1
    equb &4b, &0f, &0e, &0e,   0,   0,   0, &0c, &0c,   0,   0,   0
    equb   0,   1,   1,   1,   1,   0,   0,   0, &0a, &0b,   1,   9
    equb   3,   1,   0,   0,   0,   0,   0,   0,   0,   0,   0,   0
    equb   0,   2,   3,   3,   1,   0,   0,   0, &50, &70, &75, &78
    equb &2d, &0f,   7,   7,   0,   2,   6, &0e, &0c,   8,   0,   0
    equb   0,   0,   0,   0,   0,   0,   0,   0, &0d,   8, &0d,   8
    equb   0,   0,   0,   0,   8,   8,   8,   8,   0,   0,   0,   0
    equb   0,   0,   0,   1,   1,   0,   0,   0, &20, &30, &10, &3c
    equb &1e,   7,   3,   3, &80, &80,   0, &87, &0f, &0c,   8,   8
    equb   0,   0,   0,   0,   0,   0,   0,   0,   6,   4,   4,   6
    equb   4,   0,   0,   0, &0c,   4, &0c,   4,   0,   0,   0,   0
; Robot sentinel
.sprite_15
    equb   0, &33, &21, &77, &25, &ff, &88, &8b,   0, &ee, &a4, &ff
    equb &a4, &ff, &88, &8b,   0,   0,   0,   0,   0, &88, &88, &88
    equb &8b, &ff, &25, &77, &21, &33,   0,   0, &8b, &ff, &a5, &ff
    equb &a4, &ee,   0,   0, &88, &88,   0,   0,   0,   0,   0,   0
    equb   0, &11,   1, &33, &21, &77, &66, &66,   0, &ff, &a5, &ff
    equb &a5, &ff, &22, &2e,   0,   0,   0, &88, &80, &cc,   0, &0c
    equb &66, &77, &21, &33,   1, &11,   0,   0, &2e, &ff, &a5, &ff
    equb &a5, &ff,   0,   0, &0c, &cc, &80, &88,   0,   0,   0,   0
    equb   0,   0,   0, &11,   1, &33, &11, &13,   0, &ff, &a5, &ff
    equb &a5, &ff, &88, &8b,   0, &88, &80, &cc, &84, &ee, &88, &8a
    equb &13, &33,   1, &11,   0,   0,   0,   0, &8b, &ff, &a5, &ff
    equb &a5, &ff,   0,   0, &8a, &ee, &84, &cc, &80, &88,   0,   0
    equb   0,   0,   0,   0,   0, &11,   0,   0,   0, &77, &25, &ff
    equb &a5, &ff, &22, &2e,   0, &cc, &84, &ee, &a4, &ff, &33, &3f
    equb   0, &11,   0,   0,   0,   0,   0,   0, &2e, &ff, &a5, &ff
    equb &25, &77,   0,   0, &3f, &ff, &a4, &ee, &84, &cc,   0,   0
; Fleece/MacGuffin/unused/prism
.sprite_16
    equb   0,   0,   0,   0,   0,   0, &11, &22,   0,   0,   0,   0
    equb   0,   0, &44, &22,   0,   0,   0,   0,   0,   0,   0,   0
    equb &22, &33, &23, &23, &23, &33, &11, &11, &aa, &ee, &ae, &ae
    equb &ae, &ee, &4c, &cc,   0,   0,   0,   0,   0,   0,   0,   0
    equb   0,   0,   0,   0,   0,   0,   0, &33,   0,   0,   0,   0
    equb   0,   0,   0, &11,   0,   0,   0,   0,   0,   0,   0, &88
    equb &44, &11, &11, &11, &11,   0,   0,   0, &ee, &5f, &5f, &5f
    equb &bf, &ae, &ee, &44, &44,   0,   0,   0,   0,   0,   0,   0
    equb   0,   0,   0,   0,   0,   0,   0,   0,   0,   0,   0,   0
    equb   0,   0,   0, &33,   0,   0,   0,   0,   0,   0,   0,   0
    equb   0,   0,   0,   0,   0,   0,   0,   0, &65, &ad, &ad, &ad
    equb &ad, &ad, &65, &33, &88, &c4, &c4, &c4, &c4, &c4, &88,   0
    equb   0,   0,   0,   0,   0,   0,   0,   0,   0,   0,   0,   0
    equb   0,   0,   0,   0,   0,   0,   0,   0,   0,   0,   0,   0
    equb   0,   0,   0,   0,   0,   0,   0, &11, &11, &33, &23, &76
    equb &47, &fc, &8f, &ff,   0, &88, &88, &cc, &4c, &e6, &2e, &ff
; Health pickup
.sprite_17
    equb   0,   0, &11, &36, &35, &3c, &2c, &2c,   0,   0, &c4, &eb
    equb &e5, &e9, &a1, &a1,   0,   0,   0,   0,   0,   8,   8,   8
    equb &3c, &3c, &34, &16,   3, &10,   0,   0, &e1, &e1, &e1, &c3
    equb &86, &c0,   0,   0,   8,   8,   0,   0,   0,   0,   0,   0
    equb   0,   0,   0, &13, &12, &16, &16, &16,   0,   0, &ea, &f5
    equb &fa, &f4, &50, &50,   0,   0,   0,   8,   8, &0c, &0c, &0c
    equb &16, &16, &12,   3,   1,   0,   0,   0, &f0, &f0, &f0, &e1
    equb &4b, &e0,   0,   0, &0c, &0c,   8,   8,   0,   0,   0,   0
    equb   0,   0,   0,   1,   1,   3,   3,   3,   0,   0, &75, &fa
    equb &f5, &f2, &a0, &a0,   0,   0,   0, &8c, &84, &86, &86, &86
    equb   3,   3,   1,   1,   0,   0,   0,   0, &f0, &f0, &f0, &78
    equb &2d, &70,   0,   0, &86, &86, &84, &0c,   8,   0,   0,   0
    equb   0,   0,   0,   0,   0,   1,   1,   1,   0,   0, &32, &7d
    equb &7a, &79, &58, &58,   0,   0, &88, &c6, &ca, &c3, &43, &43
    equb   1,   1,   0,   0,   0,   0,   0,   0, &78, &78, &78, &3c
    equb &16, &30,   0,   0, &c3, &c3, &c2, &86, &0c, &80,   0,   0
; Veil of Ambiguity
.sprite_18
    equb   8,   8,   8, &0a,   2,   2,   2,   0, &0a, &0a, &0a,   8
    equb   8,   2,   2,   2,   0,   0,   0,   0,   0,   0,   0,   0
    equb   8,   8, &0a, &0a,   8,   8, &0a,   2, &0a, &0a, &0a, &0a
    equb   8,   8,   2,   2,   0,   0,   0,   0,   0,   0,   0,   0
    equb   2,   2,   2,   2,   0,   0,   0,   0,   2,   2,   2, &0a
    equb &0a,   8,   8,   0,   8,   8,   8,   0,   0,   8,   8,   8
    equb   2,   2,   2,   2,   2,   2,   2,   0,   2,   2, &0a, &0a
    equb   2,   2,   8,   8,   8,   8,   8,   8,   0,   0,   8,   8
    equb   0,   0,   0,   0,   0,   0,   0,   0,   8,   8,   8, &0a
    equb   2,   2,   2,   0, &0a, &0a, &0a,   8,   8,   2,   2,   2
    equb   0,   0,   0,   0,   0,   0,   0,   0,   8,   8, &0a, &0a
    equb   8,   8, &0a,   2, &0a, &0a, &0a, &0a,   8,   8,   2,   2
    equb   1,   1,   1,   0,   0,   1,   1,   1,   2,   2,   2,   2
    equb   0,   0,   0,   0,   2,   2,   2, &0a, &0a,   8,   8,   0
    equb   1,   1,   1,   1,   0,   0,   1,   1,   2,   2,   2,   2
    equb   2,   2,   2,   0,   2,   2, &0a, &0a,   2,   2,   8,   8
; Wall enemy, facing right
.sprite_19
    equb   0, &30, &61, &c3, &c3, &f0, &f1, &f1,   0, &c0, &48, &2c
    equb &2c, &3c, &f0, &71,   0,   0,   0,   0,   0,   0,   0,   0
    equb &e0, &e0, &c0, &e2, &f0, &f0, &f0, &70, &55,   0,   0, &99
    equb &b8, &f0, &e0, &e0,   0,   0,   0,   0,   0,   0,   0,   0
    equb   0, &10, &30, &61, &61, &70, &70, &70,   0, &e0, &2c, &1e
    equb &1e, &96, &f8, &b8,   0,   0,   0,   0,   0, &80, &80, &88
    equb &70, &70, &60, &71, &70, &70, &70, &30, &22,   0,   0, &44
    equb &d4, &f0, &f0, &f0, &88,   0,   0, &88, &80, &80,   0,   0
    equb   0,   0, &10, &30, &30, &30, &30, &30,   0, &f0, &96, &0f
    equb &0f, &c3, &f4, &d4,   0,   0,   0, &80, &80, &c0, &c0, &c4
    equb &30, &30, &30, &30, &30, &30, &30, &10, &91, &80,   0, &aa
    equb &e2, &f0, &f0, &f0, &44,   0,   0, &44, &c0, &c0, &80, &80
    equb   0,   0,   0, &10, &10, &10, &10, &10,   0, &70, &c3, &87
    equb &87, &e1, &f2, &e2,   0, &80, &80, &48, &48, &68, &e0, &e2
    equb &10, &10, &10, &10, &10, &10, &10,   0, &c0, &c0, &80, &d5
    equb &f1, &f0, &f0, &f0, &aa,   0,   0, &22, &60, &e0, &c0, &c0
; Wall enemy, facing left
.sprite_20
    equb   0, &10, &10, &21, &21, &61, &70, &74,   0, &e0, &3c, &1e
    equb &1e, &78, &f4, &74,   0,   0,   0, &80, &80, &80, &80, &80
    equb &55,   0,   0, &44, &60, &70, &30, &30, &30, &30, &10, &ba
    equb &f8, &f0, &f0, &f0, &80, &80, &80, &80, &80, &80, &80,   0
    equb   0,   0,   0, &10, &10, &30, &30, &32,   0, &f0, &96, &0f
    equb &0f, &3c, &f2, &b2,   0,   0, &80, &c0, &c0, &c0, &c0, &c0
    equb &22,   0,   0, &22, &30, &30, &10, &10, &98, &10,   0, &55
    equb &74, &f0, &f0, &f0, &c0, &c0, &c0, &c0, &c0, &c0, &c0, &80
    equb   0,   0,   0,   0,   0, &10, &10, &11,   0, &70, &43, &87
    equb &87, &96, &f1, &d1,   0, &80, &c0, &68, &68, &e0, &e0, &e0
    equb &11,   0,   0, &11, &10, &10,   0,   0, &44,   0,   0, &22
    equb &b2, &f0, &f0, &f0, &e0, &e0, &60, &e8, &e0, &e0, &e0, &c0
    equb   0,   0,   0,   0,   0,   0,   0,   0,   0, &30, &21, &43
    equb &43, &c3, &f0, &e8,   0, &c0, &68, &3c, &3c, &f0, &f8, &f8
    equb   0,   0,   0,   0,   0,   0,   0,   0, &aa,   0,   0, &99
    equb &d1, &f0, &70, &70, &70, &70, &30, &74, &f0, &f0, &f0, &e0
; Eye enemy
.sprite_21
    equb   0,   0, &10, &51, &73, &67, &cf, &8f,   0,   0, &40, &dc
    equb &fe, &3f, &1f, &8f,   0,   0,   0,   0,   0,   0, &88, &88
    equb &8f, &cf, &67, &73, &51, &10,   0,   0, &8f, &1f, &3f, &fe
    equb &dc, &40,   0,   0, &88, &88,   0,   0,   0,   0,   0,   0
    equb   0,   0,   0,   0, &31, &33, &67, &47,   0,   0,   0, &ee
    equb &f5, &ff, &0f, &4f,   0,   0,   0,   0, &80, &88, &cc, &4c
    equb &47, &67, &33, &31, &20,   0,   0,   0, &4f, &0f, &1f, &ff
    equb &ee, &a0,   0,   0, &4c, &cc, &88, &80, &80,   0,   0,   0
    equb   0,   0,   0,   0,   0, &11, &33, &32,   0,   0,   0, &77
    equb &ff, &ff, &fa, &fa,   0,   0,   0,   0, &88, &cc, &ee, &ea
    equb &23, &33, &11, &10, &10,   0,   0,   0, &2f, &0f, &8f, &ff
    equb &77, &50,   0,   0, &2e, &6e, &cc, &c8, &40,   0,   0,   0
    equb   0,   0,   0,   0,   0,   0, &11, &11,   0,   0,   0, &33
    equb &77, &ff, &ff, &ff,   0,   0,   0, &88, &cc, &ee, &ff, &ff
    equb &11, &11,   0,   0,   0,   0,   0,   0, &ff, &ff, &f7, &f5
    equb &b1, &20,   0,   0, &ff, &ff, &ec, &e4, &a0, &80,   0,   0
; Statue
.sprite_22
    equb   5,   9, &19, &0d, &0e, &0f, &0f, &0f,   5,   4, &4c, &0d
    equb &0b,   7, &0f, &0f,   0,   8,   8,   8,   8,   8,   8,   8
    equb &0f, &0f, &3c, &1c, &1c, &18, &14, &30, &0f, &0f, &e1, &41
    equb &41, &40, &41, &e0,   8,   8,   8,   8,   8,   8,   0,   0
    equb   2,   4,   4,   6,   7,   7,   7,   7, &0a, &0a, &ae, &0e
    equb   5, &0b, &0f, &0f,   8,   4,   4, &0c, &0c, &0c, &0c, &0c
    equb   7,   7, &16,   6,   6,   4,   2, &10, &0f, &0f, &f0, &a0
    equb &a0, &a0, &a0, &f0, &0c, &0c, &0c, &0c, &0c,   4,   8,   0
    equb   1,   2,   2,   3,   3,   3,   3,   3,   5,   5, &57,   7
    equb &0a, &0d, &0f, &0f,   4,   2,   2,   6, &0e, &0e, &0e, &0e
    equb   3,   3,   3,   3,   3,   2,   1,   0, &0f, &0f, &f0, &50
    equb &50, &50, &50, &f0, &0e, &0e, &86,   6,   6,   2,   4, &80
    equb   0,   1,   1,   1,   1,   1,   1,   1, &0a,   2, &23, &0b
    equb &0d, &0e, &0f, &0f, &0a,   9, &89, &0b,   7, &0f, &0f, &0f
    equb   1,   1,   1,   1,   1,   1,   0,   0, &0f, &0f, &78, &28
    equb &28, &20, &28, &70, &0f, &0f, &c3, &83, &83, &81, &82, &c0
; Sun
.sprite_23
    equb &10, &30, &21, &70, &70, &b4, &f0, &b4, &c0, &e0, &e0, &f0
    equb &f0, &f0, &f0, &f0,   0,   0,   0,   0,   0, &80, &80, &80
    equb &b4, &f0, &d2, &52, &52, &30, &30, &10, &f0, &f0, &f0, &f0
    equb &f0, &68, &e0, &c0, &80, &80, &80,   0,   0,   0,   0,   0
    equb   0, &10, &10, &30, &30, &70, &70, &70, &e0, &f0, &78, &f0
    equb &f0, &78, &f0, &78,   0,   0,   0, &80, &80, &c0, &c0, &c0
    equb &70, &70, &70, &30, &30, &10, &10,   0, &78, &f0, &b4, &b4
    equb &b4, &b4, &f0, &e0, &c0, &c0, &c0, &80, &80,   0,   0,   0
    equb   0,   0,   0, &10, &10, &30, &30, &30, &70, &f0, &d2, &f0
    equb &f0, &e1, &f0, &e1,   0, &80, &80, &c0, &c0, &e0, &e0, &e0
    equb &30, &30, &30, &10, &10,   0,   0,   0, &e1, &f0, &e1, &e1
    equb &e1, &d2, &f0, &70, &e0, &e0, &e0, &c0, &c0, &80, &80,   0
    equb   0,   0,   0,   0,   0, &10, &10, &10, &30, &70, &61, &f0
    equb &f0, &f0, &f0, &f0, &80, &c0, &c0, &e0, &e0, &b4, &f0, &d2
    equb &10, &10, &10,   0,   0,   0,   0,   0, &f0, &f0, &f0, &f0
    equb &f0, &61, &70, &30, &d2, &f0, &b4, &a4, &68, &c0, &c0, &80
; Moon
.sprite_24
    equb   0, &11, &33, &77, &77, &dd, &ff, &ff,   0, &cc, &ee, &77
    equb &77, &ff, &dd, &dd,   0,   0,   0,   0,   0, &88, &88, &88
    equb &dd, &dd, &ff, &77, &77, &33, &11,   0, &ff, &ff, &77, &77
    equb &ff, &ee, &cc,   0, &88, &88, &88,   0,   0,   0,   0,   0
    equb   0,   0, &11, &33, &33, &77, &66, &77,   0, &ee, &ff, &ee
    equb &aa, &ff, &ff, &ff,   0,   0,   0, &88, &88, &cc, &cc, &cc
    equb &77, &77, &66, &22, &33, &11,   0,   0, &bb, &bb, &ee, &ee
    equb &ff, &ff, &ee,   0, &cc, &cc, &cc, &88, &88,   0,   0,   0
    equb   0,   0,   0, &11, &11, &33, &33, &33,   0, &77, &ff, &ff
    equb &77, &ff, &dd, &ff,   0,   0, &88, &cc, &44, &ee, &ee, &ee
    equb &33, &33, &33, &11, &11,   0,   0,   0, &77, &77, &dd, &dd
    equb &ff, &ff, &77,   0, &66, &66, &ee, &cc, &cc, &88,   0,   0
    equb   0,   0,   0,   0,   0, &11, &11, &11,   0, &33, &77, &ff
    equb &ee, &ff, &ff, &ff,   0, &88, &cc, &ee, &ee, &ff, &bb, &ff
    equb &11, &11, &11,   0,   0,   0,   0,   0, &ee, &66, &ff, &ff
    equb &ff, &77, &33,   0, &ff, &ff, &bb, &aa, &ee, &cc, &88,   0
; Veil of More Ambiguity
.sprite_25
    equb &ff, &df, &df, &ca, &ca, &ca, &ca, &ca, &6d, &65, &65, &65
    equb &65, &65, &65, &65,   0,   0,   0,   0,   0,   0,   0,   0
    equb &ca, &ca, &ca, &ca, &ca, &df, &df, &ff, &65, &65, &65, &65
    equb &67, &67, &77, &7f,   0,   0,   0,   0,   0, &88, &88, &88
    equb &15, &15, &15, &15, &15, &15, &15, &15, &ef, &ae, &ae, &84
    equb &84, &84, &84, &84, &c8, &c8, &c8, &c8, &c8, &c8, &c8, &c8
    equb &15, &15, &15, &15, &15, &37, &77, &77, &84, &84, &84, &84
    equb &84, &ae, &ae, &ef, &c8, &c8, &c8, &c8, &cc, &cc, &cc, &cc
    equb &32, &32, &32, &32, &32, &32, &32, &32, &3b, &3b, &3b, &3a
    equb &3a, &3a, &3a, &3a, &ce, &4c, &4c,   8,   8,   8,   8,   8
    equb &32, &32, &32, &32, &33, &33, &33, &33, &3a, &3a, &3a, &3a
    equb &3a, &7f, &ff, &ff,   8,   8,   8,   8,   8, &4c, &4c, &ce
    equb &11, &11, &11,   0,   0,   0,   0,   0, &6d, &65, &65, &65
    equb &65, &65, &65, &65, &77, &67, &67, &65, &65, &65, &65, &65
    equb   0,   0,   0,   0,   0, &11, &11, &11, &65, &65, &65, &65
    equb &67, &67, &77, &7f, &65, &65, &65, &65, &65, &ef, &ef, &ff

; ENHANCE: This appears to be mode 5 graphics data showing '< 1 > Load ' (just
; *LOAD World1c 5800 to see this), so this is almost certainly junk/a build
; artefact/spare space.
    equb   0,   0,   0,   0,   0,   0,   0,   0,   0,   0,   0,   0
    equb   0,   0,   0,   0,   0, &11
    equs "3f3"
    equb &11,   0,   0, &cc, &88,   0,   0,   0, &88, &cc,   0,   0
    equb   0,   0,   0,   0,   0,   0,   0,   0,   0,   0,   0,   0
    equb   0,   0,   0, &11, &33, &11, &11, &11, &11, &77,   0, &88
    equb &88, &88, &88, &88, &88, &ee,   0,   0,   0,   0,   0,   0
    equb   0,   0,   0,   0,   0,   0,   0,   0,   0,   0,   0, &33
    equb &11,   0,   0,   0, &11, &33,   0,   0, &88, &cc, &66, &cc
    equb &88,   0,   0,   0,   0,   0,   0,   0,   0,   0,   0,   0
    equb   0,   0,   0,   0,   0,   0,   0
    equs "``````p"
    equb   0,   0,   0,   0,   0,   0,   0, &e0,   0,   0,   0
    equs "0```0"
    equb   0,   0,   0, &c0
    equs "```"
    equb &c0,   0,   0,   0, &30,   0
    equs "0`0"
    equb   0,   0,   0, &c0, &60, &e0, &60, &e0,   0,   0,   0
    equs "0```0"
    equb   0, &60, &60, &e0
    equs "```"
    equb &e0,   0,   0,   0,   0,   0,   0,   0,   0,   0,   0,   0
    equb   0,   0,   0,   0,   0,   0

; Based on how this is called by world-2.bas, I infer that it is a
; collision detection subroutine which returns with X% indicating what
; was collided with, or 0 if nothing. The code here appears to return
; values in Y% and Z% but I don't think they are used by the game. W%
; on entry is probably the sprite we are checking for collisions with;
; world-2.bas always sets it to the current player sprite. Y% on entry
; is the maximum 1-based sprite slot to check for collisions;
; world-2.bas always sets it to 8.
.q_subroutine
    lda ri_w
    beq q_subroutine_no_collision_found
    cmp #max_sprite_num+1
    bcs q_subroutine_no_collision_found
    sec
    sbc #1
    asl a
    tax
    asl a
    tay
; We have X=(W%-1)*2, Y=(W%-1)*4. X retains this value for the entire
; subroutine. Y's value is only used if the beq
; q_subroutine_next_candidate branch is taken on the first pass round
; q_subroutine_y_loop.
    lda sprite_screen_and_data_addrs+screen_addr_hi,y
    beq q_subroutine_no_collision_found
    stx q_subroutine_sprite_to_check_x2
    lda ri_y
    beq q_subroutine_no_collision_found
    cmp #max_sprite_num+1
    bcs q_subroutine_no_collision_found
    sec
    sbc #1
    asl a
    sta q_subroutine_max_candidate_sprite_x2
    lda #0
; Don't test for collision of W% with itself!
; TODO: If W%=1 on entry, the first pass round the q_subroutine_y_loop
; will take the beq, but Y doesn't yet contain the loop variable
; (because of our shuffling in and out of A). As it happens, we will
; get away with this because Y will be (W%-1)*4=0, so it does
; effectively contain the loop variable 'by chance'. This isn't a big
; deal, but I'm noting it as may want to double-check this
; understanding before trying to avoid the Y-A shuffle. Actually I
; think there is another bug here, if (say) W%=3 and Y%=4 on entry,
; the loop will get stuck with A=4 and Y=2, because the increment of Y
; will never happen because of the Y-A shuffle. As long as W%>Y% on
; entry - which it is in the game - this can't happen.
; TODO: I suspect we could avoid shuffling Y into A and just do
; iny:iny and change some cmp to cpy
.q_subroutine_y_loop
    cmp q_subroutine_sprite_to_check_x2
    beq q_subroutine_next_candidate
    tay
    lda #5
    sta l0074
    lda sprite_pixel_coord_table_xy,x
    sec
    sbc sprite_pixel_coord_table_xy,y
; TODO: Isn't this BMI unreliable? What if we did 0-140=-140=116, for
; example? Or 150-0? Wouldn't the correct test be BCC? In practice
; this works fine for values in the range 0-159 inclusive; I wrote a
; program to test all cases, but I have some vague flickering in my
; brain that says this is semi-obvious if you think about it. I think
; it might still be true the state of the carry when we're negating is
; sometimes wrong, but maybe it's not, and at worst it will cause an
; extra pixel of 'fuzz' in the collision detection.
    bmi q_subroutine_sprite_to_check_x_lt_candidate_x
    beq q_subroutine_test_abs_x_difference
; sprite to check's X co-ordinate is >= candidate sprite's X co-
; ordinate.
    dec l0074
.q_subroutine_test_abs_x_difference
    cmp #9
    bcs q_subroutine_next_candidate
; abs(sprite_to_check.x - candidate_sprite.x) < 9 (TODO: subject to
; concerns about bugs in other TODOs), so we consider the sprites to
; be overlapping in X and we need to check Y.
    sta q_subroutine_abs_x_difference
; TODO: same concerns as for X about this not working for some values.
    lda sprite_pixel_coord_table_xy+1,x
    sec
    sbc sprite_pixel_coord_table_xy+1,y
    bmi q_subroutine_sprite_to_check_y_lt_candidate_y
    beq q_subroutine_test_abs_y_difference
; sprite_pixel_coord_table_xy+1,x > sprite_pixel_coord_table_xy+1,y
; (TODO: assuming unsigned)
    inc l0074
    inc l0074
    inc l0074
.q_subroutine_test_abs_y_difference
    cmp #&10
    bcs q_subroutine_next_candidate
; abs(sprite_to_check.y - candidate_sprite.y) < 16 (TODO: subject to
; concerns about bugs), so these two sprites overlap and we're done.
    sta q_subroutine_abs_y_difference
    bcc q_subroutine_q_subroutine_collision_found                     ; always branch
.q_subroutine_next_candidate
    cpy q_subroutine_max_candidate_sprite_x2
    beq q_subroutine_no_collision_found
    tya
    adc #2
    bne q_subroutine_y_loop                                           ; always branch
; Set X% and Y% to 0 to indicate no collision found.
.q_subroutine_no_collision_found
    lda #0
    sta ri_x
    sta ri_y
    rts

; Set A=-A
.q_subroutine_sprite_to_check_x_lt_candidate_x
    eor #&ff
; TODO: As written, don't we need a clc here? I am not convinced C
; will always be implicitly clear (e.g. if we did 150-0 at &4f31 - N
; would be set, but there's no borrow so C will still be set).
    adc #1
    inc l0074
    bne q_subroutine_test_abs_x_difference                            ; always branch
; Set A=-A (TODO: same 'clc needed' concern as for X)
.q_subroutine_sprite_to_check_y_lt_candidate_y
    eor #&ff
    adc #1
    dec l0074
    dec l0074
    dec l0074
    bne q_subroutine_test_abs_y_difference                            ; always branch
; Set Y% to 35-(abs_x_difference*2)-abs_y_difference, so (roughly) Y%
; indicates how much the sprites are overlapping - it will range from
; 4 if both differences are as large as possible up to 35 if the two
; sprites coincide perfectly. world-2.bas doesn't seem to use this.
.q_subroutine_q_subroutine_collision_found
    lda q_subroutine_abs_x_difference
    asl a
    adc q_subroutine_abs_y_difference
    sta l0073
    lda #&23 ; '#'
    sec
    sbc l0073
    sta ri_y
; Set Z% to TODO: some number indicating something about the
; collision. world-2.bas doesn't appear to use this, although I'm not
; currently absolutely certain of this.
    lda l0074
    sta ri_z
; Set X% to the 1-based logical sprite number we found a collision
; with.
    iny
    iny
    tya
    lsr a
    sta ri_x
.q_subroutine_rts
    rts

; TODO: Dead code?
.r_subroutine
    lda ri_x
    cmp #4
    bcs q_subroutine_rts
    ldx #5
    stx l0075
    ldy #&ff
    ldx r_subroutine_inkey_code_1
    lda #osbyte_inkey
    jsr osbyte
    cpy #&1b
    beq c5002
    inx
    bne c4fbd
    inc l0075
.c4fbd
    lda #osbyte_inkey
    ldx r_subroutine_inkey_code_2
    ldy #&ff
    jsr osbyte
    cpy #&1b
    beq c5002
    inx
    bne c4fd0
    dec l0075
.c4fd0
    lda ri_x
    lsr a
    beq c4fdc
    lda l0075
    cmp #5
    bne c501f
.c4fdc
    lda #osbyte_inkey
    ldx r_subroutine_inkey_code_3
    ldy #&ff
    jsr osbyte
    cpy #&1b
    beq c5002
    inx
    bne c4ff4
    lda l0075
    sec
    sbc #3
    sta l0075
.c4ff4
    lda #osbyte_inkey
    ldx r_subroutine_inkey_code_4
    ldy #&ff
    jsr osbyte
    cpy #&1b
    bne c5008
.c5002
    lda #osbyte_clear_escape
    jsr osbyte
    rts

.c5008
    inx
    bne c5012
    lda l0075
    clc
    adc #3
    sta l0075
.c5012
    lda ri_x
    and #1
    bne c502b
    lda l0075
    cmp #5
    beq c5026
.c501f
    sta r_subroutine_foo
    sta ri_z
.s_subroutine_rts
    rts

; TODO: Dead code?
.c5026
    lda r_subroutine_foo
    bne c501f
.c502b
    lda l0075
    bne c501f
.clc_remove_sprite_from_screen
    clc
    jmp remove_sprite_from_screen

; Entered with a sprite slot number in W%.
; 
; If Y%=2 or slot W% has invalid coordinates, if the sprite is on on
; screen and is eor-plotted to remove it and
; sprite_screen_and_data_addrs updated to reflect this. This is a no-
; op if the sprite is not on screen.
; 
; If Y% is not 2, the sprite is eor-plotted at its new position and
; sprite_screen_and_data_addrs updated to reflect this. If Y% is also
; not 1, the sprite is eor-plotted at its old position.
; 
; Effectively Y%=1 means 'show sprite', Y%=0 means 'move sprite' and
; Y%=2 means 'remove sprite'.
.s_subroutine
    lda ri_w
    beq s_subroutine_rts
    cmp #&31 ; '1'
    bcs s_subroutine_rts
    sec
    sbc #1
    ldx ri_y
    cpx #2
    beq clc_remove_sprite_from_screen
    jsr get_sprite_details
    lda sprite_pixel_coord_table_xy,x
    cmp #&fe
    bcs clc_remove_sprite_from_screen
    lda sprite_pixel_coord_table_xy+1,x
    cmp #2
    bcc clc_remove_sprite_from_screen
    lda sprite_pixel_y_lo
    tax
    lsr a
    lsr a
    and #&fe
    tay
    txa
    and #7
    eor #7
    sta sprite_y_offset_within_row
    lda screen_y_addr_table,y
    clc
    adc sprite_y_offset_within_row
    sta screen_ptr
    lda screen_y_addr_table+1,y
    adc #0
    sta screen_ptr+1
    lda #0
    sta l0073
    lda sprite_pixel_x_lo
    asl a
    rol l0073
    and #&f8
    adc screen_ptr
    sta screen_ptr
    lda screen_ptr+1
    adc l0073
    sta screen_ptr+1
    ldx l0074
    lda sprite_screen_and_data_addrs+screen_addr_lo,x
    sta screen_ptr2
    lda sprite_screen_and_data_addrs+screen_addr_hi,x
    sta screen_ptr2+1
    lda screen_ptr
    sta sprite_screen_and_data_addrs+screen_addr_lo,x
    lda screen_ptr+1
    sta sprite_screen_and_data_addrs+screen_addr_hi,x
    lda sprite_pixel_x_lo
    and #3
    asl a
    asl a
    asl a
    asl a
    sta l0073
    asl a
    adc l0073
    adc sprite_screen_and_data_addrs+sprite_addr_lo,x
    sta l0070
    lda sprite_screen_and_data_addrs+sprite_addr_hi,x
    adc #0
    sta l0071
    lda ri_y
    cmp #1
    beq clc_jmp_sprite_core
    lda screen_ptr2+1
    beq clc_jmp_sprite_core
    lda l0072
    and #3
    asl a
    asl a
    asl a
    asl a
    sta l0073
    asl a
    adc l0073
    adc sprite_screen_and_data_addrs+sprite_addr_lo,x
    sta sprite_ptr2
    lda sprite_screen_and_data_addrs+sprite_addr_hi,x
    adc #0
    sta sprite_ptr2+1
    clc
    jmp sprite_core_moving

.clc_jmp_sprite_core
    clc
    jmp sprite_core

.remove_sprite_from_screen
    asl a
    tay
    asl a
    tax
    lda sprite_screen_and_data_addrs+screen_addr_lo,x
    sta screen_ptr
    lda sprite_screen_and_data_addrs+screen_addr_hi,x
    beq s_subroutine_rts2
    sta screen_ptr+1
    lda sprite_pixel_coord_table_xy,y
    and #3
    asl a
    asl a
    asl a
    asl a
    sta l0073
    asl a
    adc l0073
    adc sprite_screen_and_data_addrs+sprite_addr_lo,x
    sta l0070
    lda sprite_screen_and_data_addrs+sprite_addr_hi,x
    adc #0
    sta l0071
    lda #0
    sta sprite_screen_and_data_addrs+screen_addr_lo,x
    sta sprite_screen_and_data_addrs+screen_addr_hi,x
    clc
    jmp sprite_core

.s_subroutine_rts2
    rts

; Entered with A=W%-1; 0<=A<=&2F
; TODO: After the initial shifts, we have set Y=A*8 and then anded it
; with &38=%00111000. We then use Y as an offset from ri_a, so we are
; effectively addressing A% (A=0/Y=0), C% (A=1/Y=8), E% (A=2/Y=16),
; ... here. Similarly, the offset from ri_b will address the next
; resident integer variable, i.e. B% if A=0/Y=0, D% if A=1/Y=8, etc.
;     W%=&01 => A=&00 => Y=&00 => A%
;     W%=&02 => A=&01 => Y=&08 => C%
;     W%=&03 => A=&02 => Y=&10 => E%
;     W%=&04 => A=&03 => Y=&18 => G%
;     W%=&05 => A=&04 => Y=&20 => I%
;     W%=&06 => A=&05 => Y=&28 => K%
;     W%=&07 => A=&06 => Y=&30 => M%
;     W%=&08 => A=&07 => Y=&38 => O%
;     W%=&09 => A=&08 => Y=&00 => A%
;     W%=&0A => A=&09 => Y=&08 => C%
;     W%=&0B => A=&0A => Y=&10 => E%
;     W%=&0C => A=&0B => Y=&18 => G%
;     W%=&0D => A=&0C => Y=&20 => I%
;     W%=&0E => A=&0D => Y=&28 => K%
;     W%=&0F => A=&0E => Y=&30 => M%
;     W%=&10 => A=&0F => Y=&38 => O%
;     W%=&11 => A=&10 => Y=&00 => A%
;     W%=&12 => A=&11 => Y=&08 => C%
;     W%=&13 => A=&12 => Y=&10 => E%
;     W%=&14 => A=&13 => Y=&18 => G%
;     W%=&15 => A=&14 => Y=&20 => I%
;     W%=&16 => A=&15 => Y=&28 => K%
;     W%=&17 => A=&16 => Y=&30 => M%
;     W%=&18 => A=&17 => Y=&38 => O%
;     W%=&19 => A=&18 => Y=&00 => A%
;     W%=&1A => A=&19 => Y=&08 => C%
;     W%=&1B => A=&1A => Y=&10 => E%
;     W%=&1C => A=&1B => Y=&18 => G%
;     W%=&1D => A=&1C => Y=&20 => I%
;     W%=&1E => A=&1D => Y=&28 => K%
;     W%=&1F => A=&1E => Y=&30 => M%
;     W%=&20 => A=&1F => Y=&38 => O%
;     W%=&21 => A=&20 => Y=&00 => A%
;     W%=&22 => A=&21 => Y=&08 => C%
;     W%=&23 => A=&22 => Y=&10 => E%
;     W%=&24 => A=&23 => Y=&18 => G%
;     W%=&25 => A=&24 => Y=&20 => I%
;     W%=&26 => A=&25 => Y=&28 => K%
;     W%=&27 => A=&26 => Y=&30 => M%
;     W%=&28 => A=&27 => Y=&38 => O%
;     W%=&29 => A=&28 => Y=&00 => A%
;     W%=&2A => A=&29 => Y=&08 => C%
;     W%=&2B => A=&2A => Y=&10 => E%
;     W%=&2C => A=&2B => Y=&18 => G%
;     W%=&2D => A=&2C => Y=&20 => I%
;     W%=&2E => A=&2D => Y=&28 => K%
;     W%=&2F => A=&2E => Y=&30 => M%
;     W%=&30 => A=&2F => Y=&38 => O%
.get_sprite_details
    sta get_sprite_details_sprite_index
    asl a
    tax
; TODO: Is the value written to &7D ever used?
    sta l007d
    asl a
    sta l0074
    asl a
    and #&38 ; '8'
    tay
; TODO: I don't think the value written to l0075 here is ever used?
    sty l0075
; Set l0076 (low) and l0078 (high) to the first resident integer
; variable for this sprite divided by 8, which converts from OS
; coordinates (0-1279) to pixel coordinates (0-159). Similarly, divide
; the second resident integer variable by 4 to get Y pixel coordinates
; (0-255) at l0077 (low) and l0079 (high).
    lda ri_a+1,y
    sta sprite_pixel_x_hi
    lda ri_a,y
    lsr sprite_pixel_x_hi
    ror a
    lsr sprite_pixel_x_hi
    ror a
    lsr sprite_pixel_x_hi
    ror a
    sta sprite_pixel_x_lo
    lda ri_b+1,y
    sta sprite_pixel_y_hi
    lda ri_b,y
    lsr sprite_pixel_y_hi
    ror a
    lsr sprite_pixel_y_hi
    ror a
    sta sprite_pixel_y_lo
    ldy get_sprite_details_sprite_index
    lda sprite_pixel_coord_table_xy,x
    sta sprite_pixel_current_x
    lda sprite_pixel_coord_table_xy+1,x
    sta sprite_pixel_current_y
; TODO: Won't sprite_pixel_x_hi always be 0, since if it's on-screen
; it will have been reduced to the range 0-159 after dividing by 8?
    lda sprite_pixel_x_hi
    beq sprite_pixel_x_hi_zero
    cmp #&80
    bcc sprite_x_position_too_far_right
    bcs sprite_x_position_too_far_left
.sprite_check_y_position
    lda sprite_pixel_y_hi
    beq sprite_pixel_y_hi_zero
; TODO: cmp #&80 redundant? we just did LDA which will have set N so
; we can use beq/bne instead
    cmp #&80
    bcc sprite_y_position_too_far_up
    bcs sprite_y_position_too_far_down
.sprite_pixel_x_hi_zero
    lda sprite_pixel_x_lo
    cmp constant_2
    bcc sprite_x_position_too_far_left
    cmp constant_96
    beq sprite_x_position_ok
    bcs sprite_x_position_too_far_right
.sprite_x_position_ok
    sta sprite_pixel_coord_table_xy,x
    clc
    bcc sprite_check_y_position                                       ; always branch
.sprite_x_position_too_far_right
    lda constant_1_per_sprite_table,y
    beq force_sprite_x_position_to_rhs
    cmp #1
    beq force_sprite_x_position_to_lhs
    lda #&ff
    sta sprite_pixel_coord_table_xy,x
    bne sprite_check_y_position                                       ; always branch
.force_sprite_x_position_to_rhs
    lda constant_96
    sta sprite_pixel_coord_table_xy,x
    sta sprite_pixel_x_lo
; TODO: I believe this is effectively a jmp and nothing cares about
; the fact we've cleared carry.
    clc
    bcc sprite_check_y_position
.sprite_x_position_too_far_left
    lda constant_1_per_sprite_table,y                                 ; always branch
    beq force_sprite_x_position_to_lhs
    cmp #1
    beq force_sprite_x_position_to_rhs
    lda #&fe
    sta sprite_pixel_coord_table_xy,x
    bne sprite_check_y_position                                       ; always branch
.force_sprite_x_position_to_lhs
    lda constant_2
    sta sprite_pixel_coord_table_xy,x
    sta sprite_pixel_x_lo
    clc
    bcc sprite_check_y_position
.sprite_pixel_y_hi_zero
    lda sprite_pixel_y_lo
    cmp sprite_y_min
    bcc sprite_y_position_too_far_down
    cmp sprite_y_max
    beq sprite_y_position_adjusted
    bcs sprite_y_position_too_far_up
.sprite_y_position_adjusted
    sta sprite_pixel_coord_table_xy+1,x
    clc
    rts

.sprite_y_position_too_far_up
    lda constant_1_per_sprite_table,y
    beq force_sprite_y_position_to_constant_fe
    cmp #1
    beq force_sprite_y_position_to_constant_10
    lda #0
    sta sprite_pixel_coord_table_xy+1,x
    clc
    rts

.force_sprite_y_position_to_constant_fe
    lda sprite_y_max
    sta sprite_pixel_coord_table_xy+1,x
    sta sprite_pixel_y_lo
    clc
    rts

.sprite_y_position_too_far_down
    lda constant_1_per_sprite_table,y
    beq force_sprite_y_position_to_constant_10
    cmp #1
    beq force_sprite_y_position_to_constant_fe
    lda #1
    sta sprite_pixel_coord_table_xy+1,x
    clc
    rts

.force_sprite_y_position_to_constant_10
    lda sprite_y_min
    sta sprite_pixel_coord_table_xy+1,x
    sta sprite_pixel_y_lo
    clc
    rts

; Sprite plot routine. EORs a 3-byte (12 pixel) wide sprite onto the
; screen, writing data starting at the address pointed to by
; screen_ptr and taking sprite data from the address pointed to by
; sprite_ptr. There's provision for wrapping around onto next screen
; character row as required and I think in principle sprites can be
; arbitrarily many screen character rows tall; it looks as though
; l0075 is used to control this, although in practice it is probably
; always 1 as I can't see any entry point which would change this.
; (The caller will have adjusted the start screen address to allow for
; arbitrary Y pixel positioning; the sprite data itself is not
; adjusted - I think this is obvious really but it confused me for a
; while.)
; 
; There seems to be a slightly odd desire to keep carry clear all the
; time instead of just clearing it before we need it to be clear, but
; I may be missing something.
.sprite_core
    lda #1
    sta l0075
.sprite_core_outer_loop
    ldx #8
.sprite_core_inner_loop
    ldy #0
    lda (screen_ptr),y
    eor (sprite_ptr),y
    sta (screen_ptr),y
    ldy #8
    lda (screen_ptr),y
    eor (sprite_ptr),y
    sta (screen_ptr),y
    ldy #&10
    lda (screen_ptr),y
    eor (sprite_ptr),y
    sta (screen_ptr),y
    lda screen_ptr
    and #7
    eor #7
    beq sprite_core_next_row
    inc screen_ptr
.sprite_core_screen_ptr_updated
    inc sprite_ptr
    beq sprite_core_low_byte_wrapped
.sprite_core_low_byte_wrap_handled
    dex
    bne sprite_core_inner_loop
    lda sprite_ptr
    adc #&10
    sta sprite_ptr
    bcc sprite_core_no_carry
    inc sprite_ptr+1
    clc
.sprite_core_no_carry
    dec l0075
    beq sprite_core_outer_loop
    rts

.sprite_core_next_row
    lda screen_ptr
    adc #<(bytes_per_screen_line-7)
    sta screen_ptr
    lda screen_ptr+1
    adc #1
    sta screen_ptr+1
    bne sprite_core_screen_ptr_updated                                ; always branch
.sprite_core_low_byte_wrapped
    inc sprite_ptr+1
    clc
    bne sprite_core_low_byte_wrap_handled                             ; always branch

; TODO: This looks like an 'alternate version' of sprite_core? I
; haven't been over the code properly yet, but I suspect it is a
; 'erase at old location, replot immediately at new location' variant,
; to handle moving sprites more efficiently.
.sprite_core_moving
    lda #1
    sta l0075
    sei
.sprite_core_moving_outer_loop
    ldx #8
.sprite_core_moving_inner_loop
    ldy #0
    lda (screen_ptr2),y
    eor (sprite_ptr2),y
    sta (screen_ptr2),y
    lda (screen_ptr),y
    eor (sprite_ptr),y
    sta (screen_ptr),y
    ldy #8
    lda (screen_ptr2),y
    eor (sprite_ptr2),y
    sta (screen_ptr2),y
    lda (screen_ptr),y
    eor (sprite_ptr),y
    sta (screen_ptr),y
    ldy #&10
    lda (screen_ptr2),y
    eor (sprite_ptr2),y
    sta (screen_ptr2),y
    lda (screen_ptr),y
    eor (sprite_ptr),y
    sta (screen_ptr),y
    lda screen_ptr
    and #7
    eor #7
    beq sprite_core_moving_next_row
    inc screen_ptr
.sprite_core_moving_screen_ptr_updated
    lda screen_ptr2
    and #7
    eor #7
    beq sprite_core_moving_next_row2
    inc screen_ptr2
.sprite_core_moving_screen_ptr2_updated
    inc sprite_ptr
    beq sprite_core_moving_low_byte_wrapped
.sprite_core_moving_low_byte_wrap_handled
    inc sprite_ptr2
    beq sprite_core_moving_low_byte_wrapped2
.sprite_core_moving_low_byte_wrap2_handled
    dex
    bne sprite_core_moving_inner_loop
    lda sprite_ptr
    adc #&10
    sta sprite_ptr
    bcc sprite_core_moving_no_carry
    inc sprite_ptr+1
    clc
.sprite_core_moving_no_carry
    lda sprite_ptr2
    adc #&10
    sta sprite_ptr2
    bcc sprite_core_moving_no_carry2
    inc sprite_ptr2+1
    clc
.sprite_core_moving_no_carry2
    dec l0075
    beq sprite_core_moving_outer_loop
.cli_rts
    cli
    rts

.sprite_core_moving_next_row
    lda screen_ptr
    adc #<(bytes_per_screen_line-7)
    sta screen_ptr
    lda screen_ptr+1
    adc #>(bytes_per_screen_line-7)
    sta screen_ptr+1
    bne sprite_core_moving_screen_ptr_updated
.sprite_core_moving_next_row2
    lda screen_ptr2
    adc #<(bytes_per_screen_line-7)
    sta screen_ptr2
    lda screen_ptr2+1
    adc #>(bytes_per_screen_line-7)
    sta screen_ptr2+1
    bne sprite_core_moving_screen_ptr2_updated
.sprite_core_moving_low_byte_wrapped
    inc sprite_ptr+1
    clc
    bne sprite_core_moving_low_byte_wrap_handled
.sprite_core_moving_low_byte_wrapped2
    inc sprite_ptr2+1
    clc
    bne sprite_core_moving_low_byte_wrap2_handled
; Takes sprite slot in W%. No-op if Z% is 5, &A or &14. Otherwise
; appears to be responsible for moving the selected sprite according
; to some internal rules. Set Y%=0 (move) and calls s_subroutine after
; moving.
; TODO: I think there's no need for the branches to cli_rts here, we
; could just branch to the rts.
.t_subroutine
    lda ri_w
    beq cli_rts
    cmp #max_sprite_num+1
    bcs cli_rts
    sec
    sbc #1
    tay
    lda ri_z
    beq cli_rts
    cmp #&0a
    beq cli_rts
    cmp #5
    beq cli_rts
    cmp #&14
    bcs cli_rts
    sec
    sbc #1
    asl a
    tax
; TODO: So for the first part at least, X=Z%*2, and we use it to
; access the sprite_delta_coord_table_xy table, so Z% is presumably a
; sprite slot.
    lda #0
    sta ri_y
    sta t_subroutine_os_x_hi
    sta t_subroutine_os_y_hi
    lda #1
    sta t_subroutine_constant_1
    tya
    asl a
    sta t_subroutine_w_minus_1_times_2
    tay
    asl a
    sta t_subroutine_w_minus_1_times_4
    and #&3f ; '?'
    asl a
    sta t_subroutine_w_minus_1_times_8
    lda sprite_pixel_coord_table_xy,y
    cmp #&fe
    bcs t_subroutine_x_pixel_coord_ge_fe
    ldy t_subroutine_w_minus_1_times_4
    lda sprite_screen_and_data_addrs+screen_addr_hi,y
    beq cli_rts
    ldy t_subroutine_w_minus_1_times_2
    lda sprite_delta_coord_table_xy,x
    bmi add_negative_x_offset
    clc
    adc sprite_pixel_coord_table_xy,y
    bcs new_x_coord_carry
.x_pixel_coord_in_a
    asl a
    rol t_subroutine_os_x_hi
    asl a
    rol t_subroutine_os_x_hi
    asl a
    rol t_subroutine_os_x_hi
    sta t_subroutine_os_x_lo
.update_y_pixel_coord
    lda sprite_pixel_coord_table_xy+1,y
    cmp #2
    bcc sprite_y_pixel_coord_lt_2_indirect
    lda sprite_delta_coord_table_xy+1,x
    bmi add_negative_y_offset
    clc
    adc sprite_pixel_coord_table_xy+1,y
    bcs new_y_pixel_coord_gt_255
.y_pixel_coord_in_a
    asl a
    rol t_subroutine_os_y_hi
    asl a
    rol t_subroutine_os_y_hi
    tax
.set_ri_os_coords_y_lo_in_x_and_jmp_s_subroutine
    ldy t_subroutine_w_minus_1_times_8
    lda t_subroutine_os_x_lo
    sta ri_a,y
    lda t_subroutine_os_x_hi
    sta ri_a+1,y
    lda t_subroutine_os_y_hi
    sta ri_b+1,y
    txa
    sta ri_b,y
    jmp s_subroutine

    equb &60
; TODO: This is called once, via a bcc.
.sprite_y_pixel_coord_lt_2_indirect
    bcc sprite_y_pixel_coord_lt_2                                     ; always branch
; TODO: This is called once, via a bcc.
.new_x_pixel_coord_lt_0
    dec t_subroutine_os_x_hi
    bcc x_pixel_coord_in_a                                            ; always branch
.t_subroutine_x_pixel_coord_ge_fe
    beq t_subroutine_x_pixel_coord_is_fe
    lda sprite_delta_coord_table_xy,x
    beq update_y_pixel_coord_indirect
    cmp #&80
    bcs update_y_pixel_coord_indirect
    lda constant_2
.new_x_pixel_coord_in_a
    sta sprite_pixel_coord_table_xy,y
    asl a
    rol t_subroutine_os_x_hi
    asl a
    rol t_subroutine_os_x_hi
    asl a
    rol t_subroutine_os_x_hi
    sta t_subroutine_os_x_lo
    bne update_y_pixel_coord
.t_subroutine_x_pixel_coord_is_fe
    lda sprite_delta_coord_table_xy,x
    cmp #&80
    bcc update_y_pixel_coord_indirect
    lda constant_96
    bne new_x_pixel_coord_in_a
.new_x_coord_carry
    inc t_subroutine_os_x_hi
    bne x_pixel_coord_in_a
.add_negative_x_offset
    clc
    adc sprite_pixel_coord_table_xy,y
    bcc new_x_pixel_coord_lt_0
    bcs x_pixel_coord_in_a
.update_y_pixel_coord_indirect
    lda #1
    sta t_subroutine_constant_1
    bne update_y_pixel_coord
.new_y_pixel_coord_gt_255
    inc t_subroutine_os_y_hi
    bne y_pixel_coord_in_a                                            ; always branch
.add_negative_y_offset
    clc
    adc sprite_pixel_coord_table_xy+1,y
    bcc new_y_pixel_coord_lt_0
    bcs y_pixel_coord_in_a
.new_y_pixel_coord_lt_0
    dec t_subroutine_os_y_hi
    bcc y_pixel_coord_in_a
.sprite_y_pixel_coord_lt_2
    cmp #1
    beq c53ec
    lda sprite_delta_coord_table_xy+1,x
    beq u_subroutine_rts
    cmp #&80
    bcs u_subroutine_rts
    lda sprite_y_min
; TODO: we are storing at sprite_pixel_coord_table_xy+1,y - the +1
; suggests y coord, but multiply by 8 suggests x
.x_pixel_coord_in_a_2
    sta sprite_pixel_coord_table_xy+1,y
    asl a
    rol t_subroutine_os_y_hi
    asl a
    rol t_subroutine_os_y_hi
    asl a
    rol t_subroutine_os_y_hi
    tax
    lda t_subroutine_constant_1
    bne c53f8                                                         ; always branch?
.u_subroutine_rts
    rts

.c53ec
    lda sprite_delta_coord_table_xy+1,x
    cmp #&80
    bcc u_subroutine_rts
    lda sprite_y_max
    bne x_pixel_coord_in_a_2                                          ; always branch; always branch
.c53f8
    jmp set_ri_os_coords_y_lo_in_x_and_jmp_s_subroutine

; If X%=0 on entry, update the resident integer variables for sprite
; slot W% with that sprite's current OS coordinates. Otherwise, remove
; the existing sprite in slot W% from the screen and replace it with
; sprite image X%, effectively changing its appearance in place. TODO:
; There are probably some subtleties here, but I think that's broadly
; right.
.u_subroutine
    lda ri_w
    beq u_subroutine_rts
    cmp #max_sprite_num+1
    bcs u_subroutine_rts
    sec
    sbc #1
    ldx ri_x
    beq u_subroutine_ri_x_0
    cpx #max_sprite_num+1
    bcs u_subroutine_rts
    asl a
    tay
    asl a
    tax
    lda sprite_screen_and_data_addrs+screen_addr_lo,x
    sta screen_ptr2
    sta screen_ptr
    lda sprite_screen_and_data_addrs+screen_addr_hi,x
    beq u_subroutine_rts
    sta screen_ptr2+1
    sta screen_ptr+1
; Get the sprite's X pixel coordinate and use its low two bits to
; select one of the four pre-shifted variants, assuming it is a two
; character cell (8 pixel) wide sprite.
    lda sprite_pixel_coord_table_xy,y
    and #3
    asl a
    asl a
    asl a
    asl a
    sta l0073
    asl a
    adc l0073
    sta l0072
    adc sprite_screen_and_data_addrs+sprite_addr_lo,x
    sta sprite_ptr2
    lda sprite_screen_and_data_addrs+sprite_addr_hi,x
    adc #0
    sta sprite_ptr2+1
    lda ri_x
    sec
    sbc #1
    asl a
    tay
    lda l0072
    adc sprite_ref_addrs_be+1,y
    sta sprite_screen_and_data_addrs+sprite_addr_lo,x
    sta sprite_ptr
    lda sprite_ref_addrs_be,y
    adc #0
    sta sprite_screen_and_data_addrs+sprite_addr_hi,x
    sta sprite_ptr+1
    jmp sprite_core_moving

.u_subroutine_ri_x_0
    asl a
    tax
    asl a
    tay
    lda sprite_screen_and_data_addrs+screen_addr_hi,y
    beq u_subroutine_rts2
    tya
    asl a
    and #&3f ; '?'
    tay
    lda #0
    sta l0070
    sta l0071
    lda sprite_pixel_coord_table_xy,x
    asl a
    rol l0070
    asl a
    rol l0070
    asl a
    rol l0070
    sta ri_a,y
    lda l0070
    sta ri_a+1,y
    lda sprite_pixel_coord_table_xy+1,x
    asl a
    rol l0071
    asl a
    rol l0071
    sta ri_b,y
    lda l0071
    sta ri_b+1,y
.u_subroutine_rts2
    rts

; Zero resident integer variables A%-Z%
; TODO: This code probably initialises some game state; if this is
; one-off initialisation I think it could just have been done at build
; time, but if it changes during gameplay it makes sense to have code
; to reset things when a new game starts.
.v_subroutine
    ldx #('Z'-'A'+1)*4
    lda #0
.zero_ri_loop
    sta ri_a-1,x
    dex
    bne zero_ri_loop
; Initialise resident integer variables Q%-V%
; TODO: S% at least is effectively a way for this machine code to
; communicate its internal addresses to the BASIC - quite a neat
; trick. Other variables here may well work the same way
    ldx #('V'-'Q'+1)*4
.init_qrstuv_loop
    lda initial_qrstuv_values-1,x
    sta ri_q-1,x
    dex
    bne init_qrstuv_loop
    ldx #0
    clc
    ldy #max_sprite_num
    sty l0070
    ldy #0
.init_sprite_screen_and_data_addrs_loop
    lda sprite_ref_addrs_be+0,x
    sta sprite_screen_and_data_addrs+sprite_addr_hi,y
    lda sprite_ref_addrs_be+1,x
    sta sprite_screen_and_data_addrs+sprite_addr_lo,y
    lda #0
    sta sprite_pixel_coord_table_xy+0,x
    sta sprite_pixel_coord_table_xy+1,x
    sta sprite_screen_and_data_addrs+screen_addr_lo,y
    sta sprite_screen_and_data_addrs+screen_addr_hi,y
    tya
    adc #4
    tay
    inx
    inx
    dec l0070
    bne init_sprite_screen_and_data_addrs_loop
    rts

.initial_qrstuv_values
.initial_q_value
    equw q_subroutine,            0
; TODO: never used?
.initial_r_value
    equw r_subroutine,            0
.initial_s_value
    equw s_subroutine,            0
.initial_t_value
    equw t_subroutine,            0
.initial_u_value
    equw u_subroutine,            0
.initial_v_value
    equw v_subroutine,            0
.initial_qrstuv_values_end
    equb   0,   0,   0,   0,   0,   0,   0,   0,   0,   0,   0,   0
    equb &ff,   0,   0,   0,   0,   0,   0,   0,   0,   0,   0,   0
    equb   0,   0,   0,   0,   0,   0,   0,   0,   0,   0,   0,   0
    equb   0,   0,   0,   0,   0,   0,   0,   0,   0,   0,   0,   0
    equb   0,   0,   0,   0,   0,   0,   0,   0,   0,   0,   0,   0
    equb   0,   0,   0,   0,   0,   0,   0,   0,   0,   0,   0,   0
    equb   0,   0,   0,   0,   0,   0,   0,   0,   0,   0,   0,   0
    equb   0,   0,   0,   0,   0,   0,   0,   0,   0,   0,   0,   0
    equb   0,   0,   0,   0,   0,   0,   0,   0,   0,   0,   0,   0
    equb   0,   0,   0,   0,   0,   0,   0,   0,   0,   0,   0,   0
    equb   0,   0,   0,   0,   0,   0,   0,   0,   0,   0,   0,   0
    equb   0,   0,   0,   0,   0,   0,   0,   0,   0,   0,   0,   0
    equb   0,   0,   0,   0,   0,   0,   0,   0,   0,   0,   0,   0
    equb   0,   0,   0,   0,   0,   0,   0,   0,   0,   0,   0,   0
    equb   0,   0,   0,   0,   0,   0,   0,   0,   0,   0,   0,   0
    equb   0,   0,   0,   0,   0,   0,   0,   0,   0,   0,   0,   0
    equb   0,   0,   0,   0,   0,   0,   0,   0,   0,   0,   0,   0
.sprite_delta_coord_table_xy
    equb -1,  1                                                       ; index 0
    equb  0,  1                                                       ; index 1
    equb  1,  1                                                       ; index 2
    equb -1,  0                                                       ; index 3
    equb  0,  0                                                       ; index 4
    equb  1,  0                                                       ; index 5
    equb -1, -1                                                       ; index 6
    equb  0, -1                                                       ; index 7
    equb  1, -1                                                       ; index 8
    equb  0,  0                                                       ; index 9
    equb -8,  8                                                       ; index 10
    equb  0,  8                                                       ; index 11
    equb  8,  8                                                       ; index 12
    equb -8,  0                                                       ; index 13
    equb  0,  0                                                       ; index 14
    equb  8,  0                                                       ; index 15
    equb -8, -8                                                       ; index 16
    equb  0, -8                                                       ; index 17
    equb  8, -8                                                       ; index 18
    equb  0,  0                                                       ; index 19
    equb  0,  0                                                       ; index 20
    equb  0,  0                                                       ; index 21
    equb  0,  0                                                       ; index 22
    equb  0,  0                                                       ; index 23
    equb  0,  0                                                       ; index 24
    equb  0,  0                                                       ; index 25
    equb  0,  0                                                       ; index 26
    equb  0,  0                                                       ; index 27
.constant_2
    equb 2
.constant_96
    equb &96
; TODO: This is just a constant in this game.
.sprite_y_min
    equb &10
; TODO: This is just a constant in this game.
.sprite_y_max
    equb &fe,   0,   0,   0,   0
; This is (TODO: probably!) a table with four bytes per sprite. The
; first two bytes are the little-endian screen address of the sprite
; (0 if it is not on screen) and the second two bytes are the big-
; endian address of the sprite's definition. The sprite address is the
; address of X-offset version 0; this does not change as the sprite
; moves, so it needs to be offset appropriately when
; plotting/unplotting.
.sprite_screen_and_data_addrs
    equb          0,          0, >sprite_00, <sprite_00               ; sprite 0
    equb          0,          0, >sprite_00, <sprite_00               ; sprite 1
    equb          0,          0, >sprite_00, <sprite_00               ; sprite 2
    equb          0,          0, >sprite_00, <sprite_00               ; sprite 3
    equb          0,          0, >sprite_00, <sprite_00               ; sprite 4
    equb          0,          0, >sprite_00, <sprite_00               ; sprite 5
    equb          0,          0, >sprite_00, <sprite_00               ; sprite 6
    equb          0,          0, >sprite_00, <sprite_00               ; sprite 7
    equb          0,          0, >sprite_08, <sprite_08               ; sprite 8
    equb          0,          0, >sprite_09, <sprite_09               ; sprite 9
    equb          0,          0, >sprite_10, <sprite_10               ; sprite 10
    equb          0,          0, >sprite_11, <sprite_11               ; sprite 11
    equb          0,          0, >sprite_12, <sprite_12               ; sprite 12
    equb          0,          0, >sprite_13, <sprite_13               ; sprite 13
    equb          0,          0, >sprite_14, <sprite_14               ; sprite 14
    equb          0,          0, >sprite_15, <sprite_15               ; sprite 15
    equb          0,          0, >sprite_16, <sprite_16               ; sprite 16
    equb          0,          0, >sprite_17, <sprite_17               ; sprite 17
    equb          0,          0, >sprite_18, <sprite_18               ; sprite 18
    equb          0,          0, >sprite_19, <sprite_19               ; sprite 19
    equb          0,          0, >sprite_20, <sprite_20               ; sprite 20
    equb          0,          0, >sprite_21, <sprite_21               ; sprite 21
    equb          0,          0, >sprite_22, <sprite_22               ; sprite 22
    equb          0,          0, >sprite_23, <sprite_23               ; sprite 23
    equb          0,          0, >sprite_24, <sprite_24               ; sprite 24
    equb          0,          0, >sprite_25, <sprite_25               ; sprite 25
    equb          0,          0, >sprite_00, <sprite_00               ; sprite 26
    equb          0,          0, >sprite_00, <sprite_00               ; sprite 27
    equb          0,          0, >sprite_00, <sprite_00               ; sprite 28
    equb          0,          0, >sprite_00, <sprite_00               ; sprite 29
    equb          0,          0, >sprite_00, <sprite_00               ; sprite 30
    equb          0,          0, >sprite_00, <sprite_00               ; sprite 31
    equb          0,          0, >sprite_00, <sprite_00               ; sprite 32
    equb          0,          0, >sprite_00, <sprite_00               ; sprite 33
    equb          0,          0, >sprite_00, <sprite_00               ; sprite 34
    equb          0,          0, >sprite_00, <sprite_00               ; sprite 35
    equb          0,          0, >sprite_00, <sprite_00               ; sprite 36
    equb          0,          0, >sprite_00, <sprite_00               ; sprite 37
    equb          0,          0, >sprite_00, <sprite_00               ; sprite 38
    equb          0,          0, >sprite_00, <sprite_00               ; sprite 39
    equb          0,          0, >sprite_00, <sprite_00               ; sprite 40
    equb          0,          0, >sprite_00, <sprite_00               ; sprite 41
    equb          0,          0, >sprite_00, <sprite_00               ; sprite 42
    equb          0,          0, >sprite_00, <sprite_00               ; sprite 43
    equb          0,          0, >sprite_00, <sprite_00               ; sprite 44
    equb          0,          0, >sprite_00, <sprite_00               ; sprite 45
    equb          0,          0, >sprite_00, <sprite_00               ; sprite 46
    equb          0,          0, >sprite_00, <sprite_00               ; sprite 47
.screen_y_addr_table
    equw &7ec0
    equw &7d80
    equw &7c40
    equw &7b00
    equw &79c0
    equw &7880
    equw &7740
    equw &7600
    equw &74c0
    equw &7380
    equw &7240
    equw &7100
    equw &6fc0
    equw &6e80
    equw &6d40
    equw &6c00
    equw &6ac0
    equw &6980
    equw &6840
    equw &6700
    equw &65c0
    equw &6480
    equw &6340
    equw &6200
    equw &60c0
    equw &5f80
    equw &5e40
    equw &5d00
    equw &5bc0
    equw &5a80
    equw &5940
    equw &5800
; This appears to be a big-endian table of start addresses for the
; game sprites. TODO: This is inspired guesswork; note that the copy
; of this at sprite_screen_and_data_addrs+{2,3] does get tweaked
; slightly.
.sprite_ref_addrs_be
    equb >sprite_00, <sprite_00
    equb >sprite_00, <sprite_00
    equb >sprite_00, <sprite_00
    equb >sprite_00, <sprite_00
    equb >sprite_00, <sprite_00
    equb >sprite_00, <sprite_00
    equb >sprite_00, <sprite_00
    equb >sprite_00, <sprite_00
    equb >sprite_08, <sprite_08
    equb >sprite_09, <sprite_09
    equb >sprite_10, <sprite_10
    equb >sprite_11, <sprite_11
    equb >sprite_12, <sprite_12
    equb >sprite_13, <sprite_13
    equb >sprite_14, <sprite_14
    equb >sprite_15, <sprite_15
    equb >sprite_16, <sprite_16
    equb >sprite_17, <sprite_17
    equb >sprite_18, <sprite_18
    equb >sprite_19, <sprite_19
    equb >sprite_20, <sprite_20
    equb >sprite_21, <sprite_21
    equb >sprite_22, <sprite_22
    equb >sprite_23, <sprite_23
    equb >sprite_24, <sprite_24
    equb >sprite_25, <sprite_25
    equb >sprite_00, <sprite_00
    equb >sprite_00, <sprite_00
    equb >sprite_00, <sprite_00
    equb >sprite_00, <sprite_00
    equb >sprite_00, <sprite_00
    equb >sprite_00, <sprite_00
    equb >sprite_00, <sprite_00
    equb >sprite_00, <sprite_00
    equb >sprite_00, <sprite_00
    equb >sprite_00, <sprite_00
    equb >sprite_00, <sprite_00
    equb >sprite_00, <sprite_00
    equb >sprite_00, <sprite_00
    equb >sprite_00, <sprite_00
    equb >sprite_00, <sprite_00
    equb >sprite_00, <sprite_00
    equb >sprite_00, <sprite_00
    equb >sprite_00, <sprite_00
    equb >sprite_00, <sprite_00
    equb >sprite_00, <sprite_00
    equb >sprite_00, <sprite_00
    equb >sprite_00, <sprite_00
; Table of (pixel X coordinate, pixel Y coordinate) sprite positions,
; two bytes per sprite
.sprite_pixel_coord_table_xy
    equb 0
    equb 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0
    equb 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0
    equb 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0
    equb 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0
    equb 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0
; TODO: This table appears to be read-only and since every byte is 1,
; we can probably replace accesses to it with immediate constants and
; get rid of it.
.constant_1_per_sprite_table
    equb 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1
    equb 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1
    equb 1, 1, 1, 1, 1, 1
.r_subroutine_inkey_code_1
    equb &bd
.r_subroutine_inkey_code_2
    equb &9e
.r_subroutine_inkey_code_3
    equb &b7
.r_subroutine_inkey_code_4
    equb &97
.r_subroutine_foo
    equb 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0
.pydis_end

; Automatically generated labels:
;     c4fbd
;     c4fd0
;     c4fdc
;     c4ff4
;     c5002
;     c5008
;     c5012
;     c501f
;     c5026
;     c502b
;     c53ec
;     c53f8
;     l0072
;     l0073
;     l0074
;     l0075
    assert ('V'-'Q'+1)*4 == &18
    assert ('Z'-'A'+1)*4 == &68
    assert <(bytes_per_screen_line-7) == &39
    assert <sprite_00 == &00
    assert <sprite_08 == &c0
    assert <sprite_09 == &80
    assert <sprite_10 == &40
    assert <sprite_11 == &00
    assert <sprite_12 == &c0
    assert <sprite_13 == &80
    assert <sprite_14 == &40
    assert <sprite_15 == &00
    assert <sprite_16 == &c0
    assert <sprite_17 == &80
    assert <sprite_18 == &40
    assert <sprite_19 == &00
    assert <sprite_20 == &c0
    assert <sprite_21 == &80
    assert <sprite_22 == &40
    assert <sprite_23 == &00
    assert <sprite_24 == &c0
    assert <sprite_25 == &80
    assert >(bytes_per_screen_line-7) == &01
    assert >sprite_00 == &40
    assert >sprite_08 == &40
    assert >sprite_09 == &41
    assert >sprite_10 == &42
    assert >sprite_11 == &43
    assert >sprite_12 == &43
    assert >sprite_13 == &44
    assert >sprite_14 == &45
    assert >sprite_15 == &46
    assert >sprite_16 == &46
    assert >sprite_17 == &47
    assert >sprite_18 == &48
    assert >sprite_19 == &49
    assert >sprite_20 == &49
    assert >sprite_21 == &4a
    assert >sprite_22 == &4b
    assert >sprite_23 == &4c
    assert >sprite_24 == &4c
    assert >sprite_25 == &4d
    assert get_sprite_details_sprite_index == &7c
    assert initial_qrstuv_values-1 == &54db
    assert l007d == &7d
    assert max_sprite_num == &30
    assert max_sprite_num+1 == &31
    assert osbyte_clear_escape == &7c
    assert osbyte_inkey == &81
    assert q_subroutine == &4f00
    assert q_subroutine_abs_x_difference == &72
    assert q_subroutine_abs_y_difference == &73
    assert q_subroutine_max_candidate_sprite_x2 == &70
    assert q_subroutine_sprite_to_check_x2 == &71
    assert r_subroutine == &4f9f
    assert ri_a-1 == &0403
    assert ri_q-1 == &0443
    assert s_subroutine == &5033
    assert sprite_pixel_coord_table_xy+0 == &5760
    assert sprite_pixel_coord_table_xy+1 == &5761
    assert sprite_pixel_current_x == &72
    assert sprite_pixel_current_y == &73
    assert sprite_ptr == &70
    assert sprite_ptr+1 == &71
    assert sprite_ptr2 == &7e
    assert sprite_ptr2+1 == &7f
    assert sprite_ref_addrs_be+0 == &5700
    assert sprite_ref_addrs_be+1 == &5701
    assert sprite_y_offset_within_row == &75
    assert t_subroutine == &52e3
    assert t_subroutine_constant_1 == &73
    assert t_subroutine_os_x_hi == &70
    assert t_subroutine_os_x_lo == &71
    assert t_subroutine_os_y_hi == &72
    assert t_subroutine_w_minus_1_times_2 == &7f
    assert t_subroutine_w_minus_1_times_4 == &7e
    assert t_subroutine_w_minus_1_times_8 == &76
    assert u_subroutine == &53fb
    assert v_subroutine == &5499

MAKE_IMAGE =? FALSE
if not(MAKE_IMAGE)
    save pydis_start, pydis_end
endif
