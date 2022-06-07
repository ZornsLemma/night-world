from __future__ import print_function
import re
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
            # Replacing comment bodies allows arbitrarily long comments, which
            # is useful when we're using line numbers and therefore can't
            # always split long comments over multiple lines because we don't
            # have enough space in the line number sequence. We keep the REM as
            # a stub to avoid breaking the syntax.
            line = re.sub(r"([0-9:])REM.*$", r"\1REM", line)
            line = line.strip()
            if line != "":
                print(line)
