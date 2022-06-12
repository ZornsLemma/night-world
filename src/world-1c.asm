; TODO: The "on entry/on exit" style of documentation is perhaps unhelpful.
; Something a bit more free-form mixing inputs and outputs might be helpful.

MAKE_IMAGE =? FALSE

max_sprite_num = 48 ; 1-based
bytes_per_screen_row = 40*8 ; 40 (6845) characters, eight bytes each

; TODO: Move zp vars into the most restrictive scope possible
sprite_ptr = &0070
screen_ptr = &007a
screen_ptr2 = &007c
sprite_ptr2 = &007e

; slot_pixel_coord_table uses the special X/Y values to indicate that a
; sprite is out of bounds on a particular side of the screen. These values are
; unambiguous because (for X) there are only 160 pixels across the screen and
; (for Y) the pixel coordinates run up from origin at bottom left and specify
; the top left corner of the sprite, so the lowest valid Y on the screen is 15.
sprite_pixel_x_neg_inf = 254
sprite_pixel_x_pos_inf = 255
sprite_pixel_y_pos_inf = 0
sprite_pixel_y_neg_inf = 1

; Offsets used with the delta_table and slot_pixel_coord_table tables. The s_
; prefix is just to avoid confusion with the X and Y registers; think "s" for
; "struct member" if it helps.
s_x = 0
s_y = 1

; BASIC's resident integer variables @%, A%, ..., Z% (four bytes each) have
; fixed addresses in page &4. They are used extensively to communicate between
; BASIC and this machine code.
ri_a = &0404
ri_b = &0408
ri_e = &0414
ri_q = &0444
ri_r = &0448
ri_w = &045c
ri_x = &0460
ri_y = &0464
ri_z = &0468

if MAKE_IMAGE
    ; The original game code completes a cycle roughly every 0.06s.
    game_cycle_tick_interval = 6

    ; The original BASIC code played a note of the background music once every four
    ; game cycles, so by following that we should keep approximately the same
    ; playback speed, although more consistent. TODO: It is just possible that it
    ; would be better to use a different interval to get the speed closer.
    music_tick_interval = game_cycle_tick_interval * 4

    evntv = &220
    cnpv = &22e
    osword = &fff1
    osbyte = &fff4
    osbyte_enable_event = 14
    event_interval = 5
    event_interval_flag = &2c4 ; TODO: different address on Electron
    interval_timer = &29c ; TODO: different address on Electron - we could *probably* just use OSWORD to write this
    show_tick_count = TRUE; TODO: should be off in a "final" build
    sound_channel_1_buffer_number = 5
    sound_channel_2_buffer_number = 6
endif

if MAKE_IMAGE
    ; TODO: Now that the room data has been shrunk, we can probably move all the
    ; machine code up. This would require tweaking world-1c-wrapper.asm and the
    ; CALL to it in world-1b.bas.
    assert &3600-P% < 256
    skipto &3600
    guard &5800
else
    org &35bc
endif
.pydis_start

if MAKE_IMAGE
; ENHANCE: This packs eight bits to a word, but it may be that run length
; compression (bearing in mind we only have two states - block or no block - so
; we can just encode the number of cells between those two transitions) would be
; even better.
.draw_room_subroutine
{
room_ptr = &70
udg = &72
chars_to_next_transition = &73
room_size_chars = 20*18
room_size_bytes = room_size_chars/8
initial_udg = 226
chars_between_transitions = 60
vdu_right = 9

    ; The BASIC code calls this with room_ptr set to (1-based room number)*room_size_bytes.
    ; Add on the correct base to get a pointer.
    clc
    lda room_ptr+0:adc #<(room_data_01-room_size_bytes):sta room_ptr+0
    lda room_ptr+1:adc #>(room_data_01-room_size_bytes):sta room_ptr+1
    ; We switch user-defined graphic every 60 characters, giving a gradient
    ; effect.
    lda #initial_udg:sta udg
    lda #chars_between_transitions:sta chars_to_next_transition

    ldx #131:ldy #2:jsr set_text_colours

    ldy #255
.byte_loop
    iny:lda (room_ptr),y:ldx #7
.bit_loop
    asl a:pha
    lda #vdu_right:bcc char_in_a
    lda udg
.char_in_a
    jsr oswrch
    dec chars_to_next_transition:bne no_transition
    inc udg:lda udg:cmp #initial_udg+(room_size_chars/chars_between_transitions):beq done
    lda #chars_between_transitions:sta chars_to_next_transition
.no_transition
    pla
    dex:bpl bit_loop
    bmi byte_loop
.done
    pla
    ldx #128:ldy #2
.set_text_colours
    lda #17:jsr oswrch:txa:jsr oswrch
    lda #17:jsr oswrch:tya:jmp oswrch
}
endif

; ENHANCE: Rooms are 20x18 mode 5 character cells in size. They are packed two
; cells to a byte; it would be possible to pack eight cells to a byte with
; slightly cleverer unpacking code, which would free up some extra memory. (14
; rooms currently take 2520 bytes which would reduce to 630 bytes, saving 1890
; bytes less any small loss for the more complex unpacking code.) Simple
; run-length coding might also work well; we could for example just store the
; number of bytes to the next transition, as we only have two states.

if not(MAKE_IMAGE)

macro room_row n
    for i, 9, 0, -1
        equb (n >> (i*2)) and %11
    next
endmacro

include "src/rooms.asm"

; ENHANCE: This is just junk data and could be deleted.
    equb 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0
    equb 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0
    equb 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0
    equb 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0
    equb 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0
    equb 0, 0, 0
else

include "src/rooms-packed.asm"

