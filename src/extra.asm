cnpv = &22e
osword = &fff1
event_vsync = 4
sound_channel_2_buffer_number = 6

minor_frame_interval = 12 ; TODO!?

    ; TODO: This address range is Master-only, but it will do to experiment without
    ; starting to reassemble World1c to free up space there.
    org &ab9
    guard &d00
.start

.fixed_data
.frame_count
    equb 1
.note_index
    equb 0
.max_note_index
    equb tune_duration - tune_pitch
    skipto &ac0

.event_handler
    ; We assume it's a VSYNC event; we won't enable anything else.
    dec frame_count:bne rts
    pha:txa:pha
    lda #minor_frame_interval:sta frame_count
    ; Check how much free space there is in sound channel 2's buffer; we must
    ; avoid blindly adding more as we'll block here if the buffer becomes full.
    ; TODO: Do we need to be careful to keep as little as possible in the
    ; buffer? It depends exactly how the game turns this background music on
    ; and off, which it will need to do when it's doing "effects" (e.g. day/
    ; night transition).
    ldx #sound_channel_2_buffer_number:clv:sec:jsr jmp_cnpv
    cpx #5:bcc buffer_nearly_full ; TODO: 5 is arbitrary
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
.buffer_nearly_full
    ldy #event_vsync ; restore Y
    pla:tax:pla
.rts
    rts

.jmp_cnpv
    jmp (cnpv)

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

.end

    save "Extra", start, end
