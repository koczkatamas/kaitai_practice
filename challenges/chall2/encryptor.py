#!/usr/bin/env python
import sys
import md5
import struct
import random

magic = "CRYPTROLO"

if len(sys.argv) < 4:
    print("Usage: %s key outfile infile1 [infile2] [...infileN]" % (sys.argv[0]))
    sys.exit()

key = sys.argv[1]
outfn = sys.argv[2]
filenames = sys.argv[3:]

random.seed(key)

with open(outfn, "wb") as outfile:
    outfile.write("CRYPTROLO")

    for filename in filenames:
        with open(filename, "rb") as infile:
            content = infile.read()

        outfile.write(struct.pack(">L", len(filename)))
        outfile.write(filename)
        outfile.write(md5.new(content).digest().encode("hex"))
        outfile.write(struct.pack(">L", len(content)))

        for pos in xrange(0, len(content), 4):
            outfile.write(struct.pack(">L", int(content[pos:pos+4].encode('hex').ljust(8, '0'),16) ^ random.getrandbits(32)))