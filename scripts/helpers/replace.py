#!/usr/bin/python
import sys

with open(sys.argv[1]) as f:
    newText = f.read().replace(str(sys.argv[2]).strip(), str(sys.argv[3]).strip())

with open(sys.argv[1], "w") as f:
    f.write(newText)
