; TODO: we could incbin and save this, to stop beebasm warning
putfile "orig/boot", "!BOOT", 0, 0
; TODO: bbc-wor is pure BASIC; ideally we'd rebuild it from ASCII BASIC.
putfile "orig/bbc-wor", "BBC-Wor", &1900, &1900
; TODO: ditto "nightwo"
putfile "orig/nightwo", "Nightwo", &1100, &8023
