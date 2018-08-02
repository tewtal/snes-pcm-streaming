.INCLUDE "stage1.inc"

.BANK $7f
.ORG $1000-16
.dw $3000, $0000, $1000, $7f7f	; payload size and target address
.dw $1000, $7f7f, $0000, $0000	; entry point and reserved

payload:
	ai16
	pea $0000
	plb
	plb

	lda.w #$0000
	sta.l $004200		; Disable NMI and autojoy reads
	sta.l $00420c		; Disable H-DMA
	
	clc 
	xce 
	
	rep #$30    ; REset Program status flags, $30 masks mem and idx size flags
	ldx #$1fff
	txs         ; transfer x register to stack pointer
	lda #$2100
	tcd         ; Transfer aCcumulator to Direct page

	sep #$30    ; set accumulator and index registers to 8 bit

	lda #$01
	sta $420d	; Enable FastROM 

	lda #$8f    ; enable force blank
	sta $00     ; direct page addressing mode, thus we get direct page ($2100) + $00 = $2100

	
	ldx #$01
-           	; loop over ppu registers $2101-$2133
	stz $00,x   ; write 0 to direct page ($2100) + x
	stz $00,x   ; some registers need to be written twice
	inx
	cpx #$33    ; while x < $33 ($2133)
	bne -

	rep #$20    ; set accumulator to 16 bit
	lda #$0000  ; move direct page to $0000 ("zero page")
	tcd

	rep #$10    ; index registers 16 bit
	sep #$20    ; accumulator 8 bit
	
	lda #$00
	sta $430b
	sta $420c
	sta $0100

	lda #$01
	sta $2105

	lda #$80
	sta $2115

	ldx #$5000
	stx $2116

	ldx #chr_data	; DMA graphics data to VRAM
	stx $4302
	lda #$7f
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

	ldx #tile_data	; DMA tile data to VRAM
	stx $4302
	lda #$7f
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
	inc a
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

	ldx #$8000	; DMA tile data to VRAM
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
	
	
	ldx #$0000		; Upload CGRAM
	lda #$00
	sta $002121

-
	lda.l pal_data,x
	sta $002122
	lda.l pal_data+1,x
	sta $002122
	inx
	inx
	cpx #$0200
	bne -

	stz $002121 
	lda #$00
	sta $002122 
	sta $002122 
	
	lda #$01
	sta $002105
	
	lda #$21
	sta $002107
	lda #$01
	sta $002108
	
	lda #$55
	sta $00210b
	
	lda #$03
	sta $00212c
	
	lda #$03
	sta $00212d
	
	lda #$00
	sta $002133
	
	lda #$0f
	sta $002100   		; set full screen brightness, no force blank
	
	lda #$ff
	sta $002141			; Stop SPC and put it in upload mode

	lda #<spc_reset
	sta $00
	lda #>spc_reset
	sta $01
	lda #$7f
	sta $02				; Write the source of our SPC data to $00-02

	lda #$20
	sta $1e00
	lda #$f7
	sta $1e01
	lda #$80
	sta $1e02
	lda #$6b
	sta $1e03
	
	;jsr $80f7
	jsl $001e00
	
	jsr spc_upload
	jsr spc_exec
	
	sep #$10
	ldx #$00
	ldy #$01
	
-
	lda.l loop,x
	sta.l $f00000,x
	inx
	bne -

	pea $0000
	plb
	plb
	
	sty $4016
	stz $4016

	ldx #$00
	rep #$20	
	lda #$4000
	tcd

	jml $f00000
	
loop:
	inx			
-	
	cpx $2142	
	bne -		

	nop
	nop
	
	lda $16		
	asl			
	asl			
				
	
	eor $16		
	asl			
	asl			
				

	eor $16		
	asl			
	asl			
				
	eor $16		
	sta $2140	
				

	lda $16		
	asl			
	asl			
				
	
	eor $16		
	asl			
	asl			
				

	eor $16		
	asl			
	asl			
			    

	eor $16		
	sta $2142
				

	lda $16		
	asl			
	asl			
				
	
	eor $16		
	asl			
	asl			
				

	eor $16		
	asl			
	asl			
				
	eor $16		
	
	nop
	nop
	pha
	
	sta $2140	
				

	lda $16		
	asl			
	asl			
				
	
	eor $16		
	asl			
	asl			
				

	eor $16		
	asl			
	asl			
				

	eor $16		
	sta $2142	
				
				
	sty $16
	stz $16
	
	pla
	lsr
	sta $210f
	
	bra loop		

spc_upload:
	sep #$20
	rep #$10
	
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
	phx
	tyx
	lda.l spc_data,x
	plx
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

spc_data:
	.incbin "spc.rom"

spc_reset:
    .dw $002a, $05a5
    .db $8f, $6c, $f2 
    .db $8f, $e0, $f3 ; Disable echo buffer writes and mute amplifier
    .db $8f, $7c, $f2 
    .db $8f, $ff, $f3 ; ENDX
    .db $8f, $7d, $f2 
    .db $8f, $00, $f3 ; Disable echo delay
    .db $8f, $4d, $f2 
    .db $8f, $00, $f3 ; EON
    .db $8f, $5c, $f2 
    .db $8f, $ff, $f3 ; KOFF
    .db $8f, $5c, $f2 
    .db $8f, $00, $f3 ; KOFF
    .db $8f, $80, $f1 ; Enable IPL ROM
    .db $5f, $c0, $ff ; jmp $ffc0
    .dw $0000, $0500

tile_data:
	.incbin "tile.map"	

chr_data:
	.incbin "gfx.chr"	

pal_data:
	.incbin "gfx.pal"


.ORG $4fff
	.db $00
