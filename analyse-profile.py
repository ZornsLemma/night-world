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
    ("game m/c", 0xd00, 0x8000),
    ("BASIC", 0x8000, 0xc000),
    ("OS", 0xc000, 0x10000),
)
range_dict = {}
for name, start, end in ranges:
    for addr in range(start, end):
        assert addr not in range_dict
        range_dict[addr] = name

region_counts = defaultdict(int)
for addr, count in c.items():
    region_counts[range_dict[addr]] += count

total_count = sum(x for x in region_counts.values())
for name, count in region_counts.items():
    print("%20s %3.1f%% (%8d)" % (name, 100*float(count)/total_count, count))
