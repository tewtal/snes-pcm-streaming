#!/usr/bin/env python
import sys
import os
name = ""
base_name = ""

def write_frame(data, i, sub):
	d = data[i+1]
	if sub == 1:
		s = ".. 0 0|"
	else:
		s = "F. 0 0|"
	s += "B" if (d & 0x80) > 0 else "."	
	s += "Y" if (d & 0x40) > 0 else "."	
	s += "s" if (d & 0x20) > 0 else "."	
	s += "S" if (d & 0x10) > 0 else "."	
	s += "u" if (d & 0x08) > 0 else "."	
	s += "d" if (d & 0x04) > 0 else "."	
	s += "l" if (d & 0x02) > 0 else "."	
	s += "r" if (d & 0x01) > 0 else "."	
	d = data[i]
	s += "A" if (d & 0x80) > 0 else "."	
	s += "X" if (d & 0x40) > 0 else "."	
	s += "L" if (d & 0x20) > 0 else "."	
	s += "R" if (d & 0x10) > 0 else "."	
	s += "0" if (d & 0x08) > 0 else "."	
	s += "1" if (d & 0x04) > 0 else "."	
	s += "2" if (d & 0x02) > 0 else "."	
	s += "3" if (d & 0x01) > 0 else "."	
	s += "|"

	d = data[i+5]
	s += "B" if (d & 0x80) > 0 else "."	
	s += "Y" if (d & 0x40) > 0 else "."	
	s += "s" if (d & 0x20) > 0 else "."	
	s += "S" if (d & 0x10) > 0 else "."	
	s += "u" if (d & 0x08) > 0 else "."	
	s += "d" if (d & 0x04) > 0 else "."	
	s += "l" if (d & 0x02) > 0 else "."	
	s += "r" if (d & 0x01) > 0 else "."	
	d = data[i+4]
	s += "A" if (d & 0x80) > 0 else "."	
	s += "X" if (d & 0x40) > 0 else "."	
	s += "L" if (d & 0x20) > 0 else "."	
	s += "R" if (d & 0x10) > 0 else "."	
	s += "0" if (d & 0x08) > 0 else "."	
	s += "1" if (d & 0x04) > 0 else "."	
	s += "2" if (d & 0x02) > 0 else "."	
	s += "3" if (d & 0x01) > 0 else "."	
	s += "|"

	d = data[i+3]
	s += "B" if (d & 0x80) > 0 else "."	
	s += "Y" if (d & 0x40) > 0 else "."	
	s += "s" if (d & 0x20) > 0 else "."	
	s += "S" if (d & 0x10) > 0 else "."	
	s += "u" if (d & 0x08) > 0 else "."	
	s += "d" if (d & 0x04) > 0 else "."	
	s += "l" if (d & 0x02) > 0 else "."	
	s += "r" if (d & 0x01) > 0 else "."	
	d = data[i+2]
	s += "A" if (d & 0x80) > 0 else "."	
	s += "X" if (d & 0x40) > 0 else "."	
	s += "L" if (d & 0x20) > 0 else "."	
	s += "R" if (d & 0x10) > 0 else "."	
	s += "0" if (d & 0x08) > 0 else "."	
	s += "1" if (d & 0x04) > 0 else "."	
	s += "2" if (d & 0x02) > 0 else "."	
	s += "3" if (d & 0x01) > 0 else "."	
	s += "|"

	d = data[i+7]
	s += "B" if (d & 0x80) > 0 else "."	
	s += "Y" if (d & 0x40) > 0 else "."	
	s += "s" if (d & 0x20) > 0 else "."	
	s += "S" if (d & 0x10) > 0 else "."	
	s += "u" if (d & 0x08) > 0 else "."	
	s += "d" if (d & 0x04) > 0 else "."	
	s += "l" if (d & 0x02) > 0 else "."	
	s += "r" if (d & 0x01) > 0 else "."	
	d = data[i+6]
	s += "A" if (d & 0x80) > 0 else "."	
	s += "X" if (d & 0x40) > 0 else "."	
	s += "L" if (d & 0x20) > 0 else "."	
	s += "R" if (d & 0x10) > 0 else "."	
	s += "0" if (d & 0x08) > 0 else "."	
	s += "1" if (d & 0x04) > 0 else "."	
	s += "2" if (d & 0x02) > 0 else "."	
	s += "3" if (d & 0x01) > 0 else "."	

	print(s)

if sys.argv[1] == "":
	print("You need to specify a file to convert")
	sys.exit()
else:
	name = sys.argv[1]
	
f = open(os.path.dirname(os.path.realpath(__file__)) + "\\" + name, "rb")

data = [int(x) for x in f.read()]
c = 0

try:
	write_frame(data, 0, 0)
	for i in range(1, 0x18, 1):
		write_frame(data, i*8, 1)
except:
	pass
	
for j in range(0x18, len(data), 0x16):
	try:
		write_frame(data, j*8, 0)
		for i in range(1, 0x16, 1):
			write_frame(data, (i+j)*8, 1)
	except:
		break
