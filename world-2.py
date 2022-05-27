from commands import *
from trace6502 import *
import acorn

acorn.bbc()

load(0x1100, "orig/world-2", "45a235d0cd9f8f3c7756958042143e7a")
entry(0x32d8, "start")

go()
