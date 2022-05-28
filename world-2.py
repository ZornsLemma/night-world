from commands import *
from trace6502 import *
import acorn

acorn.bbc()
label(0x18, "basic_page_msb")

load(0x1100, "orig/world-2", "45a235d0cd9f8f3c7756958042143e7a")
entry(0x32d8, "start")

comment(0x32d8, "Select the tape filing system and relocate the code down to relocated_start, then set PAGE=relocated_start and start running the relocated code.")
comment(0x3316, "TODO: What exactly is going on here?")
expr(0x32e4, ">pydis_start")
label(0xd00, "relocated_start")
expr(0x32ec, ">relocated_start")
label(0x1100+0x2200, "relocation_end")
expr(0x32f0, ">(relocation_end-pydis_start)")
expr(0x3302, ">relocated_start")

go()