endif

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

if MAKE_IMAGE
{
.^tune_pitch
    equb 116, 88, 116, 0, 116, 120, 116, 0, 116, 88, 116, 116, 116, 120, 116, 0
    equb 116, 72, 100, 0, 100, 108, 100, 0, 100, 72, 100, 100, 100, 108, 100, 0
    equb 52, 32, 80, 0, 80, 88, 80, 0, 52, 32, 80, 80, 80, 88, 80, 0, 32, 32, 60
    equb 0, 60, 68, 60, 0, 60, 32, 60, 60, 60, 68, 60, 0, 0, 0, 0, 0, 0, 0
tune_length = P% - tune_pitch
.^tune_duration
    equb 3, 3, 2, 0, 3, 3, 3, 0, 2, 2, 2, 2, 2, 2, 2, 0, 3, 3, 3, 0, 3, 3, 3, 0
    equb 2, 2, 2, 2, 2, 2, 2, 0, 3, 3, 3, 0, 3, 3, 3, 0, 2, 2, 2, 2, 2, 2, 2, 0
    equb 3, 3, 3, 0, 3, 3, 3, 0, 2, 2, 2, 2, 2, 2, 2, 0, 0, 0, 0, 0, 0, 0
    assert (P% - tune_duration) == tune_length

.^current_note
    equb 0

.ticks_left_in_game_cycle
    equb 1

.ticks_left_in_music_cycle
    equb 1

; TODO: Name for this is not great, particularly with the change to discard the
; sound if the buffer has something in already rather than just to avoid
; blocking when the buffer is full.
; TODO: I think I've ruined things a bit with the, stand under the wall-eater in room C so you're being permanently damaged and the sound is broken up. Perhaps just need to allow slightly more sounds into the queue?!
.^sound_nonblocking
    ldx #sound_channel_1_buffer_number:clv:clc:jsr jmp_cnpv
    cpx #2:bcs rts ; do nothing if the buffer has >=2 entries already
    lda ri_a:sta osword_7_block2_amplitude ; TODO: will only work for envelopes as we only set low byte
    lda ri_b:sta osword_7_block2_pitch
    lda ri_e:sta osword_7_block2_duration
    lda #7:ldx #<osword_7_block2:ldy #>osword_7_block2:jmp osword
.rts ; TODO: can I re-use another rts?
    rts

.osword_7_block2 ; TODO: poor naming of the two osword_7_blocks
    equw 1 ; channel
.osword_7_block2_amplitude
    equw 0
.osword_7_block2_pitch
    equw 0
.osword_7_block2_duration
    equw 0

.^interval_event_handler
    ; We assume it's an interval event; we won't enable anything else.
    ; TODO: It's hardly a big deal, but could we get away without php:pha? OS
    ; 1.20 at least appears to save these itself before calling EVNTV, and since
    ; we know we're the only event handler probably nothing would care even if
    ; the OS didn't save them.
    php:pha

    txa:pha ; SFTODO HACKY
    jsr set_interval_timer ; interrupts will be disabled as we're in an event handler
    pla:tax

    ; Decrement ticks_left_in_game_cycle, clamping it at -127 (=128) so in the
    ; (extremely unlikely) event we take that long to process a game cycle, we
    ; won't introduce extra time waiting for the counter to hit zero.
    dec ticks_left_in_game_cycle
    lda ticks_left_in_game_cycle:cmp #127:bne dont_clamp_ticks_left
    inc ticks_left_in_game_cycle
.dont_clamp_ticks_left

    dec ticks_left_in_music_cycle:bne music_cycle_not_finished
    txa:pha:tya:pha
    lda #music_tick_interval:sta ticks_left_in_music_cycle
    ; Check how much free space there is in sound channel 2's buffer; we must
    ; avoid blindly adding more as we'll block here if the buffer becomes full.
    ; TODO: Do we need to be careful to keep as little as possible in the
    ; buffer? It depends exactly how the game turns this background music on
    ; and off, which it will need to do when it's doing "effects" (e.g. day/
    ; night transition).
    ldx #sound_channel_2_buffer_number:clv:sec:jsr jmp_cnpv
    cpx #5:bcc dont_play_note ; buffer is nearly full, do nothing TODO: 5 is arbitrary (FWIW empty buffer has 15 bytes free)
    ; TODO: It's not a huge deal, but the way world-2.bas is poking current_note
    ; *could* get lost if this code is executing at precisely the wrong time.
    ; Is there a neat way to avoid this? - Actually this is probably fine, bearing in mind *this* code is atomic - but think about it from scratch
    ldx current_note
    lda tune_pitch,x:sta osword_7_block_pitch
    lda tune_duration,x:sta osword_7_block_duration
    jsr make_sound:inc osword_7_block_channel
    jsr make_sound:dec osword_7_block_channel
    ldx current_note:cpx #tune_length-1:bne not_last_note
    ldx #255
.not_last_note
    inx:stx current_note
.dont_play_note
    pla:tay:pla:tax
.music_cycle_not_finished

    pla:plp
    rts

; Interrupts must be disabled while calling this.
.set_interval_timer
    lda #&ff:ldx #4
.set_interval_timer_loop
    sta interval_timer,x:dex:bpl set_interval_timer_loop
    rts

.event_interval_disabled
    sei:jsr set_interval_timer:cli
    lda #osbyte_enable_event:ldx #event_interval:jsr osbyte
    jmp reset_game_cycle_tick_interval

.jmp_cnpv
    jmp (cnpv)

.make_sound
    lda #7:ldx #<osword_7_block:ldy #>osword_7_block:jmp osword

