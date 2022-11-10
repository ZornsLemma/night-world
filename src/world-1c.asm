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
ri_c = &040c
ri_d = &0410
ri_e = &0414
ri_i = &0424
ri_j = &0428
ri_k = &042c
ri_l = &0430
ri_m = &0434
ri_q = &0444
ri_r = &0448
ri_w = &045c
ri_x = &0460
ri_y = &0464
ri_z = &0468

if MAKE_IMAGE
    ; The original game code completes a cycle roughly every 0.06s.
    ; TODO!? game_cycle_tick_interval = 6
    game_cycle_tick_interval_addr = &9fb

    ; The original BASIC code played a note of the background music once every four
    ; game cycles, so by following that we should keep approximately the same
    ; playback speed, although more consistent. TODO: It is just possible that it
    ; would be better to use a different interval to get the speed closer.
    ; TODO: For now this is fixed and doesn't change as the user tweaks the game cycle
    ; tick interval. This is probably OK/desirable, but I haven't thought too closely.
    music_tick_interval = 6 * 4

    evntv = &220
    cnpv = &22e
    osword = &fff1
    osbyte = &fff4
    osbyte_enable_event = 14
    event_interval = 5
    event_interval_flag = &2c4 ; TODO: different address on Electron
    interval_timer = &29c ; TODO: different address on Electron - we could *probably* just use OSWORD to write this
    show_tick_count = FALSE ; TODO: should be off in a "final" build
    sound_channel_1_buffer_number = 5
    sound_channel_2_buffer_number = 6

    vdu_gcol = 18
    S_OP_MOVE = 0
    S_OP_SHOW = 1
    S_OP_REMOVE = 2

    SLOT_ENEMY = 5
    SLOT_SUN_MOON = 6
    SLOT_MISC = 7
    SLOT_LEE = 10

    IMAGE_HUMAN_RIGHT = 9
    IMAGE_HUMAN_LEFT = 10
    IMAGE_HARPY_RIGHT = 13
    IMAGE_HARPY_LEFT = 14

    DELTA_STEP_LEFT_UP = 1
    DELTA_STEP_RIGHT_UP = 3
    DELTA_STEP_LEFT = 4
    DELTA_STEP_RIGHT = 6
    DELTA_STEP_LEFT_DOWN = 7
    DELTA_STEP_RIGHT_DOWN = 9

    osword_read_pixel = 9
    osbyte_acknowledge_escape = 126
    osbyte_inkey = 129

    room_13_door_udg = 226
endif

if MAKE_IMAGE
    ; TODO: Now that the room data has been shrunk, we can probably move all the
    ; machine code up. This would require tweaking world-1c-wrapper.asm and the
    ; CALL to it in world-1b.bas.
    assert &3400-P% < 256
    skipto &3400
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

    jsr set_room_standard_colours

    ldy #255
.byte_loop
    iny:lda (room_ptr),y:ldx #7
.bit_loop
    asl a:pha:php
    ; The room data has the door in room L open; if we want to show the door we
    ; need to explicitly draw it here. Doing it this way means it doesn't
    ; flicker briefly onto the screen during room drawing when it's open.
    lda logical_room:cmp #13:bne not_room_13
    lda score
    cmp #60:beq room_13_door_open
    cmp #80:bcc room_13_door_closed
    lda door_slammed:beq room_13_door_open
