import sys
from collections import defaultdict

c = {}
with open(sys.argv[1], "r") as f:
    for line in f:
        s = line[:-1].split(" ")
        addr = int(s[0], 16)
        assert addr not in c
        c[addr] = int(s[1])

ranges = (
    ("draw room", 0x2E00, 0x3200), # code assembled by PROCcc will live roughly here
    ("q_subroutine", 0x4f00, 0x4f9f),
    ("r_subroutine", 0x4f9f, 0x5025), # early end as s_subroutine overlaps a bit and this isn't used
    ("s_subroutine", 0x5025, 0x52e3),
    ("t_subroutine", 0x52e3, 0x53fb),
    ("u_subroutine", 0x53fb, 0x5499),
    ("v_subroutine", 0x5499, 0x54dc),
    ("BASIC", 0x8000, 0xc000),
    ("other OS", 0xc000, 0x10000),
    ("OSWORD 9", 0xc735, 0xc748), # .osword9EntryPoint
    ("OSWORD 9", 0xd839, 0xd85d), # .readPixel
    ("OSWORD 9", 0xd149, 0xd176), # .plotConvertExternalAbsoluteCoordinatesToPixels
    ("OSWORD 9", 0xd176, 0xd1ad), # .convertExternalRelativeCoordinateToAbsoluteAndDivideByTwo
    ("OSWORD 9", 0xd1ad, 0xd1b8), # .signedDivideCoordinateByTwo
    ("OSWORD 9", 0xd85c, 0xd8ce), # .checkPointXInBoundsAndSetScreenAddresses
    ("OSWORD 9", 0xd10f, 0xd128), # .checkPointXIsWithinGraphicsWindow
    ("OSWORD 9", 0xd128, 0xd149), # .checkPointIsWithinWindowHorizontalOrVertical
    ("OSWORD 9", 0xc750, 0xc759), # .storeAInParameterBlock
)

range_dict = {}
for name, start, end in ranges:
    for addr in range(start, end):
        #assert addr not in range_dict
        range_dict[addr] = name

region_counts = defaultdict(int)
for addr, count in c.items():
    region_counts[range_dict[addr]] += count
    #if range_dict[addr] == "main RAM":
    #    print(hex(addr), count)

total_count = sum(x for x in region_counts.values())
for name, count in sorted(region_counts.items(), key=lambda x: -x[1]):
    print("%-12s %5.1f%% (%8d)" % (name, 100*float(count)/total_count, count))
