@echo off
echo Building inputs
wla-65816.exe -o stage1_small.asm stage1.o
wla-65816.exe -o payload.asm payload.o
wlalink.exe -b stage1.prj stage1.bin
wlalink.exe -b payload.prj payload.bin
stage1.py stage1.bin
payload.py payload.bin
copy /b sd2snes.r16m + smw_base.r16m + stage1.bin.r16m + payload.bin.r16m + blank.r16m build\smw_sd2snes.r16m
copy /b smw_base.r16m + stage1.bin.r16m + payload.bin.r16m + blank.r16m build\smw_normal.r16m
rem del *.bin
del *.bin.r16m
del *.o
del *.inp
echo Done