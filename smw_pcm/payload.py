#!/usr/bin/env python
import sys
import os
name = ""
base_name = ""

if sys.argv[1] == "":
	print("You need to specify a file to convert")
	sys.exit()
else:
	name = sys.argv[1]
	
f = open(os.path.dirname(os.path.realpath(__file__)) + "\\" + name, "rb")
fo = open(os.path.dirname(os.path.realpath(__file__)) + "\\" + name + ".r16m", "wb")

data = [int(x) for x in f.read()]

for i in range(0, len(data), 8):
	out = [data[i+1], data[i], data[i+5], data[i+4], 0x00, 0x00, 0x00, 0x00, data[i+3], data[i+2], data[i+7], data[i+6], 0x00, 0x00, 0x00, 0x00]
	fo.write(bytes(out))

fo.close()