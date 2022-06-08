max_sprite_num = &30
sprite_to_check_x2 = &71
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
osbyte_inkey = &81
osbyte_clear_escape = &7c

; TODO: Move zp vars into the most restrictive scope possible
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
osbyte = &fff4

; This is the conceptual width; sprite data is actually 12 pixels wide but only
; eight adjacent columns within the sprite will be non-black. TODO: Not true,
; e.g. the harpy has nine adjacent columns. This is probably fine and doesn't
; seriously affect my understanding, but think about it before tweaking this
; comment/constant.
sprite_width_pixels = 8
sprite_height_pixels = 16

; BASIC's resident integer variables @%, A%, ..., Z% (four bytes each) have
; fixed addresses in page &4. They are used extensively to communicate between
; BASIC and this machine code.
ri_a = &0404
ri_b = &0408
ri_q = &0444
ri_w = &045c
ri_x = &0460
ri_y = &0464
ri_z = &0468

    org &35bc
.pydis_start

; ENHANCE: Rooms are 20x18 mode 5 character cells in size. They are packed two
; cells to a byte; it would be possible to pack eight cells to a byte with
; slightly cleverer unpacking code, which would free up some extra memory. (14
; rooms currently take 2520 bytes which would reduce to 630 bytes, saving 1890
; bytes less any small loss for the more complex unpacking code.)
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
; shown in a pseudo-graphical form in the source code. It would probably be best
; if the input was a hex number which uses 0/1/2/3 for the colours and the macro
; did the necessary bit-twiddling internally to generate screen data..
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

; Most of the following subroutines handle sprites in one way or another. We
; have max_sprite_num sprite slots, each of which defines a screen position and
; an associated sprite image. The resident integer variables are used to
; communicate between the BASIC and machine code.
;
; OS graphics coordinates (1280x1024, origin at bottom left) are passed using
; the low 16 bits of resident integer variables A%-P%, as follows:
;     slots 1/ 9/17/25/33/41 use A% (X coordinate) and B% (Y coordinate)
;     slots 2/10/18/26/34/42 use C%/D%
;     slots 3/11/19/27/35/43 use E%/F%
;     slots 4/12/20/28/36/44 use G%/H%
;     slots 5/13/21/29/37/45 use I%/J%
;     slots 6/14/22/30/38/46 use K%/L%
;     slots 7/15/23/31/39/47 use M%/N%
;     slots 8/16/24/32/40/48 use O%/P%
;
; The code usually calculates an offset (often in Y) so that the X coordinate
; resident integer variable can be accessed at ri_a+{0,1},y and the Y coordinate
; at ri_b+{0,1},y.
ri_coord_vars = 8

; ENHANCE: Many of these routines check their inputs for validity (e.g. that W%
; is in the range 1-max_sprite_num); this is probably because they're a
; general-purpose sprite package, but we probably don't need this checking here.
; Probably only remove this if we're really desperate for time or space; it
; won't cost much of either to keep it.

