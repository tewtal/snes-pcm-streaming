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

data = [int(x) for x in f.read()]
c = 0
for i in range(0, len(data), 16):	
	d = data[i]
	s = "F. 0 0|"
	s += "B" if (d & 0x80) > 0 else "."	
	s += "Y" if (d & 0x40) > 0 else "."	
	s += "s" if (d & 0x20) > 0 else "."	
	s += "S" if (d & 0x10) > 0 else "."	
	s += "u" if (d & 0x08) > 0 else "."	
	s += "d" if (d & 0x04) > 0 else "."	
	s += "l" if (d & 0x02) > 0 else "."	
	s += "r" if (d & 0x01) > 0 else "."	
	d = data[i+1]
	s += "A" if (d & 0x80) > 0 else "."	
	s += "X" if (d & 0x40) > 0 else "."	
	s += "L" if (d & 0x20) > 0 else "."	
	s += "R" if (d & 0x10) > 0 else "."	
	s += "0" if (d & 0x08) > 0 else "."	
	s += "1" if (d & 0x04) > 0 else "."	
	s += "2" if (d & 0x02) > 0 else "."	
	s += "3" if (d & 0x01) > 0 else "."	
	s += "|"

	d = data[i+2]
	s += "B" if (d & 0x80) > 0 else "."	
	s += "Y" if (d & 0x40) > 0 else "."	
	s += "s" if (d & 0x20) > 0 else "."	
	s += "S" if (d & 0x10) > 0 else "."	
	s += "u" if (d & 0x08) > 0 else "."	
	s += "d" if (d & 0x04) > 0 else "."	
	s += "l" if (d & 0x02) > 0 else "."	
	s += "r" if (d & 0x01) > 0 else "."	
	d = data[i+3]
	s += "A" if (d & 0x80) > 0 else "."	
	s += "X" if (d & 0x40) > 0 else "."	
	s += "L" if (d & 0x20) > 0 else "."	
	s += "R" if (d & 0x10) > 0 else "."	
	s += "0" if (d & 0x08) > 0 else "."	
	s += "1" if (d & 0x04) > 0 else "."	
	s += "2" if (d & 0x02) > 0 else "."	
	s += "3" if (d & 0x01) > 0 else "."	
	s += "|"

	d = data[i+8]
	s += "B" if (d & 0x80) > 0 else "."	
	s += "Y" if (d & 0x40) > 0 else "."	
	s += "s" if (d & 0x20) > 0 else "."	
	s += "S" if (d & 0x10) > 0 else "."	
	s += "u" if (d & 0x08) > 0 else "."	
	s += "d" if (d & 0x04) > 0 else "."	
	s += "l" if (d & 0x02) > 0 else "."	
	s += "r" if (d & 0x01) > 0 else "."	
	d = data[i+9]
	s += "A" if (d & 0x80) > 0 else "."	
	s += "X" if (d & 0x40) > 0 else "."	
	s += "L" if (d & 0x20) > 0 else "."	
	s += "R" if (d & 0x10) > 0 else "."	
	s += "0" if (d & 0x08) > 0 else "."	
	s += "1" if (d & 0x04) > 0 else "."	
	s += "2" if (d & 0x02) > 0 else "."	
	s += "3" if (d & 0x01) > 0 else "."	
	s += "|"

	d = data[i+10]
	s += "B" if (d & 0x80) > 0 else "."	
	s += "Y" if (d & 0x40) > 0 else "."	
	s += "s" if (d & 0x20) > 0 else "."	
	s += "S" if (d & 0x10) > 0 else "."	
	s += "u" if (d & 0x08) > 0 else "."	
	s += "d" if (d & 0x04) > 0 else "."	
	s += "l" if (d & 0x02) > 0 else "."	
	s += "r" if (d & 0x01) > 0 else "."	
	d = data[i+11]
	s += "A" if (d & 0x80) > 0 else "."	
	s += "X" if (d & 0x40) > 0 else "."	
	s += "L" if (d & 0x20) > 0 else "."	
	s += "R" if (d & 0x10) > 0 else "."	
	s += "0" if (d & 0x08) > 0 else "."	
	s += "1" if (d & 0x04) > 0 else "."	
	s += "2" if (d & 0x02) > 0 else "."	
	s += "3" if (d & 0x01) > 0 else "."	

	print(s)
