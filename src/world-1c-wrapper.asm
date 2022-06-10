; TODO: Once we abandon py8dis this can be merged into world-1c.asm, perhaps.

mode_5_himem = &5800

vdu_enable_output = 6
vdu_disable_output = 21

osbyte_flush_buffers = 15
osbyte_insert_buffer = 138

oswrch = &ffee

if not(MAKE_IMAGE)
    org &2b00
    basic_entry = &3590
else
    org &2a00
    basic_entry = &3490
endif
.start

    ; Mode 5 screen data for the banner at the top of the game screen.
.banner_data
    incbin "orig/world-1a"
.banner_data_end
    assert banner_data_end - banner_data == &a00

    ; world-1.bas CALLs this address. We could make it &3500 but (even though
    ; files can't be mixed and matched between the bbcmicro.co.uk version and
    ; this rearranged version anyway) we might as well stick with the original
    ; value.
    assert P% <= basic_entry
    assert (basic_entry - P%) < 256
    skipto basic_entry

    ; Draw the "Night World" text in the "room" region of the screen.
    ; TODO: What if anything should we do about the VDU 19 changes?
{
x_coord = &70
y_coord = &72
ptr = &74
line_count = &76
current_byte = &77
state = &78
x_start_coord = &79
x_coord_plus = &7b
y_coord_minus = &7d

    lda #<682:sta y_coord:lda #>682:sta y_coord+1
    lda #<(text_data-1):sta ptr:lda #>(text_data-1):sta ptr+1
    lda #15:sta line_count
.line_loop
    lda #25:sta x_coord:lda #0:sta x_coord+1:sta state
    ldx #29
.byte_loop
    inc ptr:bne no_carry2:inc ptr+1:.no_carry2
    ldy #0:lda (ptr),y:sta current_byte
    ldy #8
.bit_loop
    asl current_byte:bcc no_char
    lda state:bne already_in_state_1
    lda #1:sta state
    lda x_coord:sta x_start_coord:lda x_coord+1:sta x_start_coord+1
    jmp already_in_state_1
.no_char
    jsr enter_state_0
.already_in_state_1 ; TODO: poor label
    clc:lda x_coord:adc #42:sta x_coord:bcc no_carry1:inc x_coord+1:.no_carry1
    dex:beq line_end
    dey:bne bit_loop:beq byte_loop
.line_end
    jsr enter_state_0
    sec
    lda y_coord:sbc #32:sta y_coord
    lda y_coord+1:sbc #0:sta y_coord+1
    dec line_count:bne line_loop
    jmp skip_enter_state_0

.enter_state_0
    lda state:beq already_in_state_0
    lda #0:sta state
    clc:lda x_coord:adc #56-42:sta x_coord_plus:lda x_coord+1:adc #0:sta x_coord_plus+1
    sec:lda y_coord:sbc #28:sta y_coord_minus:lda y_coord+1:sbc #0:sta y_coord_minus+1
    lda #4:jsr plot:jsr emit_x_start_coord:jsr emit_y_coord
    lda #4:jsr plot:jsr emit_x_coord_plus:jsr emit_y_coord
    lda #85:jsr plot:jsr emit_x_coord_plus:jsr emit_y_coord_minus
    lda #4:jsr plot:jsr emit_x_start_coord:jsr emit_y_coord_minus
    lda #85:jsr plot:jsr emit_x_start_coord:jmp emit_y_coord
.already_in_state_0
    rts
.plot
    pha:lda #25:jsr oswrch:pla:jmp oswrch
.emit_x_start_coord
    lda x_start_coord:jsr oswrch:lda x_start_coord+1:jmp oswrch
.emit_y_coord
    lda y_coord:jsr oswrch:lda y_coord+1:jmp oswrch
.emit_x_coord_plus
    lda x_coord_plus:jsr oswrch:lda x_coord_plus+1:jmp oswrch
.emit_y_coord_minus
    lda y_coord_minus:jsr oswrch:lda y_coord_minus+1:jmp oswrch

.skip_enter_state_0
}

    ; Copy the banner onto the screen
    ldx #>(banner_data_end - banner_data)
    ldy #0
.copy_loop
.copy_loop_lda_abs_y
    lda banner_data,y
.copy_loop_sta_abs_y
    sta mode_5_himem,y
    iny
    bne copy_loop
    inc copy_loop_lda_abs_y+2
    inc copy_loop_sta_abs_y+2
    dex
    bne copy_loop

    ; Initialise the sprite engine and set up the resident integer variables so
    ; the BASIC code can call into it.
    jmp v_subroutine

macro text_row n
    m = n << 3
    for i, 3, 0, -1
        equb (m >> (i*8)) and &ff
    next
endmacro

.text_data
    text_row %10011011101111010010111000000
    text_row %11001001001001010010010000000
    text_row %10101001001000011110010000000
    text_row %10101001001011010010010001000
    text_row %10101001001001010010000001100
    text_row %10101001001111000000011001010
    text_row %10011011100000001110010001001
    text_row %10001000000000010001010001001
    text_row %00000000001110010001010001001
    text_row %01100101010001010001010001001
    text_row %00100101010001011111010001001
    text_row %00100101010001010110010001001
    text_row %00100101010001010010010001010
    text_row %00010101010001010001010101100
    text_row %00001010001110010001011101000

    assert P% < pydis_start
    assert (pydis_start - P%) < 256
    include "src/world-1c.asm"

; TODO: The filenames and their suffixes both in the build system and on the
; .ssd are a bit chaotic, once we abandon "reproduceability" this can probably
; be tidied up.
putfile "tmp/world-1b.tok", "World-1", &1900, &8023
save "World1c", start, pydis_end
putfile "tmp/world-2.tok", "World-2", &1900, &8023
putbasic "sprite-test.bas", "SprTest"