; Collision detection subroutine
;
; On entry:
;     W% is the sprite slot we want to check for collisions
;         (always the player's sprite slot in practice)
;     Y% is the maximum sprite slot to check for collisions with
;         (always 8 in practice)
;
; On exit:
;     X% is the lowest-numbered sprite slot overlapping slot W%; 0 indicates no
;     collision.
;     Y% and Z% are updated but I don't know exactly what the values mean and
;     they're not used in practice.
;
; Sprites are considered to collide if their 8x16 pixel areas overlap; there is
; no attempt to check the actual sprite pixels. In practice the collision
; detection between sprites is probably best left alone. Switching to
; pixel-perfect detection would stop the player being harmed by the robot
; sentinel in the first room passing over their head when they are standing on
; the lowest part of the upper floor, for example. It's also probable
; pixel-perfect detection would make it harder or even impossible for the player
; to pick up objects, as they would need to actually manage to physically
; overlap them.
;
; ENHANCE: This is a general-purpose routine, but in practice we could bake-in
; some behaviour which is appropriate for our purposes (e.g. hardcode 8 instead
; of reading Y%, don't worry about the possibility of W% not being on screen as
; it's always the player sprite, assume W%>Y% so we don't have to worry about
; self-collisions).
.q_subroutine
{
max_candidate_sprite_x2 = &70
abs_x_difference = &72
abs_y_difference = &73
overlap_direction = &74

    lda ri_w:beq no_collision_found
    cmp #max_sprite_num+1:bcs no_collision_found
    sec:sbc #1
    asl a:tax
    asl a:tay
    ; If sprite slot W% is not on screen, it can't have any collisions.
    lda sprite_screen_and_data_addrs+screen_addr_hi,y:beq no_collision_found
    stx sprite_to_check_x2
    lda ri_y:beq no_collision_found
    cmp #max_sprite_num+1:bcs no_collision_found
    sec:sbc #1
    asl a:sta max_candidate_sprite_x2
    ; Loop over all the candidate sprites and see if any are overlapping W%.
    ; TODO: I think the code for the following loop is needlessly fiddly about
    ; shuffling a value back between A and Y. In practice this works, but I
    ; think it introduces some theoretical bugs (e.g. if we're entered with
    ; W%=3 and Y%=4, this loop will get stuck with A=4 and Y=2). It would
    ; probably be simpler and more correct to keep the loop index in Y and
    ; just increment it with iny:iny. Do think about this before changing it
    ; as it's possible there's a subtlety here I'm overlooking.
    ; TODO: Am I missing something, or does this code not check to see if the
    ; candidate is actually visible on screen?!
    lda #0
.y_loop
    cmp sprite_to_check_x2:beq next_candidate ; W% can't collide with itself
    tay
    lda #5:sta overlap_direction
    lda sprite_pixel_coord_table_xy,x
    sec:sbc sprite_pixel_coord_table_xy,y
    ; TODO: This BMI feels wrong (e.g. 0-140=-140=116, so the answer will look
    ; positive when it isn't) and as though using BCS/BCC would be better. I'm
    ; not that confident about this though. I did write a program to test all
    ; the cases in the range 0-159 and in practice it works fine, and I can
    ; kinda-sorta see why it probably is fine.
    bmi negate_x_difference_and_inc_overlap_direction
    beq test_abs_x_difference
    dec overlap_direction
.test_abs_x_difference
    cmp #sprite_width_pixels+1:bcs next_candidate
    ; abs(W%'s X coord, candidate's X coord) <= sprite_width_pixels, so the two
    ; overlap in the X dimension. Check for Y overlap now.
    sta abs_x_difference
    lda sprite_pixel_coord_table_xy+1,x
    sec:sbc sprite_pixel_coord_table_xy+1,y
    ; TODO: See coments on BMI above.
    bmi negate_y_difference_and_subtract_3_from_overlap_direction
    beq test_abs_y_difference
    inc overlap_direction:inc overlap_direction:inc overlap_direction
.test_abs_y_difference
    ; TODO: "Logically" this should be cmp #sprite_height_pixels+1, shouldn't
    ; it? In practice as noted elsewhere the code works and it's probably best
    ; to take its behaviour as correct by definition unless a glaring flaw turns
    ; up.
    cmp #sprite_height_pixels:bcs next_candidate
    ; abs(W%'s Y coord, candidate's Y coord) <= ~sprite_height_pixels, so the
    ; two overlap in both dimensions and we've found a collision.
    ; At this point overlap_direction = 5 + sign(X difference) + 3*sign(Y difference). I
    ; believe this gives a value in the range 1-9 which indicates the X/Y
    ; "structure" of the collision, although in practice we don't use it.
    sta abs_y_difference
    bcc collision_found ; always branch
.next_candidate
    cpy max_candidate_sprite_x2
    beq no_collision_found
    tya
    adc #2
    bne y_loop                                           ; always branch
.no_collision_found
    lda #0
    sta ri_x
    sta ri_y
    rts
.negate_x_difference_and_inc_overlap_direction
    ; Set A=-A.
    ; TODO: I'm not convinced carry will always be clear here, which we need for
    ; this to actually be a negation. At worst this is going to introduce an
    ; off-by-one error though.
    eor #&ff:adc #1
    inc overlap_direction
    bne test_abs_x_difference ; always branch
.negate_y_difference_and_subtract_3_from_overlap_direction
    ; Set A=-A.
    eor #&ff:adc #1 ; TODO: not sure we have carry clear here
    dec overlap_direction:dec overlap_direction:dec overlap_direction
    bne test_abs_y_difference ; always branch
.collision_found
    ; Set Y% to 35-(abs_x_difference*2)-abs_y_difference, so it is a metric
    ; indicating how much the sprites overlap. It will range from 4 if both
    ; differences are as large as possible up to 35 if the two sprites coincide
    ; perfectly. This doesn't seem to be used in practice.
    lda abs_x_difference:asl a:adc abs_y_difference:sta l0073
    lda #35:sec:sbc l0073:sta ri_y
    ; Set Z% to overlap_detection. This doesn't seem to be used in practice.
    lda overlap_direction:sta ri_z
    ; Set X% to the 1-based logical sprite number we found a collision
    ; with.
    iny:iny:tya:lsr a:sta ri_x
.^q_subroutine_rts
    rts
}

; This seems to be keyboard-reading code which is never used in practice, so I
; haven't attempted to fully disassemble it.
; ENHANCE: This can obviously be removed.
.r_subroutine
{
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
.^r_subroutine_rts
    rts

.c5026
    lda r_subroutine_foo
    bne c501f
.c502b
    lda l0075
    bne c501f
}

{
; ENHANCE: This subroutine seems a bit over-zealous about clearing carry and
; could probably be simplified and clarified by clearing it only when we finally
; need it cleared.

.clc_remove_sprite_from_screen
    clc
    jmp remove_sprite_from_screen

; TODO: WRITE NEW SUBROUTINE COMMENT IN STYLE OF Q_SUBROUTINE ONE
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
.^s_subroutine
    lda ri_w:beq r_subroutine_rts
    cmp #max_sprite_num+1:bcs r_subroutine_rts
    sec:sbc #1
    ldx ri_y:cpx #2:beq clc_remove_sprite_from_screen
    jsr get_sprite_details
    lda sprite_pixel_coord_table_xy,x:cmp #&fe:bcs clc_remove_sprite_from_screen
    lda sprite_pixel_coord_table_xy+1,x:cmp #2:bcc clc_remove_sprite_from_screen
    lda sprite_pixel_y_lo:tax
    lsr a:lsr a:and #&fe:tay
    ; Invert the low bits of the sprite's Y pixel address; this accounts for the
    ; fact that our pixel coordinates have their origin at the bottom left, but
    ; the bytes within a 6845 character cell in the screen memory are arranged
    ; from the top downwards.
    txa:and #7:eor #7:sta sprite_y_offset_within_row
    lda screen_row_addr_table,y:clc:adc sprite_y_offset_within_row:sta screen_ptr
    lda screen_row_addr_table+1,y:adc #0:sta screen_ptr+1
    lda #0:sta l0073:lda sprite_pixel_x_lo
    asl a:rol l0073
    and #&f8
    adc screen_ptr:sta screen_ptr ; we know carry is clear after rol l0073
    lda screen_ptr+1:adc l0073:sta screen_ptr+1
    ldx l0074
    lda sprite_screen_and_data_addrs+screen_addr_lo,x:sta screen_ptr2
    lda sprite_screen_and_data_addrs+screen_addr_hi,x:sta screen_ptr2+1
    lda screen_ptr:sta sprite_screen_and_data_addrs+screen_addr_lo,x
    lda screen_ptr+1:sta sprite_screen_and_data_addrs+screen_addr_hi,x
    lda sprite_pixel_x_lo:and #3
    asl a:asl a:asl a:asl a:sta l0073
    asl a:adc l0073 ; we know carry is clear after asl a
    adc sprite_screen_and_data_addrs+sprite_addr_lo,x
    sta sprite_ptr
    lda sprite_screen_and_data_addrs+sprite_addr_hi,x:adc #0:sta sprite_ptr+1
    lda ri_y:cmp #1:beq clc_jmp_sprite_core
    lda screen_ptr2+1:beq clc_jmp_sprite_core
    lda l0072:and #3
    asl a:asl a:asl a:asl a:sta l0073
    asl a:adc l0073 ; we know carry is clear after asl a
    adc sprite_screen_and_data_addrs+sprite_addr_lo,x:sta sprite_ptr2
    lda sprite_screen_and_data_addrs+sprite_addr_hi,x:adc #0:sta sprite_ptr2+1
    clc
    jmp sprite_core_moving

.clc_jmp_sprite_core
    clc
    jmp sprite_core

.remove_sprite_from_screen
    ; A is the 0-based sprite slot derived from W%.
    asl a:tay
    asl a:tax
    lda sprite_screen_and_data_addrs+screen_addr_lo,x:sta screen_ptr
    lda sprite_screen_and_data_addrs+screen_addr_hi,x:beq s_subroutine_rts2
    sta screen_ptr+1
    lda sprite_pixel_coord_table_xy,y:and #3
    asl a:asl a:asl a:asl a:sta l0073
    asl a:adc l0073 ; we know carry is clear after asl a
    adc sprite_screen_and_data_addrs+sprite_addr_lo,x:sta sprite_ptr
    lda sprite_screen_and_data_addrs+sprite_addr_hi,x:adc #0:sta sprite_ptr+1
    lda #0
    sta sprite_screen_and_data_addrs+screen_addr_lo,x
    sta sprite_screen_and_data_addrs+screen_addr_hi,x
    clc
    jmp sprite_core

.s_subroutine_rts2
    rts

; On entry:
;     A is the 0-based sprite slot derived from W%.
;
; On exit:
;     TODO
.get_sprite_details
{
    sta get_sprite_details_sprite_index
    ; Calculate the offset of this sprite slot's coordinate resident integer
    ; variables in Y.
    asl a:tax:sta l007d ; TODO: Is the value written to &7D ever used?
    asl a:sta l0074
    asl a:and #(ri_coord_vars-1)<<3:tay:sty l0075 ; TODO: I don't think the value written to l0075 here is ever used?
    ; Copy values from the coordinate resident integer variables into
    ; sprite_pixel_{x,y}_{hi,lo}, scaling from OS coordinates to actual pixel
    ; coordinates by dividing X by 8 and Y by 4.
    lda ri_a+1,y:sta sprite_pixel_x_hi
    lda ri_a+0,y:lsr sprite_pixel_x_hi
    ror a:lsr sprite_pixel_x_hi
    ror a:lsr sprite_pixel_x_hi
    ror a:sta sprite_pixel_x_lo
    lda ri_b+1,y:sta sprite_pixel_y_hi
    lda ri_b+0,y:lsr sprite_pixel_y_hi
    ror a:lsr sprite_pixel_y_hi
    ror a:sta sprite_pixel_y_lo
    ldy get_sprite_details_sprite_index
    ; Copy the current pixel coordinates into sprite_pixel_current_{x,y}.
    lda sprite_pixel_coord_table_xy+0,x:sta sprite_pixel_current_x
    lda sprite_pixel_coord_table_xy+1,x:sta sprite_pixel_current_y
    ; ENHANCE: It may be that we know the value's always 8-bit, because
    ; world-2.bas doesn't try to move sprites outside the screen area.
    lda sprite_pixel_x_hi:beq x_position_is_8_bit
    cmp #&80 ; ENHANCE: just use N from the preceding lda instead to avoid this
    bcc x_position_too_far_right
    bcs x_position_too_far_left
.check_y_position
    lda sprite_pixel_y_hi:beq y_position_is_8_bit
    cmp #&80 ; ENHANCE: just use N from preceding lda instead to avoid this
    bcc y_position_too_far_up
    bcs y_position_too_far_down
.x_position_is_8_bit
    lda sprite_pixel_x_lo
    cmp sprite_x_min:bcc x_position_too_far_left
    cmp sprite_x_max:beq x_position_ok:bcs x_position_too_far_right
.x_position_ok
    sta sprite_pixel_coord_table_xy,x
    clc:bcc check_y_position ; always branch
.x_position_too_far_right
    lda sprite_wrap_behaviour_table,y:beq force_x_position_to_rhs
    cmp #1:beq force_x_position_to_lhs
    lda #&ff:sta sprite_pixel_coord_table_xy,x
    bne check_y_position ; always branch
.force_x_position_to_rhs
    lda sprite_x_max
    sta sprite_pixel_coord_table_xy,x
    sta sprite_pixel_x_lo
; TODO: I believe this is effectively a jmp and nothing cares about
; the fact we've cleared carry.
    clc
    bcc check_y_position
.x_position_too_far_left
    lda sprite_wrap_behaviour_table,y                                 ; always branch
    beq force_x_position_to_lhs
    cmp #1
    beq force_x_position_to_rhs
    lda #&fe
    sta sprite_pixel_coord_table_xy,x
    bne check_y_position                                       ; always branch
.force_x_position_to_lhs
    lda sprite_x_min
    sta sprite_pixel_coord_table_xy,x
    sta sprite_pixel_x_lo
    clc
    bcc check_y_position
.y_position_is_8_bit
    lda sprite_pixel_y_lo
    cmp sprite_y_min
    bcc y_position_too_far_down
    cmp sprite_y_max
    beq y_position_adjusted
    bcs y_position_too_far_up
.y_position_adjusted
    sta sprite_pixel_coord_table_xy+1,x
    clc
    rts

.y_position_too_far_up
    lda sprite_wrap_behaviour_table,y
    beq force_y_position_to_constant_fe
    cmp #1
    beq force_y_position_to_constant_10
    lda #0
    sta sprite_pixel_coord_table_xy+1,x
    clc
    rts

.force_y_position_to_constant_fe
    lda sprite_y_max
    sta sprite_pixel_coord_table_xy+1,x
    sta sprite_pixel_y_lo
    clc
    rts

.y_position_too_far_down
    lda sprite_wrap_behaviour_table,y
    beq force_y_position_to_constant_10
    cmp #1
    beq force_y_position_to_constant_fe
    lda #1
    sta sprite_pixel_coord_table_xy+1,x
    clc
    rts

.force_y_position_to_constant_10
    lda sprite_y_min
    sta sprite_pixel_coord_table_xy+1,x
    sta sprite_pixel_y_lo
    clc
    rts
} ; end get_sprite_details scope

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
{
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
} ; end sprite_core scope
} ; end s_subroutine scope

; TODO: This looks like an 'alternate version' of sprite_core? I
; haven't been over the code properly yet, but I suspect it is a
; 'erase at old location, replot immediately at new location' variant,
; to handle moving sprites more efficiently.
.sprite_core_moving
{
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
.^cli_rts
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
}

; Takes sprite slot in W%. No-op if Z% is 5, &A or &14. Otherwise
; appears to be responsible for moving the selected sprite according
; to some internal rules. Set Y%=0 (move) and calls s_subroutine after
; moving.
; TODO: I think there's no need for the branches to cli_rts here, we
; could just branch to the rts.
.t_subroutine
{
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

    ; ENHANCE: junk byte, can be deleted
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
    lda sprite_x_min
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
    lda sprite_x_max
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
    beq t_subroutine_rts
    cmp #&80
    bcs t_subroutine_rts
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
.^t_subroutine_rts
    rts

.c53ec
    lda sprite_delta_coord_table_xy+1,x
    cmp #&80
    bcc t_subroutine_rts
    lda sprite_y_max
    bne x_pixel_coord_in_a_2                                          ; always branch; always branch
.c53f8
    jmp set_ri_os_coords_y_lo_in_x_and_jmp_s_subroutine
}

; If X%=0 on entry, update the resident integer variables for sprite
; slot W% with that sprite's current OS coordinates. Otherwise, remove
; the existing sprite in slot W% from the screen and replace it with
; sprite image X%, effectively changing its appearance in place. TODO:
; There are probably some subtleties here, but I think that's broadly
; right.
.u_subroutine
{
    lda ri_w
    beq t_subroutine_rts
    cmp #max_sprite_num+1
    bcs t_subroutine_rts
    sec
    sbc #1
    ldx ri_x
    beq u_subroutine_ri_x_0
    cpx #max_sprite_num+1
    bcs t_subroutine_rts
    asl a
    tay
    asl a
    tax
    lda sprite_screen_and_data_addrs+screen_addr_lo,x
    sta screen_ptr2
    sta screen_ptr
    lda sprite_screen_and_data_addrs+screen_addr_hi,x
    beq t_subroutine_rts
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
}

.v_subroutine
{
    ; Zero resident integer variables A%-Z%
    ldx #('Z'-'A'+1)*4
    lda #0
.zero_ri_loop
    sta ri_a-1,x
    dex
    bne zero_ri_loop
    ; Initialise resident integer variables Q%-V%
    ldx #('V'-'Q'+1)*4
.init_qrstuv_loop
    lda initial_qrstuv_values-1,x
    sta ri_q-1,x
    dex
    bne init_qrstuv_loop
    ; Initialise sprite_screen_and_data_addrs so every slot is associated with
    ; the corresponding sprite image by default and is not on screen.
    ldx #0
    clc ; ENHANCE: get rid of this and do iny*4 below to increment Y
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

; ENHANCE: I am actually thinking of using just a single resident integer
; variable which points to a table of entry points. The BASIC code can then set
; up whatever variables it chooses from that table on startup, and we will have
; five of these resident integer variables free for re-use as whatever improves
; performance the most. (It may well be that some of these subroutines continue
; to be assigned to resident integer variables, but that would be entirely down
; to the BASIC.) If I do this, I would need to make sure it's OK for
; v_subroutine to zero all resident integer variables, or tweak it to leave some
; alone.
.initial_qrstuv_values
.initial_q_value
    equw q_subroutine, 0
.initial_r_value
    equw r_subroutine, 0
.initial_s_value
    equw s_subroutine, 0
.initial_t_value
    equw t_subroutine, 0
.initial_u_value
    equw u_subroutine, 0
.initial_v_value
    equw v_subroutine, 0
}

    ; ENHANCE: Junk data, can be deleted.
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
    equb -1,  1 ; index 0
    equb  0,  1 ; index 1
    equb  1,  1 ; index 2
    equb -1,  0 ; index 3
    equb  0,  0 ; index 4
    equb  1,  0 ; index 5
    equb -1, -1 ; index 6
    equb  0, -1 ; index 7
    equb  1, -1 ; index 8
    equb  0,  0 ; index 9
    equb -8,  8 ; index 10
    equb  0,  8 ; index 11
    equb  8,  8 ; index 12
    equb -8,  0 ; index 13
    equb  0,  0 ; index 14
    equb  8,  0 ; index 15
    equb -8, -8 ; index 16
    equb  0, -8 ; index 17
    equb  8, -8 ; index 18
    equb  0,  0 ; index 19
    equb  0,  0 ; index 20
    equb  0,  0 ; index 21
    equb  0,  0 ; index 22
    equb  0,  0 ; index 23
    equb  0,  0 ; index 24
    equb  0,  0 ; index 25
    equb  0,  0 ; index 26
    equb  0,  0 ; index 27

; ENHANCE: The following four values are just constants in practice, so
; references to them can be replaced by immediate operands.
.sprite_x_min
    equb 2
.sprite_x_max
    equb 150
.sprite_y_min
    equb 16
.sprite_y_max
    equb 254

; ENHANCE: Junk data, can delete TODO: but check this isn't used as index 30/31
; of sprite_delta_coord_table first
    equb 0, 0, 0, 0

; This table has four bytes per sprite slot; the following constants are used to
; indicate which byte is being accessed. We have a screen address where the
; sprite is currently shown (TODO: SEMI-GUESS the high byte is 0 if the sprite
; is not on screen) and the sprite image associated with the slot. Note that the
; sprite address is stored in big-endian format; this doesn't really make any
; difference, it's just slightly unconventional.
screen_addr_lo = 0
screen_addr_hi = 1
sprite_addr_hi = 2
sprite_addr_lo = 3
.sprite_screen_and_data_addrs
    equb 0, 0, >sprite_00, <sprite_00 ; sprite 0
    equb 0, 0, >sprite_00, <sprite_00 ; sprite 1
    equb 0, 0, >sprite_00, <sprite_00 ; sprite 2
    equb 0, 0, >sprite_00, <sprite_00 ; sprite 3
    equb 0, 0, >sprite_00, <sprite_00 ; sprite 4
    equb 0, 0, >sprite_00, <sprite_00 ; sprite 5
    equb 0, 0, >sprite_00, <sprite_00 ; sprite 6
    equb 0, 0, >sprite_00, <sprite_00 ; sprite 7
    equb 0, 0, >sprite_08, <sprite_08 ; sprite 8
    equb 0, 0, >sprite_09, <sprite_09 ; sprite 9
    equb 0, 0, >sprite_10, <sprite_10 ; sprite 10
    equb 0, 0, >sprite_11, <sprite_11 ; sprite 11
    equb 0, 0, >sprite_12, <sprite_12 ; sprite 12
    equb 0, 0, >sprite_13, <sprite_13 ; sprite 13
    equb 0, 0, >sprite_14, <sprite_14 ; sprite 14
    equb 0, 0, >sprite_15, <sprite_15 ; sprite 15
    equb 0, 0, >sprite_16, <sprite_16 ; sprite 16
    equb 0, 0, >sprite_17, <sprite_17 ; sprite 17
    equb 0, 0, >sprite_18, <sprite_18 ; sprite 18
    equb 0, 0, >sprite_19, <sprite_19 ; sprite 19
    equb 0, 0, >sprite_20, <sprite_20 ; sprite 20
    equb 0, 0, >sprite_21, <sprite_21 ; sprite 21
    equb 0, 0, >sprite_22, <sprite_22 ; sprite 22
    equb 0, 0, >sprite_23, <sprite_23 ; sprite 23
    equb 0, 0, >sprite_24, <sprite_24 ; sprite 24
    equb 0, 0, >sprite_25, <sprite_25 ; sprite 25
    equb 0, 0, >sprite_00, <sprite_00 ; sprite 26
    equb 0, 0, >sprite_00, <sprite_00 ; sprite 27
    equb 0, 0, >sprite_00, <sprite_00 ; sprite 28
    equb 0, 0, >sprite_00, <sprite_00 ; sprite 29
    equb 0, 0, >sprite_00, <sprite_00 ; sprite 30
    equb 0, 0, >sprite_00, <sprite_00 ; sprite 31
    equb 0, 0, >sprite_00, <sprite_00 ; sprite 32
    equb 0, 0, >sprite_00, <sprite_00 ; sprite 33
    equb 0, 0, >sprite_00, <sprite_00 ; sprite 34
    equb 0, 0, >sprite_00, <sprite_00 ; sprite 35
    equb 0, 0, >sprite_00, <sprite_00 ; sprite 36
    equb 0, 0, >sprite_00, <sprite_00 ; sprite 37
    equb 0, 0, >sprite_00, <sprite_00 ; sprite 38
    equb 0, 0, >sprite_00, <sprite_00 ; sprite 39
    equb 0, 0, >sprite_00, <sprite_00 ; sprite 40
    equb 0, 0, >sprite_00, <sprite_00 ; sprite 41
    equb 0, 0, >sprite_00, <sprite_00 ; sprite 42
    equb 0, 0, >sprite_00, <sprite_00 ; sprite 43
    equb 0, 0, >sprite_00, <sprite_00 ; sprite 44
    equb 0, 0, >sprite_00, <sprite_00 ; sprite 45
    equb 0, 0, >sprite_00, <sprite_00 ; sprite 46
    equb 0, 0, >sprite_00, <sprite_00 ; sprite 47

; Lookup table of the start addresses of character rows in screen memory. This
; is in descending order because we use an origin at the bottom left, whereas
; screen memory addresses have row 0 at the top.
; ENHANCE: If we're really desperate for space, we probably don't need all 32
; entries here.
.screen_row_addr_table
    for y, 31, 0, -1
        equw &5800 + y*320
    next

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
    for i, 1, 48
        equb 0, 0
    next

; Byte-per-sprite table which controls what happens when a sprite tries to move
; off the edges of the screen:
;     0 => clamp the sprite's position to the edge of the screen
;     1 => wrap the sprite's position to the opposite screen edge
;     2 => remove the sprite from the screen
; ENHANCE: This is always 1 for all sprites, so we can hard-code that behaviour
; and remove unreachable code and this table itself.
.sprite_wrap_behaviour_table
    for i, 1, 48
        equb 1
    next

; ENHANCE: Dead data as r_subroutine is not used, can be removed
.r_subroutine_inkey_code_1
    equb &bd
.r_subroutine_inkey_code_2
    equb &9e
.r_subroutine_inkey_code_3
    equb &b7
.r_subroutine_inkey_code_4
    equb &97
.r_subroutine_foo
    equb 0

; ENHANCE: Junk data, can be removed.
    equb 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0

.pydis_end

MAKE_IMAGE =? FALSE
if not(MAKE_IMAGE)
    save pydis_start, pydis_end
endif
