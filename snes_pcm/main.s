architecture wdc65816

macro seek(variable offset) {
  origin ((offset & $7f0000) >> 1) | (offset & $7fff)
  base offset
}


seek($80ffc0)
	db "SPC AUDIO STREAM TEST"
	db $30
	db $20
	db $05
	db $03

seek($80ffe4)
	dw $f000
	dw $f000
	dw $f000
	dw $f000
	dw $8000
	dw $f000
	
seek($80fff4)
	dw $f000
	dw $f000
	dw $f000
	dw $f000
	dw $8000
	dw $f000

seek($808000)
	jsl $808100

seek($808100)
_start:
	sei // SEt Interrupt disable flag (disable interrupts)
	clc // CLear Carry
	xce // eXchange Carry and Emulation flags

	rep #$30    // REset Program status flags, $30 masks mem and idx size flags
	ldx #$1fff
	txs         // transfer x register to stack pointer
	lda #$2100
	tcd         // Transfer aCcumulator to Direct page

	sep #$30    // set accumulator and index registers to 8 bit
	lda #$8f    // enable force blank
	
	lda #$01
	sta $420d	// Enable FastROM 
	
	sta $00     // direct page addressing mode, thus we get direct page ($2100) + $00 = $2100
	ldx #$01
	-            // loop over ppu registers $2101-$2133
	stz $00,x   // write 0 to direct page ($2100) + x
	stz $00,x   // some registers need to be written twice
	inx
	cpx #$33    // while x < $33 ($2133)
	bne -

	rep #$20    // set accumulator to 16 bit
	lda #$0000  // move direct page to $0000 ("zero page")
	tcd

main:
	rep #$10    // index registers 16 bit
	sep #$20    // accumulator 8 bit
	
	lda #$00
	sta $430b
	sta $420c
	sta $0100
	
	lda #$80
	sta $2100	// Forced blanking
	


	lda #$80
	sta $2115

	ldx #$5000
	stx $2116
	
	ldx #chr_data	// DMA graphics data to VRAM
	stx $4302
	lda #$80
	sta $4304
	ldx #$2000
	stx $4305
	lda #$18
	sta $4301
	lda #$01
	sta $4300
	lda #$01
	sta $420b


	ldx #$2000
	stx $2116

	ldx #tile_data	// DMA tile data to VRAM
	stx $4302
	lda #$80
	sta $4304
	ldx #$0800
	stx $4305
	lda #$18
	sta $4301
	lda #$01
	sta $4300
	lda #$01
	sta $420b

	ldx #$0000
	lda #$0c
	sta $7ffffe
	lda #$d0
	ldy #$0000
-
	sta $7f8000,x
	pha
	lda $7ffffe
	sta $7f8001,x
	pla
	inx
	inx
	iny	
	inc
	cmp #$e0
	bne +
	lda #$d0
+
	
	cpy #$0008
	bne next
	ldy #$0000
	pha
	lda $7ffffe
	cmp #$0c
	beq +
	lda #$0c
	sta $7ffffe
	pla
	jmp next
+
	lda #$10
	sta $7ffffe	
	pla
next:
	cpx #$0800
	bne -

	ldx #$0000
-
	lda #$0f
	sta $7f8800,x
	inx
	lda #$00
	sta $7f8800,x
	inx
	cpx #$0800
	bne -
	
	ldx #$0000
	stx $2116

	ldx #$8000	// DMA tile data to VRAM
	stx $4302
	lda #$7f
	sta $4304
	ldx #$1000
	stx $4305
	lda #$18
	sta $4301
	lda #$01
	sta $4300
	lda #$01
	sta $420b	
	
	
	ldx #$0000		// Upload CGRAM
	lda #$00
	sta $2121

-
	lda pal_data,x
	sta $2122
	lda pal_data+1,x
	sta $2122
	inx
	inx
	cpx #$0200
	bne -

	stz $2121   // cgram address $00
	lda #$00
	sta $2122   // write cgram low byte
	sta $2122   // high byte

	lda #$01
	sta $2105
	
	lda #$21
	sta $2107
	lda #$01
	sta $2108
	
	lda #$55
	sta $210b
	
	lda #$03
	sta $212c
	
	lda #$03
	sta $212d
	
	lda #$00
	sta $2133
	
	lda #$0f
	sta $2100   // set full screen brightness, no force blank

	jsr	spc_upload
	jsr spc_exec

	sep #$10
	ldx #$00
	ldy #$01