.osword_7_block
.osword_7_block_channel
    equw 2
    equw -5 ; amplitude
.osword_7_block_pitch
    equw 0
.osword_7_block_duration
    equw 0

; The main game loop in BASIC calls q_subroutine exactly once per game cycle, so it's
; a convenient point to introduce our speed limiting. We also use this as an opportunity
; to enable interval events; the BASIC code then doesn't need to worry about this, it just
; needs to disable interval events when it leaves the main game loop temporarily.
; TODO: Should I use the *interval timer crossing zero* even to get 100Hz callbacks?
; Apart from extra resolution, this would also allow me to *reset* the timer - bearing in
; mind we are not trying to use vsync to avoid tearing or anything like that - so we start
; each game cycle with the full desired time. Actually I suppose we could also set the timer
; to go off every 3/50ths second or whatever rather than having 100Hz ticks if desired.
.^q_subroutine_wrapper
    lda event_interval_flag:beq event_interval_disabled

if show_tick_count
    ldx #7
.show_tick_count_loop
    lda &5800-1,x:sta &5800,x
    dex:bne show_tick_count_loop
endif

.busy_wait
if show_tick_count
    ; We would really like A>=1 here, as that means we are actively busy-waiting
    ; and we thus completed the game cycle's processing in at least slightly
    ; less than game_cycle_tick_interval ticks. Store A-1 in the debug
    ; indicator in video RAM, since that will make the "good" cases all >=0 and
    ; the "bad" cases ~&Fx, which will have a more distinctive appearance.
    ldx ticks_left_in_game_cycle:dex:stx &5800
endif
    lda ticks_left_in_game_cycle
    beq reset_game_cycle_tick_interval:bpl busy_wait
.reset_game_cycle_tick_interval
    ; TODO: I am wondering if this is "wrong"/unfair/unhelpful when we haven't actually done any busy-waiting - partly but not entirely, is there a danger this update is going to get trampled on by the vsync event, so maybe we should sei around this?
    ; TODO: What I'm kind of thinking is something like: we take 3.5 ticks for one game cycle, so we come in here with ticks_left=&ff and half a tick already gone. we set ticks_left to 3, but because half a tick has already gone, if we take 2.9 ticks for the next cycle (thus actually beating the deadline), we will see ticks_left=0 here and think that we've at best just scraped in and most likely failed to hit the deadline.
    ; TODO: Just thinking out loud - could/should we attempt to hit the deadline *on average*? Maybe if we're a tick "ahead" of the deadline in one cycle, we should save that up and allow ourselves to start the next cycle immediately, as long as we're not getting multiple ticks ahead. Something like that.
    lda #game_cycle_tick_interval:sta ticks_left_in_game_cycle

    ; The BASIC used to do W%=SLOT_LEE:Y%=8 before calling Q%; it's trivial to
    ; do this in machine code, so we do.
    lda #10:sta ri_w
    lda #8:sta ri_y
    assert P% = q_subroutine ; fall through to q_subroutine
}
endif

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
slot_index_x2 = &71
abs_x_difference = &72
abs_y_difference = &73
overlap_direction = &74

; This is the conceptual width; sprite data is actually 12 pixels wide but only
; nine adjacent columns within the sprite will be non-black.
sprite_width_pixels = 9
sprite_height_pixels = 16

    lda ri_w:beq no_collision_found
    cmp #max_sprite_num+1:bcs no_collision_found
    sec:sbc #1
    asl a:tax
    asl a:tay
    ; If sprite slot W% is not on screen, it can't have any collisions.
    lda slot_addr_table+screen_addr_hi,y:beq no_collision_found
    stx slot_index_x2
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
    ;
    ; This code doesn't actually check to see if candidates are on screen; in
    ; MAKE_IMAGE builds we work around this by setting the Y pixel coordinate to
    ; 0 in s_subroutine when we remove a sprite from the screen.
    lda #0
.y_loop
    cmp slot_index_x2:beq next_candidate ; W% can't collide with itself
    tay
    lda #5:sta overlap_direction
    lda slot_pixel_coord_table+s_x,x:sec:sbc slot_pixel_coord_table+s_x,y
    ; TODO: This BMI feels wrong (e.g. 0-140=-140=116, so the answer will look
    ; positive when it isn't) and as though using BCS/BCC would be better. I'm
    ; not that confident about this though. I did write a program to test all
    ; the cases in the range 0-159 and in practice it works fine, and I can
    ; kinda-sorta see why it probably is fine.
    bmi negate_x_difference_and_inc_overlap_direction
    beq test_abs_x_difference
    dec overlap_direction
.test_abs_x_difference
    ; TODO: "Logically" this should be cmp #sprite_width_pixels+1, shouldn't it?
    ; See comment on test_abs_y_difference below.
    cmp #sprite_width_pixels:bcs next_candidate
    ; abs(W%'s X coord, candidate's X coord) <= sprite_width_pixels, so the two
    ; overlap in the X dimension. Check for Y overlap now.
    sta abs_x_difference
    lda slot_pixel_coord_table+s_y,x
    sec:sbc slot_pixel_coord_table+s_y,y
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
    ; perfectly. This doesn't seem to be used in practice. We corrupt
    ; abs_y_difference in the process as we don't need it any more.
    lda abs_x_difference:asl a:adc abs_y_difference:sta abs_y_difference
    lda #35:sec:sbc abs_y_difference:sta ri_y
    ; Set Z% to overlap_detection. This doesn't seem to be used in practice.
    lda overlap_direction:sta ri_z
    ; Set X% to the 1-based logical sprite number we found a collision
    ; with.
    iny:iny:tya:lsr a:sta ri_x
.^q_subroutine_rts
if MAKE_IMAGE
.^r_subroutine_rts
endif
    rts
}

