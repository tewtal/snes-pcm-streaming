.INCLUDE "stage1.inc"
.BANK $00
.ORG $1e00-3	
.db $00, $1e, $00	; Entry point of code

stage1:
	ldx.w #$1fff
	txs
	lda.w #$0000
	sta.l $004200		; Disable NMI and autojoy reads
	sta.l $00420c		; Disable H-DMA

	jml block_copy		; Copy first block

.org $1e14
block_copy:
	pha
	phx
	phy
	php
	phb
	ai16

	jsr wait_frame

	jsr read_words	; Read payload size and target
	lda.l $004342
	sta.l $7ffff6
	
	lda.l $004362
	tax
	clc
	adc.l $7ffff6
	sta.l $7ffff6	; Save target+size

	lda.l $004372
	pha
	plb
	plb

	jsr read_words	; Read entry point and reserved
	lda.w #$5c5c
	sta.l $7ffff9
	lda.l $004342
	sta.l $7ffffa
	lda.l $004352
	sta.l $7ffffc
	ldy.w #$0017


-	
	dey
	bne +
	ldy.w #$0016
	jsr wait_frame
+
	jsr read_words
	lda.l $004342
	sta.w $0000, x
	lda.l $004352
	sta.w $0002, x
	lda.l $004362
	sta.w $0004, x
	lda.l $004372
	sta.w $0006, x
	txa
	clc
	adc.w #$0008
	tax
	cmp.l $7ffff6
	bne -

	lda.l $7ffffc
	cmp.w #$ffff
	beq +
	jml $7ffff9

+	plb
	plp
	ply
	plx
	pla
	rtl

wait_frame:
-
	lda.l $004212
	and #$0080
	cmp #$0080
	bne -
-
	lda.l $004212
	and #$0080
	cmp #$0080
	beq -	
	rts
	
read_words:
	phy
	phx
	phb
	pea $0000
	plb
	plb
	stz $4342
	stz $4352
	stz $4362
	stz $4372
	ldy #$0001
	sty $4016
	stz $4016

	ldx #$0010
-	
	ldy $4016	

	tya
	and #$0001
	cmp #$0001
	rol $4342

	tya
	and #$0002
	cmp #$0002
	rol $4362
	
	tya
	and #$0100
	cmp #$0100
	rol $4352

	tya
	and #$0200
	cmp #$0200
	rol $4372

	dex
	bne -

	plb
	plx
	ply
	rts
	nop