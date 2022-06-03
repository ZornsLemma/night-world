cnpv = &22e
osword = &fff1
event_vsync = 4
sound_channel_2_buffer_number = 6
ri_q = &444

game_cycle_frame_interval = 3 ; TODO!?
music_frame_interval = 12

    ; TODO: This address range is Master-only, but it will do to experiment without
    ; starting to reassemble World1c to free up space there.
    org &ab9
    guard &d00
.start

.fixed_data
.game_cycle_frame_count
    equb 0
.note_index
    equb 0
.max_note_index
    equb (tune_duration - tune_pitch) - 1
.q_wrapper_addr
    equw q_wrapper
.tune_pitch_addr
    equw tune_pitch

    assert P% <= &ac0
    skipto &ac0

.event_handler
    ; We assume it's a VSYNC event; we won't enable anything else.
    pha:txa:pha

    ; Decrement game_cycle_frame_count, but don't go below 0.
    lda game_cycle_frame_count:beq dont_decrement_game_cycle_frame_count
    dec game_cycle_frame_count
.dont_decrement_game_cycle_frame_count

    ; Decrement music_cycle_frame_count; if it hits zero reset it and consider
    ; adding more notes to the OS sound queue.
    dec music_frame_count:bne done
    lda #music_frame_interval:sta music_frame_count
    ; Check how much free space there is in sound channel 2's buffer; we must
    ; avoid blindly adding more as we'll block here if the buffer becomes full.
    ; TODO: Do we need to be careful to keep as little as possible in the
    ; buffer? It depends exactly how the game turns this background music on
    ; and off, which it will need to do when it's doing "effects" (e.g. day/
    ; night transition).
    ldx #sound_channel_2_buffer_number:clv:sec:jsr jmp_cnpv
    cpx #5:bcc done ; buffer is nearly full, do nothing TODO: 5 is arbitrary
    ldx note_index
    lda tune_pitch,x:sta osword_7_block_pitch
    lda tune_duration,x:sta osword_7_block_duration
    ; TODO: shorter to use a loop to do both channels? or factor sta channel...jsr osword into a subroutine?
    lda #2:sta osword_7_block_channel
    lda #7:ldx #<osword_7_block:ldy #>osword_7_block:jsr osword
    inc osword_7_block_channel
    lda #7:ldx #<osword_7_block:ldy #>osword_7_block:jsr osword
    ldx note_index:cpx max_note_index:bne not_last_note
    ldx #255
.not_last_note
    inx:stx note_index
.done
    ldy #event_vsync ; restore Y
    pla:tax:pla
.rts
    rts

.jmp_cnpv
    jmp (cnpv)

.music_frame_count
    equb 1

.osword_7_block
.osword_7_block_channel
    equw 0
    equw -5 ; amplitude
.osword_7_block_pitch
    equw 0
.osword_7_block_duration
    equw 0

.tune_pitch
    equb 116, 88, 116, 0, 116, 120, 116, 0, 116, 88, 116, 116, 116, 120, 116, 0
    equb 116, 72, 100, 0, 100, 108, 100, 0, 100, 72, 100, 100, 100, 108, 100, 0
    equb 52, 32, 80, 0, 80, 88, 80, 0, 52, 32, 80, 80, 80, 88, 80, 0, 32, 32, 60
    equb 0, 60, 68, 60, 0, 60, 32, 60, 60, 60, 68, 60, 0, 0, 0, 0, 0, 0, 0
.tune_duration
    equb 3, 3, 2, 0, 3, 3, 3, 0, 2, 2, 2, 2, 2, 2, 2, 0, 3, 3, 3, 0, 3, 3, 3, 0
    equb 2, 2, 2, 2, 2, 2, 2, 0, 3, 3, 3, 0, 3, 3, 3, 0, 2, 2, 2, 2, 2, 2, 2, 0
    equb 3, 3, 3, 0, 3, 3, 3, 0, 2, 2, 2, 2, 2, 2, 2, 0, 0, 0, 0, 0, 0, 0
    assert (P% - tune_duration) == (tune_duration - tune_pitch)

.q_wrapper
    ; The main game loop does "CALLQ%" exactly once per game cycle, and that's
    ; the only call to this subroutine. This is therefore a good place to add
    ; speed regulation; we make the game loop call this wrapper and delay if
    ; necessary before forwarding onto Q%.
    ; TODO: In a final version we would have Q% set to this address and we would
    ; probably be assembled as part of World-1 and so can jmp/fall through
    ; straight into the "real" q_subroutine.
    ; TODO: If the game ever calls this without the VSYNC event enabled, it will
    ; hang forever. Could/should we test for this? Would it in fact work nicely
    ; to make this do *FX14,4 and *never* do it in the BASIC code? That way we
    ; wouldn't start playing the background music "early" as I suspect we might
    ; sometimes do. Would probably want to peek at some OS address to see if
    ; it's enabled rather than always doing *FX14,4.
.busy_wait
    lda game_cycle_frame_count:bne busy_wait
    ; TODO: Don't think we need to disable interrupts or do anything else here,
    ; but think about this again to be sure.
    lda #game_cycle_frame_interval:sta game_cycle_frame_count
    jmp (ri_q)

.end

    save "Extra", start, end
