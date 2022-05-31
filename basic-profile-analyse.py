import sys
from collections import defaultdict

with open(sys.argv[1], "r") as f:
    d = defaultdict(int)
    for line in f:
        line = line[:-1]
        s = line.split()
        d[int(s[0], 16)] += int(s[1])

t = sum(d.values())
s = 0
for k, v in sorted(d.items(), key=lambda x:-x[1]):
    s += v
    print("%04X %5.1f%% %5.1f%% (%8d)" % (k, 100*float(v)/t, 100*float(s)/t, v))
