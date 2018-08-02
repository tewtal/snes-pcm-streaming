@echo off
echo Building inputs
wla-65816.exe -o payload_stage1.asm payload1.o
wlalink.exe -b payload1.prj payload1.bin
stage1.py payload1.bin
copy /b sd2snes.r16m + smw_base.r16m + payload1.bin.r16m build\smw_sd2snes.r16m
copy /b smw_base.r16m + payload1.bin.r16m build\smw_normal.r16m
rem del *.bin
rem del *.bin.r16m
rem del *.state.r16m
rem del *.o
rem del *.inp
echo Done