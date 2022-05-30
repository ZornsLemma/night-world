; TODO: Once we abandon py8dis this can be merged into world-1c.asm, perhaps.

mode_5_himem = &5800

vdu_enable_output = 6
vdu_disable_output = 21

osbyte_flush_buffers = 15
osbyte_insert_buffer = 138

oswrch = &ffee

    org &2b00
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
basic_entry = &3590
    assert P% <= basic_entry
    assert (basic_entry - P%) < 256
    skipto basic_entry
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

    assert P% < pydis_start
    assert (pydis_start - P%) < 256
    include "src/world-1c.asm"

; TODO: The filenames and their suffixes both in the build system and on the
; .ssd are a bit chaotic, once we abandon "reproduceability" this can probably
; be tidied up.
putfile "tmp/world-1b.tok", "World-1", &1900, &8023
save "World1c", start, pydis_end
