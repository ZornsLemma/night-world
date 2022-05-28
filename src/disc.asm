; We could use putfle to create !BOOT, but by doing this we stop beebasm warning
; about there being no SAVE command.
org &0000
.boot_start
    incbin "orig/boot"
.boot_end
save "!BOOT", boot_start, boot_end

; TODO: bbc-wor is pure BASIC; ideally we'd rebuild it from ASCII BASIC.
putfile "orig/bbc-wor", "BBC-Wor", &1900, &1900
; TODO: ditto "nightwo"
putfile "orig/nightwo", "Nightwo", &1100, &8023
