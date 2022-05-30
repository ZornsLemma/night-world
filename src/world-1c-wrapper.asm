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

.exec
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
    jsr v_subroutine

    ; Insert chain_command into the keyboard buffer ready for BASIC to execute.
    ; We disable VDU output first so the user can't see this, and at the end
    ; of chain_command we re-enable it.
    ; TODO: Is this OK? Do we have to program a function key instead of
    ; inserting this directly?
    lda #vdu_disable_output:jsr oswrch
    lda #osbyte_flush_buffers:ldx #1:jsr osbyte
    lda #0:sta &70
.insert_loop
    ldx &70:ldy chain_command,x:beq insert_loop_done
    lda #osbyte_insert_buffer:ldx #0
    jsr osbyte
    inc &70
    jmp insert_loop
.insert_loop_done
    ; Return to BASIC so it can execute what we just inserted into the keyboard
    ; buffer. (We know we were called from BASIC.)
    rts

.chain_command
    equs "PAGE=&1100:CHAIN ", '"', "World1b", '"', vdu_enable_output, 13, 0

    assert P% < pydis_start
    assert (pydis_start - P%) < 256
    include "src/world-1c.asm"

; TODO: We call this World-1 for now so Nightwo can *RUN it without needing to
; be changed. Should probably call it World11 and make the BASIC World12 later
; or something like that.
save "World-1", start, pydis_end, exec

putfile "tmp/world-1b.tok", "World1b", &1900, &8023