.room_13_door_closed
    { cpy #22:bne check_next:cpx #4:beq is_door_char:.check_next }
    { cpy #24:bne check_next:cpx #0:beq is_door_char:.check_next }
      cpy #27:bne not_door_char:cpx #4:bne not_door_char
.is_door_char
    txa:pha:tya:pha
    jsr set_room_13_door_colours
    lda #room_13_door_udg:jsr oswrch
    jsr set_room_standard_colours
    pla:tay:pla:tax
    plp
    jmp char_printed
.not_door_char
.room_13_door_open
.not_room_13
    lda #vdu_right
    plp:bcc char_in_a
    lda udg
.char_in_a
    jsr oswrch
.char_printed
    dec chars_to_next_transition:bne no_transition
    inc udg:lda udg:cmp #initial_udg+(room_size_chars/chars_between_transitions):beq done
    lda #chars_between_transitions:sta chars_to_next_transition
.no_transition
    pla
    dex:bpl bit_loop
    bmi byte_loop
.done
    pla
.^set_text_colours_default
    ldx #128:ldy #2
    ; TODO: There may be other places this could usefully be used. And/or a second entry point which just does the second of the two colour changes.
.^set_text_colours
    lda #17:jsr oswrch:txa:jsr oswrch
    lda #17:jsr oswrch:tya:jmp oswrch
.set_room_standard_colours
    ldx #131:ldy #2:jmp set_text_colours
.^set_room_13_door_colours
    ldx #131:ldy #1:jmp set_text_colours ; blue door ("foreground") with white flecks ("background")
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
if not(MAKE_IMAGE) ; TODO MASSIVE HACK TO GET MORE CODE SPACE WHILE EXPERIMENTING
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
endif
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
if not(MAKE_IMAGE) ; TODO MASSIVE HACK TO GET MORE CODE SPACE WHILE EXPERIMENTING
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
endif
; Sun
.sprite_23
if not(MAKE_IMAGE) ; TODO MASSIVE HACK TO GET MORE CODE SPACE WHILE EXPERIMENTING
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
endif
; Moon
.sprite_24
if not(MAKE_IMAGE) ; TODO MASSIVE HACK TO GET MORE CODE SPACE WHILE EXPERIMENTING
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
endif
; Veil of More Ambiguity
.sprite_25
if not(MAKE_IMAGE) ; TODO MASSIVE HACK TO GET MORE CODE SPACE WHILE EXPERIMENTING
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
endif

if MAKE_IMAGE
; TODO: WIP solid sprite stuff.
.enemy_sprite_mask_valid
    equb 0
.enemy_sprite_mask
    skip 48*4
.enemy_sprite_backing
    skip 48
.player_sprite_mask_valid
    equb 0
.player_sprite_mask
    skip 48*4
.player_sprite_backing
    skip 48
endif

if not(MAKE_IMAGE)
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
endif

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

.^sound_nonblocking
    ldx #sound_channel_1_buffer_number:clv:sec:jsr jmp_cnpv
    cpx #0:beq rts ; do nothing if the buffer is full
    lda ri_a:sta osword_7_block2_amplitude ; TODO: will only work for envelopes as we only set low byte
    lda ri_b:sta osword_7_block2_pitch
    lda ri_e:sta osword_7_block2_duration
    lda #7:ldx #<osword_7_block2:ldy #>osword_7_block2:jmp osword
.rts ; TODO: can I re-use another rts?
    rts

.^sound1
    sta osword_7_block2_amplitude
    stx osword_7_block2_pitch
    sty osword_7_block2_duration
    lda #7:ldx #<osword_7_block2:ldy #>osword_7_block2:jmp osword

.osword_7_block2 ; TODO: poor naming of the two osword_7_blocks
.^osword_7_block2_channel
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
    ; Enable the interval timer crossing zero event and set the timer to -1. We
    ; need to be careful with the sequencing here; if we set the timer to -1
    ; then enable the event, we can get unlucky and have the interval timer
    ; incremented before we enable the event, in which case we will have to wait
    ; just over 348.42 years for it to wrap back round again. (Bear in mind that
    ; the increment happens on its own schedule when the system VIA timer fires;
    ; setting the timer doesn't "start" it ticking at that instant.)
    ;
    ; We disable interrupts across the whole sequence, but I think the main
    ; thing is that we get the order right. If the event fires before we set the
    ; interval timer explicitly there's no real harm done.
    sei
    lda #osbyte_enable_event:ldx #event_interval:jsr osbyte
    sei ; Paranoia; I hope the previous OSBYTE doesn't enable interrupts, but play it safe.
    jsr set_interval_timer
    cli
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

if show_tick_count
    ; We would really like A>=1 here, as that means we are actively busy-waiting
    ; and we thus completed the game cycle's processing in at least slightly
    ; less than game_cycle_tick_interval ticks. We therefore subtract one and
    ; make negative values as noticeable as possible.
    ldx ticks_left_in_game_cycle:dex:bpl not_negative:ldx #&ff:.not_negative:stx &5800
endif
.busy_wait
    lda ticks_left_in_game_cycle
    beq reset_game_cycle_tick_interval:bpl busy_wait
.reset_game_cycle_tick_interval
    ; TODO: I am wondering if this is "wrong"/unfair/unhelpful when we haven't actually done any busy-waiting - partly but not entirely, is there a danger this update is going to get trampled on by the vsync event, so maybe we should sei around this?
    ; TODO: What I'm kind of thinking is something like: we take 3.5 ticks for one game cycle, so we come in here with ticks_left=&ff and half a tick already gone. we set ticks_left to 3, but because half a tick has already gone, if we take 2.9 ticks for the next cycle (thus actually beating the deadline), we will see ticks_left=0 here and think that we've at best just scraped in and most likely failed to hit the deadline.
    ; TODO: Just thinking out loud - could/should we attempt to hit the deadline *on average*? Maybe if we're a tick "ahead" of the deadline in one cycle, we should save that up and allow ourselves to start the next cycle immediately, as long as we're not getting multiple ticks ahead. Something like that.
    lda game_cycle_tick_interval_addr:sta ticks_left_in_game_cycle

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
need_extra_player_plot = &92 ; TODO: HACKY USE OF "INVALID" ZP ADDRESS TO AVOID WORRYING ABOUT CORRUPTION FOR NOW

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
if MAKE_IMAGE
    cpx #S_OP_MOVE:bne not_solid_sprite_move
    ldx #0:stx need_extra_player_plot
    cmp #SLOT_LEE-1:beq no_extra_player_unplot
    cmp #SLOT_ENEMY-1:bne not_solid_sprite_move
    ; We know we're moving a sprite which is already on the screen; if it's a
    ; solid sprite, turn this into explicit remove and plot operations.
    ; TODO: We need to take care of enemy and player sprites overlapping and unplot the player sprite temporarily when moving enemies, but let's not worry about that just yet. A first attempt at this could just *always* unplot the player sprite, but it would probably be nicer to do a collision detection just between those two sprites and only unplot if they are overlapping.
    ; TODO: It might be faster to *just* check for a collision between the two sprite slots of interest, but this is easier for now.
    ; We're moving the enemy sprite, so *if we're overlapping it*, remove the player sprite and reinstate it after.
    lda #SLOT_LEE:sta ri_w
    lda #SLOT_ENEMY:sta ri_y
    jsr q_subroutine
    lda ri_x:lda #SLOT_ENEMY:cmp #SLOT_ENEMY:bne no_extra_player_unplot2 ; SFTODO TEMP LDA#
    inc need_extra_player_plot
    lda #2:sta ri_y:jsr s_subroutine ; remove
.no_extra_player_unplot2 ; TODO CRAP LABEL
    lda #SLOT_ENEMY:sta ri_w
.no_extra_player_unplot
    lda #2:sta ri_y:jsr s_subroutine ; remove
    dec ri_y:jsr s_subroutine ; show
    lda need_extra_player_plot:beq no_extra_player_plot
    lda #SLOT_LEE:sta ri_w:jsr s_subroutine ; show
    lda #SLOT_ENEMY:sta ri_w
.no_extra_player_plot
    dec ri_y ; restore original 0 value
    rts
.not_solid_sprite_move
endif
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
if not(MAKE_IMAGE)
    lda slot_wrap_behaviour_table,y:beq force_x_position_to_sprite_x_max
else
    lda #1 ; TODO: simplistic hack
endif
    cmp #1:beq force_x_position_to_sprite_x_min
    lda #sprite_pixel_x_pos_inf:sta slot_pixel_coord_table+s_x,x
    bne check_y_position ; always branch
.force_x_position_to_sprite_x_max
    lda sprite_x_max:sta slot_pixel_coord_table+s_x,x:sta sprite_pixel_x_lo
    clc:bcc check_y_position
.x_position_too_far_left
if not(MAKE_IMAGE)
    lda slot_wrap_behaviour_table,y:beq force_x_position_to_sprite_x_min
else
    lda #1 ; TODO: simplistic hack
endif
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
if not(MAKE_IMAGE)
    lda slot_wrap_behaviour_table,y:beq force_y_position_to_sprite_y_max
else
    lda #1 ; TODO: simplistic hack
endif
    cmp #1:beq force_y_position_to_sprite_y_min
    lda #sprite_pixel_y_pos_inf:sta slot_pixel_coord_table+s_y,x
    clc
    rts
.force_y_position_to_sprite_y_max
    lda sprite_y_max:sta slot_pixel_coord_table+s_y,x:sta sprite_pixel_y_lo
    clc
    rts
.y_position_too_far_down
if not(MAKE_IMAGE)
    lda slot_wrap_behaviour_table,y:beq force_y_position_to_sprite_y_min
else
    lda #1 ; TODO: simplistic hack
endif
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
if MAKE_IMAGE
.solid_sprite_show
{
row_index = &75
mask_bits = row_index
sprite_backing_ptr = &90 ; TODO: HACKY LOCATION BUT WILL BE SAFE FOR NOW, PICK OUT SOMEWHERE IN &70-&8F FREE LATER
sprite_mask_ptr = screen_ptr2
next_row_adjust = bytes_per_screen_row-7
    ; TODO: Unpleasant code duplication here but keep it simple to start with.
    lda ri_w:cmp #SLOT_ENEMY:beq use_enemy_sprite
    lda #lo(player_sprite_mask):sta sprite_mask_ptr
    lda #hi(player_sprite_mask):sta sprite_mask_ptr+1
    lda #lo(player_sprite_backing):sta sprite_backing_ptr
    lda #hi(player_sprite_backing):sta sprite_backing_ptr+1
    lda player_sprite_mask_valid:bne sprite_mask_calculated
    inc player_sprite_mask_valid:bne calculate_sprite_mask ; always branch
.use_enemy_sprite
    lda #lo(enemy_sprite_mask):sta sprite_mask_ptr
    lda #hi(enemy_sprite_mask):sta sprite_mask_ptr+1
    lda #lo(enemy_sprite_backing):sta sprite_backing_ptr
    lda #hi(enemy_sprite_backing):sta sprite_backing_ptr+1
    lda enemy_sprite_mask_valid:bne sprite_mask_calculated
    inc enemy_sprite_mask_valid
.calculate_sprite_mask
    ; Rather than waste memory on a sprite mask for each possible solid sprite,
    ; we derive a sprite mask when we need it. This isn't a big drag on
    ; performance as the enemy sprite only changes when we change screens and the player sprite only at day/night boundaries and when the player changes direction.
    ; TODO: We will probably need precomputed sprite masks for the four player sprites.
    ; sprite_ptr points to the version of the sprite for the current X offset, but we want to calculate the mask over all four versions, so set sprite_ptr2 to the 0-offset version.
    lda ri_w:sec:sbc #1:asl a:asl a:tax
    lda slot_addr_table+sprite_addr_lo,x:sta sprite_ptr2
    lda slot_addr_table+sprite_addr_hi,x:sta sprite_ptr2+1
.SFTODOHACK
    ldy #48*4-1
.calculate_sprite_mask_loop
    lda #0:sta (sprite_mask_ptr),y
    lda #%00010001:sta mask_bits
    lda (sprite_ptr2),y
    ldx #3
.calculate_sprite_mask_inner_loop
    pha
    and mask_bits
    bne not_black_pixel
    lda (sprite_mask_ptr),y:ora mask_bits:sta (sprite_mask_ptr),y
.not_black_pixel
    pla
    asl mask_bits
    dex:bpl calculate_sprite_mask_inner_loop
    dey:cpy #&ff:bne calculate_sprite_mask_loop
.sprite_mask_calculated
    ; We need to adjust sprite_mask_ptr to point to the correct X-shifted version of the sprite mask.
    ; TODO: Copy and paste
    lda sprite_pixel_x_lo:and #3
    asl a:asl a:asl a:asl a:sta l0073
    asl a:adc l0073 ; we know carry is clear after asl a
    adc sprite_mask_ptr
    sta sprite_mask_ptr
    lda sprite_mask_ptr+1:adc #0:sta sprite_mask_ptr+1
    clc ; TODO paranoia due to "keep C clear" style
    lda #1:sta row_index
.outer_loop
    ldx #8
.inner_loop
    ldy # 0:lda (screen_ptr),y:sta (sprite_backing_ptr),y:lda (screen_ptr),y:and (sprite_mask_ptr),y:ora (sprite_ptr),y:sta (screen_ptr),y
    ldy # 8:lda (screen_ptr),y:sta (sprite_backing_ptr),y:lda (screen_ptr),y:and (sprite_mask_ptr),y:ora (sprite_ptr),y:sta (screen_ptr),y
    ldy #16:lda (screen_ptr),y:sta (sprite_backing_ptr),y:lda (screen_ptr),y:and (sprite_mask_ptr),y:ora (sprite_ptr),y:sta (screen_ptr),y
    lda screen_ptr:and #7:eor #7:beq screen_ptr_row_wrap
    inc screen_ptr
.screen_ptr_row_wrap_handled
    inc sprite_ptr:beq sprite_ptr_carry
.sprite_ptr_carry_handled
    inc sprite_backing_ptr:bne SFTODOZX:inc sprite_backing_ptr+1:.SFTODOZX
    inc sprite_mask_ptr:bne SFTODOPD:inc sprite_mask_ptr+1:.SFTODOPD
    dex:bne inner_loop
    lda sprite_backing_ptr:clc:adc #16:sta sprite_backing_ptr:bcc sbp_no_carry:inc sprite_backing_ptr+1:.sbp_no_carry:clc
    lda sprite_ptr:adc #16:sta sprite_ptr:bcc no_carry
    inc sprite_ptr+1:clc
.no_carry
    lda sprite_mask_ptr:clc:adc #16:sta sprite_mask_ptr:bcc SFTODOXS:inc sprite_mask_ptr+1:.SFTODOXS:clc ; TODO: paranoid clc
    dec row_index:beq outer_loop
    rts
.screen_ptr_row_wrap
    lda screen_ptr  :adc #<next_row_adjust:sta screen_ptr
    lda screen_ptr+1:adc #>next_row_adjust:sta screen_ptr+1
    bne screen_ptr_row_wrap_handled ; always branch
.sprite_ptr_carry
    inc sprite_ptr+1:clc
    bne sprite_ptr_carry_handled ; always branch
}

.^solid_sprite_plot_indirect
    lda ri_y:cmp #S_OP_SHOW:bne solid_sprite_remove
    jmp solid_sprite_show

.solid_sprite_remove
{
row_index = &75
sprite_backing_ptr = sprite_ptr2
next_row_adjust = bytes_per_screen_row-7
    lda ri_w:cmp #SLOT_ENEMY:beq use_enemy_sprite_backing
    lda #lo(player_sprite_backing):sta sprite_backing_ptr
    lda #hi(player_sprite_backing):sta sprite_backing_ptr+1
    jmp sprite_backing_selected
.use_enemy_sprite_backing
    lda #lo(enemy_sprite_backing):sta sprite_backing_ptr
    lda #hi(enemy_sprite_backing):sta sprite_backing_ptr+1
.sprite_backing_selected
    clc ; TODO paranoia due to "keep C clear" style
    lda #1:sta row_index
.outer_loop
    ldx #8
.inner_loop
    ldy # 0:lda (sprite_backing_ptr),y:sta (screen_ptr),y
    ldy # 8:lda (sprite_backing_ptr),y:sta (screen_ptr),y
    ldy #16:lda (sprite_backing_ptr),y:sta (screen_ptr),y
    lda screen_ptr:and #7:eor #7:beq screen_ptr_row_wrap
    inc screen_ptr
.screen_ptr_row_wrap_handled
    inc sprite_backing_ptr:bne SFTODOZX:inc sprite_backing_ptr+1:.SFTODOZX
    dex:bne inner_loop
    lda sprite_backing_ptr:clc:adc #16:sta sprite_backing_ptr:bcc sbp_no_carry:inc sprite_backing_ptr+1:.sbp_no_carry:clc
    dec row_index:beq outer_loop
    rts
.screen_ptr_row_wrap
    lda screen_ptr  :adc #<next_row_adjust:sta screen_ptr
    lda screen_ptr+1:adc #>next_row_adjust:sta screen_ptr+1
    bne screen_ptr_row_wrap_handled ; always branch
}
endif
.plot_sprite
{
row_index = &75
next_row_adjust = bytes_per_screen_row-7

if MAKE_IMAGE
    lda ri_w
    cmp #SLOT_ENEMY:beq solid_sprite_plot_indirect
    cmp #SLOT_LEE:beq solid_sprite_plot_indirect
    clc ; TODO: clc due to odd "keep C clear at all times" code style
endif
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
if MAKE_IMAGE
    ; We need to regenerate the sprite masks when the player or enemy sprite changes.
    ; TODO: It *might* be worth the extra memory to have the four player sprite
    ; masks permanently in memory rather than deriving them at run time, but
    ; that's an extra 3*4*48=576 bytes so I'm going to see if this performs
    ; acceptably first.
    cmp #SLOT_ENEMY:bne not_slot_enemy
    ldx #0:stx enemy_sprite_mask_valid
.not_slot_enemy
    cmp #SLOT_LEE:bne not_slot_lee
    ldx #0:stx player_sprite_mask_valid
.not_slot_lee
endif
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

; TODO: It may well be less wasteful of memory (both here, and in the verbosity
; of the BASIC code) to just allocate addresses in (say) page 9 for these, rather
; than this double-indirection.
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
    equw play_270
    equw play_280
    equw delta_x
    equw jumping
    equw falling_delta_x
    equw falling_time
    equw day_night
    equw lee_direction
    equw jump_time
    equw jump_delta_y
    equw play_330
    equw play_320
    equw full_speed_jump_time_limit
    equw max_jump_time
    equw game_ended
    equw room_type
    equw ah
    equw ak
    equw db
    equw jsr_room_type_1_continue
    equw logical_room
    equw this_item
    equw item_collected
    equw energy_minor
    equw energy_major
    equw play_370
    equw sun_moon_disabled
    equw m
    equw continue_after_advance_sun_moon
    equw score
    equw ed_scalar
    equw play_290
    equw pending_sound_and_light_show_second_part
    equw door_slammed
    equw door_slam_counter
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

if MAKE_IMAGE
{
.^delta_x
    equb 0
.^jumping
    equb 0
.^falling_delta_x
    equb 0
.^falling_time
    equb 0
.^day_night
    equb 0
.^lee_direction
    equb 0
.^jump_time
    equb 0
.^jump_delta_y
    equb 0
.sf
    equw 0
.^full_speed_jump_time_limit
    equb 0
.^max_jump_time
    equb 0
.^game_ended
    equb 0
.^room_type
    equb 0
.^ah
    equb 0
.^ak
    equb 0
.^db
    equb 0
.^logical_room
    equb 0
.^this_item
    equb 0
.^item_collected
    equb 0, 0, 0, 0, 0, 0
.^energy_minor
    equb 0
.^energy_major
    equb 0
.^sun_moon_disabled
    equb 0
.^m
    equb 0
.^score
    equb 0
.^ed_scalar
    equb 0
.^pending_sound_and_light_show_second_part
    equb 0
.axm
    equw 0
.aym
    equw 0
.jump_or_fall_flag ; TODO: poor name
    equb 0
.player_x_safe
    equw 0
.player_y_safe
    equw 0
.^door_slammed
    equb 0
.^door_slam_counter
    equb 0

; I am trying to translate this code in a fairly literal fashion; the
; performance should still be vastly better than BASIC, and by avoiding being
; overly clever I will hopefully reduce the risk of introducing bugs or subtle
; behaviour changes. TODO: When/if this code has been stable for a while and
; passed some testing, it might be worth tidying it up, perhaps focussing more on
; space saving than performance enhancements.
.^play_270
    ; 270GCOL0,0:Y%=S_OP_MOVE:W%=SLOT_LEE
    lda #vdu_gcol:jsr oswrch:lda #0:jsr oswrch:jsr oswrch
    lda #S_OP_MOVE:sta ri_y
    lda #SLOT_LEE:sta ri_w ; TODO: probably redundant
.^play_280
    ; Handle slamming the door in room L if necessary.
    lda door_slam_counter:beq no_door_slam_needed
    dec door_slam_counter:bne no_door_slam_needed
    ; Make the slam sound effect.
    dec osword_7_block2_channel ; temporarily set channel to 0
    lda #1:ldx #6:ldy #20:jsr sound1
    inc osword_7_block2_channel ; reset channel to 1
if FALSE
    ; The door might slam on the player. Since we already have anti-stick logic,
    ; we handle this by just ensuring the player's safe point is far enough left
    ; that it isn't within the door.
    ; TODO: I believe this code is correct, but it isn't actually necessary and
    ; hasn't been tested; the player can always move left out of the door if it
    ; does slam on them. I'll leave it here for now in case I'm missing
    ; something.
max_safe_x_for_slam = 1064
    lda player_x_safe+1:cmp #hi(max_safe_x_for_slam+1):bcc safe_x_ok_for_slam:bne safe_x_not_ok_for_slam
    lda player_x_safe  :cmp #lo(max_safe_x_for_slam+1):bcc safe_x_ok_for_slam
.safe_x_not_ok_for_slam
    lda #lo(max_safe_x_for_slam):sta player_x_safe
    lda #hi(max_safe_x_for_slam):sta player_x_safe+1
.safe_x_ok_for_slam
endif
    ; Hide the player sprite before drawing the door to avoid corruption if
    ; they're in the way.
    lda #SLOT_LEE:sta ri_w ; TODO: probably redundant
    lda #S_OP_REMOVE:sta ri_y:jsr s_subroutine
    ; Draw the door.
    jsr set_room_13_door_colours
    ldx #17
    stx door_slammed ; any non-0 value will do
.draw_door_loop
    lda #31:jsr oswrch:lda #19:jsr oswrch:txa:jsr oswrch
    lda #room_13_door_udg:jsr oswrch
if FALSE
    ; TODO: Delete this later; this logic used the correct UDG for each door row
    ; to make it look like a normal wall, as it did in the original version.
    lda #228:cpx #17:beq use_228:lda #229:.use_228:jsr oswrch
endif
    inx:cpx #20:bne draw_door_loop
    jsr set_text_colours_default
    ; Restore the player sprite.
    lda #S_OP_SHOW:sta ri_y:jsr s_subroutine
    lda #S_OP_MOVE:sta ri_y
.no_door_slam_needed
    ; 280IFscore%=100:IFRND(sound_and_light_show_chance%)=1:PROCsound_and_light_show
    ; PROCsound_and_light_show involves a PROCdelay(250), which is about 5cs. In
    ; order to avoid becoming unresponsive, we split this up and do the part
    ; after the delay in the next game cycle.
    lda pending_sound_and_light_show_second_part:beq not_second_part
    lda #0:sta pending_sound_and_light_show_second_part
    lda #<254:sta ri_m:lda #>254:sta ri_m+1:rts
.not_second_part
    lda score:cmp #100:bne play_290
    lda #<252:sta ri_m:lda #>252:sta ri_m+1:rts
.^play_290
    ; Test for Escape so the player can quit the game part-way through.
    lda #osbyte_acknowledge_escape:jsr osbyte
    cpx #0:bne escape
    ; 290W%=SLOT_LEE
    lda #SLOT_LEE:sta ri_w
    lda #1:sta jump_or_fall_flag
    ; 291IFjumping%=1:PROCjump:GOTO330 ELSEdelta_x%=0:IFPOINT(C%+4,D%-66)=0:IFPOINT(C%+60,D%-66)=0:C%=C%+falling_delta_x%:D%=D%-8:falling_time%=falling_time%+1:GOTO330
    lda jumping:beq not_jumping
    jsr jump
    jmp play_330
.escape
    brk:equb 17, "Escape", 0 ; ENHANCE: No one cares about the string, if we're trying to save space
.not_jumping
    lda #0:sta delta_x
    clc:lda ri_c:adc #4:sta osword_read_pixel_block_x
    lda ri_c+1:adc #0:sta osword_read_pixel_block_x+1
    sec:lda ri_d:sbc #66:sta osword_read_pixel_block_y
    lda ri_d+1:sbc #0:sta osword_read_pixel_block_y+1
    jsr point
    lda osword_read_pixel_block_result:bne not_black_below
    clc:lda ri_c:adc #60:sta osword_read_pixel_block_x
    lda ri_c+1:adc #0:sta osword_read_pixel_block_x+1
    jsr point
    lda osword_read_pixel_block_result:bne not_black_below
    lda falling_delta_x:bmi falling_delta_x_negative
    clc:adc ri_c:sta ri_c
    lda ri_c+1:adc #0:sta ri_c+1
    jmp falling_delta_x_not_negative
.falling_delta_x_negative
    clc:adc ri_c:sta ri_c
    lda ri_c+1:adc #&ff:sta ri_c+1
.falling_delta_x_not_negative
    sec:lda ri_d:sbc #8:sta ri_d
    lda ri_d+1:sbc #0:sta ri_d+1
    inc falling_time ; TODO: does this need to be 16 bit? bear in mind we use negative values...
    jmp play_330
.not_black_below
    lda #0:sta jump_or_fall_flag ; TODO: could probably just "dec"
    ; 300falling_delta_x%=0:IFINKEY-98PROCmove_left ELSEIFINKEY-67PROCmove_right
    lda #0:sta falling_delta_x
    ; TODO: We should automatically teleport (ideally with a "shimmer" effect and a sound) to the safe point when
    ; we are stuck, but for now let's make it a manual operation.
    ldx #-36 and &ff:jsr inkey:bne not_teleport
    lda player_x_safe:sta ri_c
    lda player_x_safe+1:sta ri_c+1
    lda player_y_safe:sta ri_d
    lda player_y_safe+1:sta ri_d+1
    jmp done_move_left_right ; don't confuse matters by also allowing the user to move this cycle
.not_teleport
    ldx #-98 and &ff:jsr inkey:bne not_move_left:jsr move_left:jmp done_move_left_right
.not_move_left
    ldx #-67 and &ff:jsr inkey:bne done_move_left_right:jsr move_right
.done_move_left_right
    ; 310falling_time%=0:IFINKEY-1jumping%=1:jump_time%=0:jump_delta_y%=8:falling_delta_x%=delta_x%:SOUND1,11,D%,12 ELSEIFINKEY-56PROCpause
    lda #0:sta falling_time
    ldx #-1 and &ff:jsr inkey:bne not_jump
    lda #1:sta jumping
    lda #0:sta jump_time
    lda #8:sta jump_delta_y
    lda delta_x:sta falling_delta_x
    lda #11:ldx ri_d:ldy #12:jsr sound1
    jmp play_320
.not_jump
    ldx #-56 and &ff:jsr inkey:bne not_pause
    lda #<256:sta ri_m:lda #>256:sta ri_m+1:rts ; TODO!
.not_pause
.^play_320
    ; 320sf%=D%-66:IFscore%=100:IFD%>260:IFPOINT(C%,sf%)=3:MOVEC%,sf%+26:VDU5,249,4
    sec:lda ri_d:sbc #66:sta sf
    lda ri_d+1:sbc #0:sta sf+1
    lda score:cmp #100:bne score_not_100
    lda ri_d+1:cmp #>260:bcc d_not_gt_260:bne d_gt_260
    lda ri_d:cmp #<260:bcc d_not_gt_260:beq d_not_gt_260
.d_gt_260
    lda ri_c:sta osword_read_pixel_block_x
    lda ri_c+1:sta osword_read_pixel_block_x+1
    lda sf:sta osword_read_pixel_block_y
    lda sf+1:sta osword_read_pixel_block_y+1
    jsr point
    lda osword_read_pixel_block_result:cmp #3:bne point_not_3
    lda #25:jsr oswrch:lda #4:jsr oswrch
    lda ri_c:jsr oswrch:lda ri_c+1:jsr oswrch
    clc:lda sf:adc #26:php:jsr oswrch:plp
    lda sf+1:adc #0:jsr oswrch
    lda #5:jsr oswrch:lda #249:jsr oswrch:lda #4:jsr oswrch
.point_not_3
.d_not_gt_260
.score_not_100
.^play_330
    ; 330W%=SLOT_LEE:CALLS%
    lda #SLOT_LEE:sta ri_w
    jsr s_subroutine
.play_335
    ; 335IFC%<24ORC%>1194ORD%>730ORD%<228PROCchange_room:PROCreset_note_count:IFgame_ended%=0:GOTO270 ELSEIFgame_ended%=1:ENDPROC
    lda ri_c+1:cmp #>24:bne c_not_lt_24
    lda ri_c:cmp #<24:bcc c_lt_24
.c_not_lt_24
    lda ri_c+1:cmp #>1194:bcc c_not_gt_1194:bne c_gt_1194
    lda ri_c:cmp #<1194:beq c_not_gt_1194:bcs c_gt_1194
.c_not_gt_1194
    lda ri_d+1:cmp #>730:bcc d_not_gt_730:bne d_gt_730
    lda ri_d:cmp #<730:beq d_not_gt_730:bcs d_gt_730
.d_not_gt_730
    lda ri_d+1:cmp #>228:bne d_not_lt_228
    lda ri_d:cmp #<228:bcs d_not_lt_228
.d_lt_228
.c_lt_24
.c_gt_1194
.d_gt_730
    lda #<257:sta ri_m:lda #>257:sta ri_m+1:rts ; TODO!?
.d_not_lt_228
    lda game_ended:beq play_340
    lda #<258:sta ri_m:lda #>258:sta ri_m+1:rts ; TODO!?
.play_340
    ; 340W%=SLOT_ENEMY:IFroom_type%=1:PROCroom_type1 ELSEIFroom_type%=2:PROCroom_type2 ELSEIFroom_type%=3:PROCroom_type3 ELSEIFroom_type%=4:PROCroom_type4 ELSEIFroom_type%=5:PROCroom_type5
    lda #SLOT_ENEMY:sta ri_w
    ldx room_type:beq room_type_0
    dex:beq jsr_room_type_1
    dex:beq jsr_room_type_2
    dex:beq jsr_room_type_3
    dex:beq jsr_room_type_4
    dex:beq jsr_room_type_5
    brk:equs 0, "Bad room type", 0
.jsr_room_type_1
    ; We need a random number; we let BASIC generate it to avoid introducing
    ; subtle behavioural changes.
    ; TODO: In general, we could shrink "set M% and return to BASIC" everywhere by something like: "ldx #<num:ldy #>num:jmp set_m_to_xy_and_rts"
    lda #<251:sta ri_m
    lda #>251:sta ri_m+1
    rts
.^jsr_room_type_1_continue
    jsr room_type_1
    jmp play_360
.jsr_room_type_2
    jsr room_type_2
    jmp play_360
.jsr_room_type_3
    jsr room_type_3
    jmp play_360
.jsr_room_type_4
    jsr room_type_4
    jmp play_360
.jsr_room_type_5
    jsr room_type_5
    assert P% == play_360 ; fall through to play_360
.room_type_0
.play_360
    ; 360W%=SLOT_LEE:Y%=8:CALLQ%:IFX%<>0ORfalling_time%>12:PROCupdate_energy_and_items
    lda #SLOT_LEE:sta ri_w
    lda #8:sta ri_y
    jsr q_subroutine_wrapper
    lda ri_x:bne x_ne_0
    ; We're not colliding with an enemy, so one of the conditions for this being a new safe position is met.
    ; TODO: Experimental anti-stick. I think (part?) of the sticking problem is
    ; that when we're moving left and right we are checking points at head
    ; height, whereas when we're jumping/falling we are checking points at foot
    ; height, so when we finish jumping/falling we might be in a position where
    ; we can no longer move left or right. To try to work round this, we keep
    ; track of the last known "safe" position.
    ; We are not jumping/falling. Is the current position different from the
    ; saved safe position?
    lda jumping:ora jump_or_fall_flag:bne not_new_safe_candidate
    lda ri_c:cmp player_x_safe:bne new_safe_candidate
    lda ri_c+1:cmp player_x_safe+1:bne new_safe_candidate
    lda ri_d:cmp player_y_safe:bne new_safe_candidate
    lda ri_d+1:cmp player_y_safe+1:beq not_new_safe_candidate
.new_safe_candidate
    ; The current position isn't the already saved safe position. Is it safe? We define this experimentally as "the player is able to move left or right". It *might* be desirable to also check the player is in a valid position, such that if they move left they can subsequently move right to get back to this position (or vice versa), but let's not add that complexity yet.
    ; TODO: I managed to get stuck in the "ladder" at the rhs of room C with an "invalid" safe position - the enemy *may* have been involved, not sure right now - I am wondering if (assuming it is the enemy's "fault" I can get an invalid safe position) simply not saving a safe position when colliding with something would work - have now tweaked code but not yet seen if this fixes this - I think the enemy *did* have a role to play
    jsr check_move_left:beq is_new_safe_position
    jsr check_move_right:bne not_new_safe_candidate
.is_new_safe_position
    lda ri_c:sta player_x_safe
    lda ri_c+1:sta player_x_safe+1
    lda ri_d:sta player_y_safe
    lda ri_d+1:sta player_y_safe+1
.not_new_safe_candidate
    ; TODO: for now assuming falling_time is 8-bit signed value; we *may* need 16 bits
    lda falling_time:bmi falling_time_not_gt_12:cmp #12+1:bcc falling_time_not_gt_12
.x_ne_0
    jsr update_energy_and_items
    jmp play_370 ; SFTODO: redundant (and not in the BASIC either, so not exactly "clarity-adding" either)
.falling_time_not_gt_12
.^play_370
    ; 370IFsun_moon_disabled%=0:m%=m%+1:IFm%=11:PROCadvance_sun_moon:m%=0 ELSEIFlogical_room%=1ORlogical_room%=13ORlogical_room%=5ORlogical_room%=10:PROCcheck_warps:GOTO270
    lda sun_moon_disabled:bne dont_update_sun_moon
    inc m
    lda m:cmp #11:bne dont_advance_sun_moon
    jsr advance_sun_moon
.^continue_after_advance_sun_moon
    lda #0:sta m
    jmp play_280
.dont_advance_sun_moon
.dont_update_sun_moon
    lda logical_room
    cmp #1:beq do_check_warps
    cmp #13:beq do_check_warps
    cmp #5:beq do_check_warps
    cmp #10:beq do_check_warps
    jmp play_280
.do_check_warps
    lda #<381:sta ri_m:lda #>381:sta ri_m+1:rts

.advance_sun_moon
{
    ; 510DEFPROCadvance_sun_moon:W%=SLOT_SUN_MOON:Z%=DELTA_STEP_RIGHT:CALLT%:IFK%=1016:PROCtoggle_day_night
    lda #SLOT_SUN_MOON:sta ri_w
    lda #DELTA_STEP_RIGHT:sta ri_z
    jsr t_subroutine
    lda ri_k:cmp #<1016:bne k_not_1016
    lda ri_k+1:cmp #>1016:bne k_not_1016
    pla:pla:lda #<531:sta ri_m:lda #>531:sta ri_m+1:rts
.k_not_1016
    ; TODO: Not translating next line as it's probably useless...
    ; 515REM TODO: Does the next line do anything useful?
    ; 520IFlogical_room%=5:W%=8:Z%=DELTA_STEP_RIGHT:CALLT%
    ; 530ENDPROC
    rts
}

.room_type_1
{
    ; 650DEFPROCroom_type1:Z%=db%:IFRND(3)<>1:GOTO680
    lda db:sta ri_z
    ; M% contains the result of RND(3)
    lda ri_m:cmp #1:bne room_type_1_680
    ; Compare J% with D% ahead of the next few lines.
    ldy #0
    lda ri_j+1:cmp ri_d+1:bcc j_lt_d:bne j_gt_d
    lda ri_j:cmp ri_d:bcc j_lt_d:beq j_eq_d
.j_gt_d
    iny
.j_lt_d
    iny
.j_eq_d
    ; Y=0 if J%=D%, 1 if J%<D%, 2 if J%>D%
    ; 660IFdb%=DELTA_STEP_RIGHTANDJ%>D%:Z%=DELTA_STEP_RIGHT_DOWN ELSEIFdb%=6ANDJ%<D%:Z%=DELTA_STEP_RIGHT_UP
    lda db:cmp #DELTA_STEP_RIGHT:bne room_type_1_660_else
    cpy #2:bne room_type_1_660_else
    lda #DELTA_STEP_RIGHT_DOWN:sta ri_z
    jmp room_type_1_670
.room_type_1_660_else
    lda db:cmp #6:bne room_type_1_670
    cpy #1:bne room_type_1_670
    lda #DELTA_STEP_RIGHT_UP:sta ri_z
    ; 670IFdb%=DELTA_STEP_LEFTANDJ%>D%:Z%=DELTA_STEP_LEFT_DOWN ELSEIFdb%=4ANDJ%<D%:Z%=DELTA_STEP_LEFT_UP
.room_type_1_670
    lda db:cmp #DELTA_STEP_LEFT:bne room_type_1_670_else
    cpy #2:bne room_type_1_670_else
    lda #DELTA_STEP_LEFT_DOWN:sta ri_z
    jmp room_type_1_680
.room_type_1_670_else
    lda db:cmp #4:bne room_type_1_680
    cpy #1:bne room_type_1_680
    lda #DELTA_STEP_LEFT_UP:sta ri_z
    ; 680IFI%=1152:db%=DELTA_STEP_LEFT:X%=IMAGE_HARPY_LEFT:CALLU% ELSEIFI%=64:db%=DELTA_STEP_RIGHT:X%=IMAGE_HARPY_RIGHT:CALLU%
.room_type_1_680
    lda ri_i:cmp #<1152:bne room_type_1_680_else
    lda ri_i+1:cmp #>1152:bne room_type_1_680_else
    lda #DELTA_STEP_LEFT:sta db
    lda #IMAGE_HARPY_LEFT:sta ri_x
    jsr u_subroutine
    jmp room_type_1_690
.room_type_1_680_else
    lda ri_i:cmp #<64:bne room_type_1_690
    lda ri_i+1:cmp #>64:bne room_type_1_690
    lda #DELTA_STEP_RIGHT:sta db
    lda #IMAGE_HARPY_RIGHT:sta ri_x
    jsr u_subroutine
    ; 690CALLT%:ENDPROC
.room_type_1_690
    jmp t_subroutine
}

.room_type_2
{
    ; 700DEFPROCroom_type2:axm%=3:IFI%>C%:axm%=-3
    lda #3:sta axm:lda #0:sta axm+1
    lda ri_i+1:cmp ri_c+1:bcc i_not_gt_c:bne i_gt_c
    lda ri_i:cmp ri_c:bcc i_not_gt_c:beq i_not_gt_c
.i_gt_c
    lda #-3 and &ff:sta axm:lda #&ff:sta axm+1
.i_not_gt_c
    ; 710aym%=2:IFJ%>D%:aym%=-4
    lda #2:sta aym:lda #0:sta aym+1
    lda ri_j+1:cmp ri_d+1:bcc j_not_gt_d:bne j_gt_d
    lda ri_j:cmp ri_d:bcc j_not_gt_d:beq j_not_gt_d
.j_gt_d
    lda #-4 and &ff:sta aym:lda #&ff:sta aym+1
.j_not_gt_d
    ; 720I%=I%+axm%:J%=J%+aym%:CALLS%:ENDPROC
    clc:lda ri_i:adc axm:sta ri_i
    lda ri_i+1:adc axm+1:sta ri_i+1
    clc:lda ri_j:adc aym:sta ri_j
    lda ri_j+1:adc aym+1:sta ri_j+1
    jmp s_subroutine
}

.room_type_3
{
    ; 750DEFPROCroom_type3:Z%=ed%(ah%):ak%=ak%+1:IFak%=30:ak%=0:ah%=ah%+1:IFah%=7:ah%=1
    ldx ah:lda ed_array,x:sta ri_z
    ldx ak:inx
    cpx #30:bne ak_not_30
    ldx #0
    ldy ah:iny
    cpy #7:bne ah_not_7
    ldy #1
.ah_not_7
    sty ah
.ak_not_30
    stx ak
    ; 760CALLT%:ENDPROC
    jmp t_subroutine
}

.room_type_4
{
    ; 730DEFPROCroom_type4:Z%=ad%(ah%):ak%=ak%+1:IFak%=40:ak%=0:ah%=ah%+1:IFah%=5:ah%=1
    ldx ah:lda ad,x:sta ri_z
    ldx ak:inx
    cpx #40:bne ak_not_40
    ldx #0
    ldy ah:iny
    cpy #5:bne ah_not_5
    ldy #1
.ah_not_5
    sty ah
.ak_not_40
    stx ak
    ; 740CALLT%:ENDPROC
    jmp t_subroutine
}

.room_type_5
{
    ; 770DEFPROCroom_type5:Z%=ed%:IFed%=6ANDI%>688:ed%=4
    lda ed_scalar:sta ri_z
    cmp #6:bne ed_not_6
    lda ri_i+1:cmp #>688:bcc i_not_gt_688:bne i_gt_688
    lda ri_i:cmp #<688:bcc i_not_gt_688:beq i_not_gt_688
.i_gt_688
    lda #4:sta ed_scalar
.i_not_gt_688
.ed_not_6
    ; 780IFed%=4ANDI%<644:ed%=6
    lda ed_scalar:cmp #4:bne ed_not_4
    lda ri_i+1:cmp #>644:bcc i_lt_644:bne i_not_lt_644
    lda ri_i:cmp #<644:bcs i_not_lt_644
.i_lt_644
    lda #6:sta ed_scalar
.i_not_lt_644
.ed_not_4
    ; 790CALLT%:ENDPROC
    jmp t_subroutine
}

; TODO: This array is read-only so we just duplicate it from the BASIC rather than trying to share it.
.ed_array
    equb 0, 3, 6, 9, 7, 4, 1
; TODO: This array is read-only so we just duplicate it from the BASIC rather than trying to share it.
.ad
    equb 0, 3, 9, 7, 1

.check_move_left
    ; TODO: If we expressed this as adding -4, we might be able to move more code into the common tail.
    sec:lda ri_c:sbc #4:sta osword_read_pixel_block_x
    lda ri_c+1:sbc #0
    jmp check_move_left_right_common_tail
.check_move_right
    clc:lda ri_c:adc #64:sta osword_read_pixel_block_x
    lda ri_c+1:adc #0
.check_move_left_right_common_tail
    sta osword_read_pixel_block_x+1
    sec:lda ri_d:sbc #8:sta osword_read_pixel_block_y
    lda ri_d+1:sbc #0:sta osword_read_pixel_block_y+1
    jsr point
    lda osword_read_pixel_block_result
    rts

.move_left
    ; 420DEFPROCmove_left:IFPOINT(C%-4,D%-8)<>0:ENDPROC
    jsr check_move_left:bne move_left_rts
    ; 430IFlee_direction%=IMAGE_HUMAN_RIGHT:lee_direction%=IMAGE_HUMAN_LEFT:PROCchange_lee_sprite:W%=SLOT_LEE
    lda lee_direction:cmp #IMAGE_HUMAN_RIGHT:bne not_facing_right
    lda #IMAGE_HUMAN_LEFT:sta lee_direction
    jsr change_lee_sprite
    lda #SLOT_LEE:STA ri_w
.not_facing_right
    ; 440delta_x%=-8:C%=C%-8:ENDPROC
    lda #-8 and &ff:sta delta_x
    sec:lda ri_c:sbc #8:sta ri_c
    lda ri_c+1:sbc #0:sta ri_c+1
.move_left_rts
    rts

.move_right
    ; 450DEFPROCmove_right:IFPOINT(C%+64,D%-8)<>0:ENDPROC
    jsr check_move_right:bne move_right_rts
    ; 460IFlee_direction%=IMAGE_HUMAN_LEFT:lee_direction%=IMAGE_HUMAN_RIGHT:PROCchange_lee_sprite:W%=SLOT_LEE
    lda lee_direction:cmp #IMAGE_HUMAN_LEFT:bne not_facing_left
    lda #IMAGE_HUMAN_RIGHT:sta lee_direction
    jsr change_lee_sprite
    lda #SLOT_LEE:sta ri_w
.not_facing_left
    ; 470delta_x%=8:C%=C%+8:ENDPROC
    lda #8:sta delta_x
    clc:lda ri_c:adc #8:sta ri_c
    lda ri_c+1:adc #0:sta ri_c+1
.move_right_rts
    rts

.jump
    ; 480DEFPROCjump:IFPOINT(C%+8,D%+4)<>0ORPOINT(C%+56,D%+4)<>0:jumping%=0:falling_time%=FNjump_terminated_falling_time:PROCstop_sound:ENDPROC
    clc:lda ri_c:adc #8:sta osword_read_pixel_block_x
    lda ri_c+1:adc #0:sta osword_read_pixel_block_x+1
    clc:lda ri_d:adc #4:sta osword_read_pixel_block_y
    lda ri_d+1:adc #0:sta osword_read_pixel_block_y+1
    jsr point
    lda osword_read_pixel_block_result:bne stop_jumping
    clc:lda ri_c:adc #56:sta osword_read_pixel_block_x
    lda ri_c+1:adc #0:sta osword_read_pixel_block_x+1
    jsr point
    lda osword_read_pixel_block_result:beq dont_stop_jumping
.stop_jumping
    lda #0:sta jumping
    jsr jump_terminated_falling_time:sta falling_time
    jmp stop_sound
.dont_stop_jumping
    ; 490jump_time%=jump_time%+2:D%=D%+jump_delta_y%:C%=C%+delta_x%
    clc:lda jump_time:adc #2:sta jump_time ; TODO: need to worry about wrapping?
    ldx #0:lda jump_delta_y:bpl jump_delta_y_positive:dex:.jump_delta_y_positive
    clc:adc ri_d:sta ri_d
    txa:adc ri_d+1:sta ri_d+1
    ldx #0:lda delta_x:bpl delta_x_positive:dex:.delta_x_positive
    clc:adc ri_c:sta ri_c
    txa:adc ri_c+1:sta ri_c+1
    ; 491IFjump_time%>full_speed_jump_time_limit%:jump_delta_y%=-4:IFjump_time%=max_jump_time%ORPOINT(C%+32,D%-66)<>0:jumping%=0:PROCstop_sound:ENDPROC
    lda jump_time:cmp full_speed_jump_time_limit:bcc jump_time_not_gt_full_speed_jump_time_limit:beq jump_time_not_gt_full_speed_jump_time_limit
    lda #-4 and &ff:sta jump_delta_y
    lda jump_time:cmp max_jump_time:beq jump_time_eq_max_jump_time
    clc:lda ri_c:adc #32:sta osword_read_pixel_block_x
    lda ri_c+1:adc #0:sta osword_read_pixel_block_x+1
    sec:lda ri_d:sbc #66:sta osword_read_pixel_block_y
    lda ri_d+1:sbc #0:sta osword_read_pixel_block_y+1
    jsr point
    lda osword_read_pixel_block_result:beq jump_pixel_above_black
.jump_time_eq_max_jump_time
    lda #0:sta jumping
    jmp stop_sound
.jump_time_not_gt_full_speed_jump_time_limit
.jump_pixel_above_black
    ; 500ENDPROC
    rts

.update_energy_and_items
{
    ; 1160DEFPROCupdate_energy_and_items:IFX%=SLOT_ENEMY:GOTO1210 ELSEIFX%=SLOT_ENEMYOR(X%=SLOT_MISCANDlogical_room%<>1ANDlogical_room%<>5ANDlogical_room%<>9ANDlogical_room%<>14ANDlogical_room%<>7):GOTO1210
    lda ri_x
    cmp #SLOT_ENEMY:beq update_energy_and_items_1210
    cmp #SLOT_MISC:bne update_energy_and_items_1170
    lda logical_room
    cmp #1:beq update_energy_and_items_1170
    cmp #5:beq update_energy_and_items_1170
    cmp #9:beq update_energy_and_items_1170
    cmp #14:beq update_energy_and_items_1170
    cmp #7:beq update_energy_and_items_1170
    jmp update_energy_and_items_1210
    ; 1170IFfalling_time%>1:GOTO1210 ELSEIFlogical_room%=1:this_item%=1 ELSEIFlogical_room%=7:this_item%=2 ELSEIFlogical_room%=5:this_item%=3 ELSEIFlogical_room%=14:this_item%=4 ELSEIFlogical_room%=9:this_item%=5
.update_energy_and_items_1170
    lda falling_time:bmi falling_time_negative:cmp #1+1:bcs update_energy_and_items_1210
.falling_time_negative
    lda logical_room
    ldx #1:cmp #1:beq this_item_in_x
    ldx #2:cmp #7:beq this_item_in_x
    ldx #3:cmp #5:beq this_item_in_x
    ldx #4:cmp #14:beq this_item_in_x
    ldx #5:cmp #9:beq this_item_in_x
    brk:equs 0, "Bad item", 0 ; TODO!?
.this_item_in_x
    stx this_item
    ; 1180IFitem_collected%(this_item%)=1:GOTO1220 ELSEitem_collected%(this_item%)=1:IFthis_item%<5:PROCshow_prisms
    ldx this_item:lda item_collected,x:cmp #1:beq update_energy_and_items_1220
    lda #1:sta item_collected,x
    pla:pla:lda #<1181:sta ri_m:lda #>1181:sta ri_m+1:rts
    ; 1210IFfalling_time%>1:A%=11:B%=energy_minor%:E%=2:CALLR%!R_TABLE_SOUND_NONBLOCKING:GOTO1230
.update_energy_and_items_1210
    lda falling_time:bmi update_energy_and_items_1220:cmp #1+1:bcc update_energy_and_items_1220
    lda #11:sta ri_a
    lda energy_minor:sta ri_b
    lda #2:sta ri_e
    jsr sound_nonblocking
    jmp update_energy_and_items_1230
    ; 1220IFroom_type%=2ANDday_night%=1ANDX%=SLOT_ENEMY:ENDPROC ELSEPROCstop_sound:IFroom_type%=2:A%=9:B%=energy_minor%:E%=2:CALLR%!R_TABLE_SOUND_NONBLOCKING ELSEIFX%=SLOT_MISC:A%=8:B%=energy_minor%:E%=4:CALLR%!R_TABLE_SOUND_NONBLOCKING ELSEA%=12:B%=energy_minor%:E%=5:CALLR%!R_TABLE_SOUND_NONBLOCKING
.update_energy_and_items_1220
    lda room_type:cmp #2:bne not_endproc
    lda day_night:cmp #1:bne not_endproc
    lda ri_x:cmp #SLOT_ENEMY:bne not_endproc
    rts
.not_endproc
    jsr stop_sound
    lda room_type:cmp #2:bne not_room_type_2
    lda #9:sta ri_a
    lda energy_minor:sta ri_b
    lda #2:sta ri_e
    jsr sound_nonblocking
    jmp update_energy_and_items_1230
.not_room_type_2
    lda ri_x:cmp #SLOT_MISC:bne not_slot_misc
    lda #8:sta ri_a
    lda energy_minor:sta ri_b
    lda #4:sta ri_e
    jsr sound_nonblocking
    jmp update_energy_and_items_1230
.not_slot_misc
    lda #12:sta ri_a
    lda energy_minor:sta ri_b
    lda #5:sta ri_e
    jsr sound_nonblocking
    ; 1230energy_minor%=energy_minor%-1
.update_energy_and_items_1230
    dec energy_minor
    ; 1231IFenergy_minor%=0:energy_minor%=25:IF?&9FF<>1:energy_major%=energy_major%-1:VDU17,0,17,131:PRINTTAB(energy_major%,5)CHR$224:VDU17,128,17,1:PRINTTAB(energy_major%+1,5)CHR$246:IFenergy_major%=3:PROCset8(R_TABLE_GAME_ENDED,1)
    lda energy_minor:bne energy_minor_not_0
    lda #25:sta energy_minor
    lda &9ff:cmp #1:beq infinite_health_cheat
    dec energy_major
    lda #17:jsr oswrch:lda #0:jsr oswrch:lda #17:jsr oswrch:lda #131:jsr oswrch
    lda #31:jsr oswrch:lda energy_major:jsr oswrch:lda #5:jsr oswrch
    lda #224:jsr oswrch
    lda #17:jsr oswrch:lda #128:jsr oswrch:lda #17:jsr oswrch:lda #1:jsr oswrch
    ; We don't need to do PRINTTAB(energy_major%+1,5), as we're already there.
    ; (The BASIC wouldn't be, as it doesn't have a semicolon after CHR$224.)
    lda #246:jsr oswrch
    lda energy_major:cmp #3:bne not_game_ended
    lda #1:sta game_ended
.not_game_ended
.energy_minor_not_0
.infinite_health_cheat
    ; 1240ENDPROC
    rts
}

.jump_terminated_falling_time
{
    ; 4000DEFFNjump_terminated_falling_time
    ; 4010REM Credit the player with any unused "descending" time from this jump; this wouldn't count as time towards the falling damage threshold if they hadn't collided with something above them, so it seems fair to give them the same here.
    ; 4020jump_time%=jump_time%+2:REM this would have happened in this game cycle before testing jump_time% if we hadn't collided with something
    inc jump_time:inc jump_time
    ; 4030IF jump_time%<full_speed_jump_time_limit%:jump_time%=full_speed_jump_time_limit%:REM don't credit any remaining "ascending" jump time
    lda jump_time:cmp full_speed_jump_time_limit:bcs no_ascending_time_left
    lda full_speed_jump_time_limit:sta jump_time
.no_ascending_time_left
    ; 4040=(jump_time%-max_jump_time%)DIV2:REM DIV 2 because jump_time% counts up by two every game cycle
    sec:lda jump_time:sbc max_jump_time:beq falling_time_0
    bmi falling_time_negative
    brk:equb 0, "Positive!", 0
.falling_time_negative
    sec:ror a
.falling_time_0
    rts
}

.stop_sound
    ; 110DEFPROCstop_sound:SOUND&11,0,0,0:ENDPROC
    lda #7:ldx #<stop_sound_block:ldy #>stop_sound_block:jmp osword
.stop_sound_block
    equw &11, 0, 0, 0

.change_lee_sprite
    ; 200DEFPROCchange_lee_sprite
    ; 202W%=SLOT_LEE:X%=lee_direction%+2*day_night%:CALLU%
    lda #SLOT_LEE:sta ri_w
    lda day_night:asl a:clc:adc lee_direction:sta ri_x
    jsr u_subroutine
    ; 203Y%=S_OP_MOVE
    lda #S_OP_MOVE:sta ri_y
    ; 208ENDPROC
    rts

.inkey
    lda #osbyte_inkey:ldy #&ff:jsr osbyte
    inx
    rts

.point
    lda #osword_read_pixel
    ldx #<osword_read_pixel_block
    ldy #>osword_read_pixel_block
    jmp osword

.osword_read_pixel_block
.osword_read_pixel_block_x
    equw 0
.osword_read_pixel_block_y
    equw 0
.osword_read_pixel_block_result
    equb 0
}
endif

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

if not(MAKE_IMAGE)
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
endif

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