if not(MAKE_IMAGE)
; This seems to be keyboard-reading code which is never used in practice, so I
; haven't attempted to fully disassemble it.
; ENHANCE: This can obviously be removed.
.r_subroutine
{
osbyte_inkey = &81
osbyte_clear_escape = &7c
osbyte = &fff4
l0075 = &0075

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
endif

{
sprite_pixel_current_x = &72
l0073 = &73
l0074 = &0074
sprite_y_offset_within_row = &75
sprite_pixel_x_lo = &0076
sprite_pixel_y_lo = &0077

; ENHANCE: This subroutine seems a bit over-zealous about clearing carry and
; could probably be simplified and clarified by clearing it only when we finally
; need it cleared.

.clc_remove_sprite_from_screen
    clc
    jmp remove_sprite_from_screen

; Sprite display subroutine.
;
; On entry:
;     W% is the sprite slot we want to work with
;
;     Y% is: 0 to move an already displayed sprite
;            1 to show a previously invisible sprite
;            2 to remove an already displayed sprited
;
;     If Y% is 0 or 1, the OS coordinates for the new sprite position are taken
;     from the pair of coordinate resident integer variables for slot W%.
;
; TODO: I suspect there are some subtleties around sprites not currently shown
; or off-screen and some of those may be interesting in practice, so need to
; investigate these aspects.
.^s_subroutine
    lda ri_w:beq r_subroutine_rts
    cmp #max_sprite_num+1:bcs r_subroutine_rts
    sec:sbc #1
    ldx ri_y:cpx #2:beq clc_remove_sprite_from_screen
    jsr get_sprite_details
    lda slot_pixel_coord_table+s_x,x:cmp #sprite_pixel_x_neg_inf:bcs clc_remove_sprite_from_screen
    lda slot_pixel_coord_table+s_y,x:cmp #sprite_pixel_y_neg_inf+1:bcc clc_remove_sprite_from_screen
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
    lda slot_addr_table+screen_addr_lo,x:sta screen_ptr2
    lda slot_addr_table+screen_addr_hi,x:sta screen_ptr2+1
    lda screen_ptr:sta slot_addr_table+screen_addr_lo,x
    lda screen_ptr+1:sta slot_addr_table+screen_addr_hi,x
    lda sprite_pixel_x_lo:and #3
    asl a:asl a:asl a:asl a:sta l0073
    asl a:adc l0073 ; we know carry is clear after asl a
    adc slot_addr_table+sprite_addr_lo,x
    sta sprite_ptr
    lda slot_addr_table+sprite_addr_hi,x:adc #0:sta sprite_ptr+1
    lda ri_y:cmp #1:beq clc_jmp_plot_sprite
    lda screen_ptr2+1:beq clc_jmp_plot_sprite
    lda sprite_pixel_current_x:and #3
    asl a:asl a:asl a:asl a:sta l0073
    asl a:adc l0073 ; we know carry is clear after asl a
    adc slot_addr_table+sprite_addr_lo,x:sta sprite_ptr2
    lda slot_addr_table+sprite_addr_hi,x:adc #0:sta sprite_ptr2+1
    clc
    jmp move_sprite

.clc_jmp_plot_sprite
    clc
    jmp plot_sprite

.remove_sprite_from_screen
    ; A is the 0-based sprite slot derived from W%.
    asl a:tay
    asl a:tax
    lda slot_addr_table+screen_addr_lo,x:sta screen_ptr
    lda slot_addr_table+screen_addr_hi,x:beq s_subroutine_rts2
    sta screen_ptr+1
    lda slot_pixel_coord_table+s_x,y:and #3
    asl a:asl a:asl a:asl a:sta l0073
    asl a:adc l0073 ; we know carry is clear after asl a
    adc slot_addr_table+sprite_addr_lo,x:sta sprite_ptr
    lda slot_addr_table+sprite_addr_hi,x:adc #0:sta sprite_ptr+1
    lda #0
    sta slot_addr_table+screen_addr_lo,x
    sta slot_addr_table+screen_addr_hi,x
if MAKE_IMAGE
    ; Set the Y pixel coordinate of the sprite to 0; this will in practice stop
    ; it being detected as a collision in q_subroutine given that is only used
    ; to check against the player sprite.
    sta slot_pixel_coord_table+s_y,y
endif
    clc
    jmp plot_sprite

.s_subroutine_rts2
    rts

; On entry:
;     A is the 0-based sprite slot derived from W%.
;
; On exit:
;     sprite_pixel_{x,y}_lo are the pixel coordinates corresponding to the
;     slot's resident integer variable OS coordinates. These are not bounds
;     checked, although I believe in practice they will always be in bounds.
;
;     sprite_pixel_current_{x,y} are the current pixel coordinates of the sprite
;     from slot_pixel_coord_table. (ENHANCE: As it happens,
;     sprite_pixel_current_y is never used.)
;
;     slot_pixel_coord_table is updated to have the values returned in
;     sprite_pixel_{x,y}_lo after applying the configured wrapping behaviour for
;     out-of-bounds coordinates.
;
; ENHANCE: This is probably over-zealous in ensuring carry clear on exit.
.get_sprite_details
{
sprite_pixel_current_y = &73
sprite_pixel_x_hi = &78
sprite_pixel_y_hi = &79
l0075 = &75
slot = &7c
l007d = &7d

    sta slot
    ; Calculate the offset of this sprite slot's coordinate resident integer
    ; variables in Y.
    asl a:tax:sta l007d ; ENHANCE: value stored is never used
    asl a:sta l0074 ; TODO: GIVE THIS A NAME AND DOCUMENT IT IN COMMENT ABOVE, IT'S USED TO RETURN VAL TO CALLER
    asl a:and #(ri_coord_vars-1)<<3:tay:sty l0075 ; ENHANCE: value stored is never used
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
    ldy slot
    ; Copy the current pixel coordinates into sprite_pixel_current_{x,y}.
    lda slot_pixel_coord_table+s_x,x:sta sprite_pixel_current_x
    lda slot_pixel_coord_table+s_y,x:sta sprite_pixel_current_y
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
    sta slot_pixel_coord_table+s_x,x
    clc:bcc check_y_position ; always branch
.x_position_too_far_right
    lda slot_wrap_behaviour_table,y:beq force_x_position_to_sprite_x_max
    cmp #1:beq force_x_position_to_sprite_x_min
    lda #sprite_pixel_x_pos_inf:sta slot_pixel_coord_table+s_x,x
    bne check_y_position ; always branch
.force_x_position_to_sprite_x_max
    lda sprite_x_max:sta slot_pixel_coord_table+s_x,x:sta sprite_pixel_x_lo
    clc:bcc check_y_position
.x_position_too_far_left
    lda slot_wrap_behaviour_table,y:beq force_x_position_to_sprite_x_min
    cmp #1:beq force_x_position_to_sprite_x_max
    lda #sprite_pixel_x_neg_inf:sta slot_pixel_coord_table+s_x,x
    bne check_y_position ; always branch
.force_x_position_to_sprite_x_min
    lda sprite_x_min:sta slot_pixel_coord_table+s_x,x:sta sprite_pixel_x_lo
    clc:bcc check_y_position
.y_position_is_8_bit
    lda sprite_pixel_y_lo
    cmp sprite_y_min:bcc y_position_too_far_down
    cmp sprite_y_max:beq y_position_ok:bcs y_position_too_far_up
.y_position_ok
    sta slot_pixel_coord_table+s_y,x
    clc
    rts
.y_position_too_far_up
    lda slot_wrap_behaviour_table,y:beq force_y_position_to_sprite_y_max
    cmp #1:beq force_y_position_to_sprite_y_min
    lda #sprite_pixel_y_pos_inf:sta slot_pixel_coord_table+s_y,x
    clc
    rts
.force_y_position_to_sprite_y_max
    lda sprite_y_max:sta slot_pixel_coord_table+s_y,x:sta sprite_pixel_y_lo
    clc
    rts
.y_position_too_far_down
    lda slot_wrap_behaviour_table,y:beq force_y_position_to_sprite_y_min
    cmp #1:beq force_y_position_to_sprite_y_max
    lda #sprite_pixel_y_neg_inf:sta slot_pixel_coord_table+s_y,x
    clc
    rts
.force_y_position_to_sprite_y_min
    lda sprite_y_min:sta slot_pixel_coord_table+s_y,x:sta sprite_pixel_y_lo
    clc
    rts
} ; end get_sprite_details scope

; "One-shot" sprite plot routine, for showing or hiding a sprite as opposed to
; erasing-and-replotting a sprite.
;
; On entry:
;     screen_ptr points to the byte of screen memory corresponding to the top
;     left part of the sprite.
;
;     sprite_ptr points to the first byte of the correct frame of the sprite's
;     image data.
;
; ENHANCE: This is probably over-zealous at ensuring carry is clear.
.plot_sprite
{
row_index = &75
next_row_adjust = bytes_per_screen_row-7

    lda #1:sta row_index
.outer_loop
    ldx #8
.inner_loop
    ldy # 0:lda (screen_ptr),y:eor (sprite_ptr),y:sta (screen_ptr),y
    ldy # 8:lda (screen_ptr),y:eor (sprite_ptr),y:sta (screen_ptr),y
    ldy #16:lda (screen_ptr),y:eor (sprite_ptr),y:sta (screen_ptr),y
    lda screen_ptr:and #7:eor #7:beq screen_ptr_row_wrap
    inc screen_ptr
.screen_ptr_row_wrap_handled
    inc sprite_ptr:beq sprite_ptr_carry
.sprite_ptr_carry_handled
    dex:bne inner_loop
    lda sprite_ptr:adc #16:sta sprite_ptr:bcc no_carry
    inc sprite_ptr+1:clc
.no_carry
    dec row_index:beq outer_loop
    rts
.screen_ptr_row_wrap
    lda screen_ptr  :adc #<next_row_adjust:sta screen_ptr
    lda screen_ptr+1:adc #>next_row_adjust:sta screen_ptr+1
    bne screen_ptr_row_wrap_handled ; always branch
.sprite_ptr_carry
    inc sprite_ptr+1:clc
    bne sprite_ptr_carry_handled ; always branch
} ; end plot_sprite scope
} ; end s_subroutine scope

; Erase-and-replot sprite plot routine, for moving a sprite already on the
; screen.
;
; On entry:
;     screen_ptr{,2} points to the byte of screen memory corresponding to the
;     top left part of the sprite in old/new position.
;
;     sprite_ptr{,2} points to the first byte of the correct frame of the
;     sprite's old/new image data.
;
;     Because EOR plotting is used, this routine doesn't care whether the "no
;     suffix" or "2 suffix" pointers correspond to the old or new position.
;
; ENHANCE: This is probably over-zealous at ensuring carry is clear.
.move_sprite
{
row_index = &75
next_row_adjust = bytes_per_screen_row-7

    lda #1:sta row_index
    sei
.outer_loop
    ldx #8
.inner_loop
    ldy # 0:lda (screen_ptr2),y:eor (sprite_ptr2),y:sta (screen_ptr2),y
            lda (screen_ptr ),y:eor (sprite_ptr ),y:sta (screen_ptr ),y
    ldy # 8:lda (screen_ptr2),y:eor (sprite_ptr2),y:sta (screen_ptr2),y
            lda (screen_ptr ),y:eor (sprite_ptr ),y:sta (screen_ptr ),y
    ldy #16:lda (screen_ptr2),y:eor (sprite_ptr2),y:sta (screen_ptr2),y
            lda (screen_ptr ),y:eor (sprite_ptr ),y:sta (screen_ptr ),y
    lda screen_ptr:and #7:eor #7:beq screen_ptr_row_wrap
    inc screen_ptr
.screen_ptr_row_wrap_handled
    lda screen_ptr2:and #7:eor #7:beq screen_ptr2_row_wrap
    inc screen_ptr2
.screen_ptr2_row_wrap_handled
    inc sprite_ptr:beq sprite_ptr_carry
.sprite_ptr_carry_handled
    inc sprite_ptr2:beq sprite_ptr2_carry
.sprite_ptr2_carry_handled
    dex:bne inner_loop
    lda sprite_ptr:adc #16:sta sprite_ptr:bcc no_carry
    inc sprite_ptr+1:clc
.no_carry
    lda sprite_ptr2:adc #16:sta sprite_ptr2:bcc no_carry2
    inc sprite_ptr2+1:clc
.no_carry2
    dec row_index:beq outer_loop
.^cli_rts
    cli
    rts
.screen_ptr_row_wrap
    lda screen_ptr  :adc #<next_row_adjust:sta screen_ptr
    lda screen_ptr+1:adc #>next_row_adjust:sta screen_ptr+1
    bne screen_ptr_row_wrap_handled ; always branch
.screen_ptr2_row_wrap
    lda screen_ptr2  :adc #<(bytes_per_screen_row-7):sta screen_ptr2
    lda screen_ptr2+1:adc #>(bytes_per_screen_row-7):sta screen_ptr2+1
    bne screen_ptr2_row_wrap_handled ; always branch
.sprite_ptr_carry
    inc sprite_ptr+1:clc
    bne sprite_ptr_carry_handled ; always branch
.sprite_ptr2_carry
    inc sprite_ptr2+1:clc
    bne sprite_ptr2_carry_handled ; always branch
}

; Sprite position adjustment subroutine.
;
; On entry:
;     W% is the sprite slot we want to work with.
;
;     Z% specifies the entry in delta_table to apply to the sprite's current
;     position.
;
; On exit:
;     No-op if slot W% isn't on screen. Otherwise the sprite's position has been
;     updated both on screen and in the internal data structures according to
;     Z%.
;
; ENHANCE: There appears to be some asymmetric handling of sprites which are
; off-screen with positive/negative infinite co-ordinates; moving "further" in
; the infinite direction causes a wrap to the opposite side of the screen,
; moving "closer" does not cause the sprite to move back on the "same "side of
; the screen. I suspect this isn't actually used by Night World, so could be
; removed.
;
; ENHANCE: I think there's no need for the branches to cli_rts here, we could
; just branch to the rts.
.t_subroutine
{
os_x_hi = &70
os_x_lo = &71
os_y_hi = &72
constant_1 = &73 ; ENHANCE: just use #1 for this
ri_coord_index = &76
slot_index_x4 = &7e
slot_index_x2 = &7f

    lda ri_w:beq cli_rts
    cmp #max_sprite_num+1:bcs cli_rts
    sec:sbc #1:tay
    lda ri_z:beq cli_rts
    ; delta_table entries at (1-based) offsets 10 and 5 are no-ops; special case these,
    ; presumably for speed. ENHANCE: Do we actually benefit from this in practice?
    cmp #10:beq cli_rts
    cmp #5:beq cli_rts
    cmp #20:bcs cli_rts ; invalid Z% values are also no-ops
    sec:sbc #1:asl a:tax
    lda #0:sta ri_y:sta os_x_hi:sta os_y_hi
    lda #1:sta constant_1
    tya:asl a:sta slot_index_x2
    tay:asl a:sta slot_index_x4
    and #(ri_coord_vars<<3)-1:asl a:sta ri_coord_index
    lda slot_pixel_coord_table+s_x,y:cmp #sprite_pixel_x_neg_inf:bcs x_pixel_coord_is_special
    ldy slot_index_x4:lda slot_addr_table+screen_addr_hi,y:beq cli_rts
    ldy slot_index_x2
    lda delta_table+s_x,x:bmi add_negative_x_delta
    clc:adc slot_pixel_coord_table+s_x,y:bcs new_x_coord_carry
.x_pixel_coord_in_a
    asl a:rol os_x_hi
    asl a:rol os_x_hi
    asl a:rol os_x_hi
    sta os_x_lo
.update_y_pixel_coord
    lda slot_pixel_coord_table+s_y,y:cmp #sprite_pixel_y_neg_inf+1:bcc y_pixel_coord_is_special_indirect
    lda delta_table+s_y,x:bmi add_negative_y_delta
    clc:adc slot_pixel_coord_table+s_y,y:bcs new_y_pixel_coord_gt_255
.y_pixel_coord_in_a
    asl a:rol os_y_hi
    asl a:rol os_y_hi
    tax
.set_ri_os_coords_y_lo_in_x_and_jmp_s_subroutine
    ldy ri_coord_index
    lda os_x_lo:sta ri_a,y
    lda os_x_hi:sta ri_a+1,y
    lda os_y_hi:sta ri_b+1,y
    txa:sta ri_b,y
    jmp s_subroutine
    equb &60 ; ENHANCE: junk byte, can be deleted
.y_pixel_coord_is_special_indirect
    bcc y_pixel_coord_is_special ; always branch
.new_x_pixel_coord_lt_0
    dec os_x_hi
    bcc x_pixel_coord_in_a ; always branch
.x_pixel_coord_is_special
    beq x_pixel_coord_is_neg_inf
    lda delta_table+s_x,x:beq update_y_pixel_coord_indirect
    cmp #&80 ; ENHANCE: use N from preceding lda to eliminate this
    bcs update_y_pixel_coord_indirect
    lda sprite_x_min
.new_x_pixel_coord_in_a
    sta slot_pixel_coord_table+s_x,y
    asl a:rol os_x_hi
    asl a:rol os_x_hi
    asl a:rol os_x_hi
    sta os_x_lo
    bne update_y_pixel_coord ; TODO: always branch??
.x_pixel_coord_is_neg_inf
    lda delta_table+s_x,x
    cmp #&80 ; ENHANCE: use N from preceding lda to eliminate this
    bcc update_y_pixel_coord_indirect
    lda sprite_x_max
    bne new_x_pixel_coord_in_a ; always branch
.new_x_coord_carry
    inc os_x_hi
    bne x_pixel_coord_in_a ; always branch
.add_negative_x_delta
    clc:adc slot_pixel_coord_table+s_x,y
    bcc new_x_pixel_coord_lt_0
    bcs x_pixel_coord_in_a
.update_y_pixel_coord_indirect
    lda #1:sta constant_1
    bne update_y_pixel_coord ; always branch
.new_y_pixel_coord_gt_255
    inc os_y_hi
    bne y_pixel_coord_in_a ; always branch
.add_negative_y_delta
    clc:adc slot_pixel_coord_table+s_y,y
    bcc new_y_pixel_coord_lt_0
    bcs y_pixel_coord_in_a
.new_y_pixel_coord_lt_0
    dec os_y_hi
    bcc y_pixel_coord_in_a ; TODO: always branch??
.y_pixel_coord_is_special
    cmp #sprite_pixel_y_neg_inf:beq y_pixel_coord_is_neg_inf
    lda delta_table+s_y,x:beq t_subroutine_rts
    cmp #&80 ; ENHANCE: use N from preceding lda to eliminate this
    bcs t_subroutine_rts
    lda sprite_y_min
.x_pixel_coord_in_a_2
    sta slot_pixel_coord_table+s_y,y
    asl a:rol os_y_hi
    asl a:rol os_y_hi
    asl a:rol os_y_hi
    tax
    lda constant_1:bne set_ri_os_coords_y_lo_in_x_and_jmp_s_subroutine_indirect ; always branch
.^t_subroutine_rts
    rts
.y_pixel_coord_is_neg_inf
    lda delta_table+s_y,x
    cmp #&80 ; ENHANCE: use N from preceding lda to eliminate this
    bcc t_subroutine_rts
    lda sprite_y_max
    bne x_pixel_coord_in_a_2 ; always branch
.set_ri_os_coords_y_lo_in_x_and_jmp_s_subroutine_indirect
    jmp set_ri_os_coords_y_lo_in_x_and_jmp_s_subroutine
}

; Sprite update/query subroutine.
;
; On entry:
;     W% is the sprite slot we want to work with.
;
;     X%=0 queries the sprite's current location.
;     X%>0 is the sprite image index to associate with the sprite slot.
;
; On exit:
;     If X%=0, the sprite slot's coordinate resident integer variables contain
;     the sprite's current position.
;
;     If X%>0 and the sprite is visible, the sprite slot's associated image will
;     be changed to X% on the screen and in the internal data structures. This
;     is a no-op if the sprite is not visible. (In MAKE_IMAGE builds, the
;     requirement the sprite is visible is removed.)
.u_subroutine
{
l0070 = &0070
l0071 = &0071
l0072 = &0072
l0073 = &0073

    lda ri_w:beq t_subroutine_rts
    cmp #max_sprite_num+1:bcs t_subroutine_rts
    sec:sbc #1
    ldx ri_x:beq return_coords
    cpx #max_sprite_num+1:bcs t_subroutine_rts
    asl a:tay
    asl a:tax
    lda slot_addr_table+screen_addr_lo,x:sta screen_ptr2:sta screen_ptr
if not(MAKE_IMAGE)
    lda slot_addr_table+screen_addr_hi,x:beq t_subroutine_rts
    sta screen_ptr2+1:sta screen_ptr+1
endif
    ; Get the sprite's X pixel coordinate and use its low two bits to select one
    ; of the four pre-shifted variants, each of which occupies 48=%110000 bytes,
    ; hence the pattern of shifts and adds.
    lda slot_pixel_coord_table+s_x,y:and #3:asl a:asl a:asl a:asl a:sta l0073
    asl a:adc l0073:sta l0072 ; leaves carry clear
    adc slot_addr_table+sprite_addr_lo,x:sta sprite_ptr2
    lda slot_addr_table+sprite_addr_hi,x:adc #0:sta sprite_ptr2+1
    lda ri_x:sec:sbc #1:asl a:tay
    ; ENHANCE: sec:sbc will have left carry set, but we probably want it clear
    ; here. That's probably true, but I think there's a bigger problem here,
    ; which is that we're setting a sub-frame not the "base" address in slot_addr_table.
; TODO: HACKETY HACK
if MAKE_IMAGE
    lda sprite_ref_addrs_be+1,y:sta slot_addr_table+sprite_addr_lo,x:clc:adc l0072:sta sprite_ptr
    lda sprite_ref_addrs_be+0,y:sta slot_addr_table+sprite_addr_hi,x:adc #0:sta sprite_ptr+1
else
    lda l0072:adc sprite_ref_addrs_be+1,y:sta slot_addr_table+sprite_addr_lo,x:sta sprite_ptr
    lda sprite_ref_addrs_be,y:adc #0:sta slot_addr_table+sprite_addr_hi,x:sta sprite_ptr+1
endif
if MAKE_IMAGE
    ; Allow U% to update the sprite image associated with a slot even if it's not currently
    ; displayed; we just don't touch the screen in this case.
    lda slot_addr_table+screen_addr_hi,x:beq t_subroutine_rts
    sta screen_ptr2+1:sta screen_ptr+1
endif
    jmp move_sprite

.return_coords
    asl a:tax
    asl a:tay
    lda slot_addr_table+screen_addr_hi,y:beq rts
    tya:asl a:and #(ri_coord_vars<<3)-1:tay
    lda #0:sta l0070:sta l0071
    lda slot_pixel_coord_table+s_x,x
    asl a:rol l0070
    asl a:rol l0070
    asl a:rol l0070
    sta ri_a,y:lda l0070:sta ri_a+1,y
    lda slot_pixel_coord_table+s_y,x
    asl a:rol l0071
    asl a:rol l0071
    sta ri_b,y:lda l0071:sta ri_b+1,y
.rts
    rts
}

; Initialisation/reset subroutine.
;
; On exit:
;     Resident integer variables Q%-V% are initialised to point to the
;     corresponding subroutines.
;
;     All other resident integer variable A%-Z% will be 0.
;
;     All sprite slots are set to refer to their corresponding sprite images and
;     be at (0, 0) but not shown on screen (according to the internal data
;     structures; the screen is not updated).
.v_subroutine
{
l0070 = &0070

if not(MAKE_IMAGE)
    ; Zero resident integer variables A%-Z%
    ldx #('Z'-'A'+1)*4
    lda #0
.zero_ri_loop
    sta ri_a-1,x
    dex:bne zero_ri_loop
    ; Initialise resident integer variables Q%-V%
    ldx #('V'-'Q'+1)*4
.init_qrstuv_loop
    lda initial_qrstuv_values-1,x:sta ri_q-1,x
    dex:bne init_qrstuv_loop
else
    ; Install the interval event handler.
    sei
    lda #<interval_event_handler:sta evntv
    lda #>interval_event_handler:sta evntv+1
    cli

    ; Set R% up to point to a table of entry points.
    ldx #3
.init_r_loop
    lda initial_r_value,x
    sta ri_r,x
    dex:bpl init_r_loop
endif
    ; Initialise slot_addr_table so every slot is associated with
    ; the corresponding sprite image by default and is not on screen.
    ldx #0
    clc ; ENHANCE: get rid of this and do iny*4 below to increment Y
    ldy #max_sprite_num:sty l0070
    ldy #0
.init_slot_addr_table_loop
    lda sprite_ref_addrs_be+0,x:sta slot_addr_table+sprite_addr_hi,y
    lda sprite_ref_addrs_be+1,x:sta slot_addr_table+sprite_addr_lo,y
    lda #0
    sta slot_pixel_coord_table+s_x,x
    sta slot_pixel_coord_table+s_y,x
    sta slot_addr_table+screen_addr_lo,y
    sta slot_addr_table+screen_addr_hi,y
    tya:adc #4:tay
    inx:inx
    dec l0070:bne init_slot_addr_table_loop
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
if MAKE_IMAGE
; All of these values will be read as 32 bit values, but only the low 16 bits
; will be used.

.initial_r_value
    equw r_table

.r_table
    equw q_subroutine_wrapper
    equw s_subroutine
    equw t_subroutine
    equw u_subroutine
    equw v_subroutine
    equw draw_room_subroutine
    equw tune_pitch
    equw tune_duration
    equw current_note
    equw sound_nonblocking
else
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
endif
}

if not(MAKE_IMAGE)
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
endif

.delta_table
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

if not(MAKE_IMAGE)
; ENHANCE: Junk data, can delete.
    for i, 0, 15
        equb 0
    next
endif

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

if not(MAKE_IMAGE)
; ENHANCE: Junk data, can delete TODO: but check this isn't used as index 30/31
; of sprite_delta_coord_table first
    equb 0, 0, 0, 0
endif

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
.slot_addr_table
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
; of this at slot_addr_table+{2,3] does get tweaked
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
; two bytes per sprite slot.
.slot_pixel_coord_table
    for i, 1, 48
        equb 0, 0
    next

; Byte-per-slot table which controls what happens when a sprite tries to move
; off the edges of the screen:
;     0 => clamp the sprite's position to the edge of the screen
;     1 => wrap the sprite's position to the opposite screen edge
;     2 => remove the sprite from the screen (recording which edge it left from)
;
; ENHANCE: This is always 1 for all sprites, so we can hard-code that behaviour
; and remove unreachable code and this table itself. I am not actually sure we
; rely on the wrapping either, so it may be we can just hard-code the assumption
; that sprites never try to leave the screen.
.slot_wrap_behaviour_table
    for i, 1, 48
        equb 1
    next

if not(MAKE_IMAGE)
; ENHANCE: Dead data as r_subroutine is not used, can be removed.
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
endif

.pydis_end

if not(MAKE_IMAGE)
    save pydis_start, pydis_end
endif
