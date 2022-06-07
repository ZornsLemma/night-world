from __future__ import print_function
import sys

with open(sys.argv[1], "r") as f:
    constants = {}
    for line in f:
        line = line[:-1]
        constant_str = "constant"
        if line.startswith(constant_str):
            line = line[len(constant_str):]
            name = line[:line.index("=")].strip()
            value = line[line.index("=")+1:].strip()
            assert name not in constants
            constants[name] = value
        else:
            for name, value in constants.items():
                line = line.replace(name, value)
            print(line)
