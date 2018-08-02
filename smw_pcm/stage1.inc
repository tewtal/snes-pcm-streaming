.macro a8
	sep #$20
.endm

.macro a16
	rep #$20
.endm

.macro i8
	rep #$10
.endm

.macro ai8
	sep #$30
.endm

.macro ai16
	rep #$30
.endm

.macro i16
	rep #$10
.endm

.MEMORYMAP              
SLOTSIZE $10000     
DEFAULTSLOT 0           
SLOT 0 $0000            
.ENDME
.ROMBANKSIZE $10000
.ROMBANKS $FF
.BANK $00
.BASE $00