@echo off
echo Building inputs
wla-65816.exe -o stage1_small_lsnes.asm stage1l.o
wla-65816.exe -o payload.asm payload.o
wlalink.exe -b stage1l.prj stage1l.bin
wlalink.exe -b payload.prj payload.bin
stage1.py stage1l.bin
payload.py payload.bin
display.py stage1l.bin.inp > stage1l.inputs
display_s.py payload.bin > payload.inputs
copy /b stage1l.inputs + payload.inputs input
rem del *.bin
del *.bin.r16m
del *.o
rem del *.inp
echo Done