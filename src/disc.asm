; We could use putfile to create !BOOT, but by doing this we stop beebasm
; warning about there being no SAVE command.
org &0000
.boot_start
    incbin "orig/boot"
.boot_end
save "!BOOT", boot_start, boot_end

; Put a file on the disc to help indicate this is a hacked version.
; TODO: If this ever gets tidied up, we might end up announcing this on the
; instructions page or something, but for now this will do.
org &1000
.message_start
    equs "Work-in-progress disassembly/re-assembly: ", TIME$, 13
.message_end
save "README", message_start, message_end, 0, 0

; TODO: Ideally we'd be able to rebuild BBC-Wor from ASCII BASIC source, but
; it's not all that interesting to modify and it contains embedded data so it's
; slightly fiddly.
putfile "orig/bbc-wor", "BBC-Wor", &1900, &1900
putfile "tmp/nightwo.tok", "Nightwo", &1100, &8023

; TODO: temporary
putbasic "music-test.bas", "MUSTEST"