-
	lda loop,x
	sta.l $f00000,x
	inx
	bne -
	
	
	sty $4016
	stz $4016

	ldx #$00
	rep #$20	
	lda #$4000
	tcd

	jml $f00000	
	
loop:
	inx			// 2
-	
	cpx $2142	// 4
	bne -		// 3
				// 9 cycles + jitter of at last 7 or so
				// 16   [stx $f6]

	nop
	nop
	
	lda $16		// 4 (8)
	asl			// 2
	asl			// 2
				// 28
	
	eor $16		// 4 (8) [ldw $f4]		// Start writing stereo sample 2 (4367-4368) + (436a-436b) to DSP
	asl			// 2
	asl			// 2
				// 40

	eor $16		// 4 (8)
	asl			// 2
	asl			// 2	 [stw $00]
				// 52
	eor $16		// 4 (8)	
	sta $2140	// 5
				// 80		

	lda $16		// 4 (8)  [stw $02]		// Done writing stereo sample 2 (4367-4368) + (436a-436b) to DSP
	asl			// 2	 
	asl			// 2	  [nop]
				// 92
	
	eor $16		// 4 (8)  [nop]
	asl			// 2
	asl			// 2	  [nop]
				// 104

	eor $16		// 4 (8)  [nop]
	asl			// 2
	asl			// 2
			    // 116

	eor $16		// 4 (8)  
	sta $2142
				// 129	  [ldw $f4]		// Start writing stereo sample 1 (436f-4370) + (4368-436a) to DSP

	lda $16		// 4 (8)
	asl			// 2
	asl			// 2
				// 141
	
	eor $16		// 4 (8)  [stw $00]
	asl			// 2
	asl			// 2
				// 153

	eor $16		// 4 (8)
	asl			// 2	  [ldw $f6]
	asl			// 2
				// 165

				
	eor $16		// 4 (8)
	
	nop
	pha	
	sta $2140	// 5 
				// 178

	lda $16		// 4 (8)
	asl			// 2
	asl			// 2
				// 141
	
	eor $16		// 4 (8)  [stw $00]
	asl			// 2
	asl			// 2
				// 153

	eor $16		// 4 (8)
	asl			// 2	  [ldw $f6]
	asl			// 2
				// 165

	eor $16		// 4 (8)
	sta $2142	// 5 
				// 178

	pla
	lsr
	sta $210f

				
	sty $16
	stz $16

	bra loop	
	
		

spc_upload:
	sep #$20
	
	lda #$a1
	sta $21
	lda #$00
	sta $20
	
	ldx #$0200
	lda #$aa

-	
	cmp $2140
	bne -
	
	stx $2142
	lda #$01
	sta $2141
	lda #$cc
	sta $2140	
	
-	
	cmp $2140
	bne -
	
	ldy #$0000
	
spc_loop:
	xba
	lda spc_data+$200,y
	xba
	
	tya
	
	rep #$20
	sta $2140
	sep #$20
	
-	
	cmp $2140
	bne -

	iny
	dex
	bne spc_loop
	
	ldx #$ffc9
	stx $2142
	
	xba
	lda #$00
	sta $2141
	xba
	
	clc
	adc #$02
	
	rep #$20
	sta $2140
	sep #$20
	
-	
	cmp $2140
	bne -

	rts
	
spc_exec:
	ldx #$0200
	sep #$20
	lda #$aa

-	
	cmp $2140
	bne -

	stx $2142
	
	lda #$00
	sta $2141
	lda #$cc
	sta $2140
	
-	
	cmp $2140
	bne -

	rts

chr_data:
	insert "gfx.chr"

spc_data:
	insert "spc.bin"
	
pal_data:
	insert "gfx.pal"

tile_data:
	insert "tile.map"
	
seek($80f000)
	rti