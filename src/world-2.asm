; TODO: Get rid of the py8dis hex dump etc?

osbyte_tape = &8c
osbyte_insert_buffer = &8a

basic_page_msb = &0018
l0080 = &0080
l0081 = &0081
l0082 = &0082
l0083 = &0083
relocated_start = &0d00
osbyte = &fff4

    org &1100

.pydis_start
.basic_start
    incbin "tmp/world-2.tok"
.basic_end
if basic_end and &ff = 0
    basic_end_rounded = basic_end
else
    basic_end_rounded = (basic_end and &ff00) + &100
endif

.start
; Select the tape filing system and relocate the BASIC program down to
; relocated_start, then run it.
    lda #osbyte_tape                                                  ; 32d8: a9 8c       ..
    ldx #0                                                            ; 32da: a2 00       ..
    jsr osbyte                                                        ; 32dc: 20 f4 ff     ..
    lda #0                                                            ; 32df: a9 00       ..
    sta l0080                                                         ; 32e1: 85 80       ..
    lda #>basic_start                                                 ; 32e3: a9 11       ..
    sta l0081                                                         ; 32e5: 85 81       ..
    lda #0                                                            ; 32e7: a9 00       ..
    sta l0082                                                         ; 32e9: 85 82       ..
    lda #>relocated_start                                             ; 32eb: a9 0d       ..
    sta l0083                                                         ; 32ed: 85 83       ..
    ldx #>(basic_end_rounded-basic_start)                             ; 32ef: a2 22       ."
    ldy #0                                                            ; 32f1: a0 00       ..
.copy_loop
    lda (l0080),y                                                     ; 32f3: b1 80       ..
    sta (l0082),y                                                     ; 32f5: 91 82       ..
    iny                                                               ; 32f7: c8          .
    bne copy_loop                                                         ; 32f8: d0 f9       ..
    inc l0081                                                         ; 32fa: e6 81       ..
    inc l0083                                                         ; 32fc: e6 83       ..
    dex                                                               ; 32fe: ca          .
    bne copy_loop                                                         ; 32ff: d0 f2       ..
    lda #>relocated_start                                             ; 3301: a9 0d       ..
    sta basic_page_msb                                                ; 3303: 85 18       ..
    lda #osbyte_insert_buffer                                         ; 3305: a9 8a       ..
    ldy #&4f ; 'O'                                                    ; 3307: a0 4f       .O
    jsr osbyte                                                        ; 3309: 20 f4 ff     ..
    ldy #&2e ; '.'                                                    ; 330c: a0 2e       ..
    jsr osbyte                                                        ; 330e: 20 f4 ff     ..
    ldy #&0d                                                          ; 3311: a0 0d       ..
    jsr osbyte                                                        ; 3313: 20 f4 ff     ..
; TODO: This inserts the token for "RUN", which works, but it's not clear why.
    ldy #&f9                                                          ; 3316: a0 f9       ..
    jsr osbyte                                                        ; 3318: 20 f4 ff     ..
    ldy #&0d                                                          ; 331b: a0 0d       ..
    jsr osbyte                                                        ; 331d: 20 f4 ff     ..
    brk                                                               ; 3320: 00          .
.pydis_end

MAKE_IMAGE =? FALSE
if MAKE_IMAGE
    save "World-2", pydis_start, pydis_end, start
else
    save pydis_start, pydis_end
endif
