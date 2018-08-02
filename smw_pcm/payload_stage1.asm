.INCLUDE "stage1.inc"

.BANK $00
.ORG $1000-3	
.db $00, $10, $00	; Entry point of code

payload:
	sei
	ai16
	pea $0000
	plb
	plb
	ldx #$1fff
	txs
	
	lda.w #$0000
	sta.l $004200		; Disable NMI and autojoy reads
	sta.l $00420c		; Disable H-DMA
	
	sep #$20
	rep #$10
	
	lda #$ff
	sta $2141			; Stop SPC and put it in upload mode

	lda #<spc_reset
	sta $00
	lda #>spc_reset
	sta $01
	lda #$00
	sta $02				; Write the source of our SPC data to $00-02

	jsr $80f7
	
	jsr spc_upload
	jsr spc_exec
	
	sep #$10
	ldx #$00
	ldy #$01
	
-
	lda.l dma_loop,x
	sta $4300,x
	inx
	cpx #$5b
	bne -
	
	sty $4016
	stz $4016

	ldx #$00
	rep #$20	
	lda #$4000
	tcd

	jml $004300
	
dma_loop:
	inx			
-	
	cpx $2142	
	bne -		
				
	
	stz $16		
	lda $16		
	bra +
	.db $00, $00, $00, $04
	
+	
	asl			
	asl			
	
	eor $16		
	asl			
	asl			

	eor $16		
	asl			
	asl			

	bra +
	.db $00, $00, $00, $04

+	
	eor $16		
	sta $2140	


	inx			

	bra +
	.db $00, $00, $00, $00, $00, $00, $00, $05
+

-	
	cpx $2142	
	bne -		
				

	stz $16		
	lda $16		
	asl			

	bra +
	.db $00, $00, $00, $04
+
	asl			
	
	eor $16		
	asl			
	asl			

	eor $16		
	asl			
	asl			

	bra +
	.db $00, $00, $00, $00, $00
+	
	
	eor $16		
	sta $2140	

	sty $16		
	stz $16		

	bra dma_loop
	
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
	lda spc_data,y
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
	.db $00
