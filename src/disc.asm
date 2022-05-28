; We could use putfle to create !BOOT, but by doing this we stop beebasm warning
; about there being no SAVE command.
org &0000
.boot_start
    incbin "orig/boot"
.boot_end
save "!BOOT", boot_start, boot_end

; TODO: Ideally we'd be able to rebuild BBC-Wor from ASCII BASIC source, but it's not
; all that interesting to modify and it contains embedded data so it's slightly
; fiddly.
putfile "orig/bbc-wor", "BBC-Wor", &1900, &1900
putfile "tmp/nightwo.tok", "Nightwo", &1100, &8023
