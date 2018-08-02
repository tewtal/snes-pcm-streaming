.INCLUDE "stage1.inc"

;========= Configure loader here =========
.DEFINE LOCATION $001e00
.DEFINE TMP $00f0
;=========================================


;========= Defines and header ============
.DEFINE BANK (LOCATION >> 16)
.DEFINE ADDR (LOCATION & $ffff)
.ENUM TMP
	p1d1: DW
	p2d1: DW
	p1d2: DW
	p2d2: DW
	input: DW
	ptr: DW
	ptr_bank: DW
.ENDE


.BANK BANK
.ORG ADDR-3
.db BANK, >ADDR, <ADDR
;=========================================

;========= Loader entrypoint =============
_start:
	a8
	i16
	lda.b #$00
	sta.l $004200
	sta.l $00420c
	ldx.w #$1fff
	txs
	jsr block_copy

block_copy:
	php
	phb
	
	ai16
	pea $0000
	plb
	plb

	ldx #$000f
-
	lda TMP,x
	sta.l (LOCATION+TMP),x
	dex
	bpl -
		
	jsr wait_frame
	
	jsr read_words
	lda p1d1
	lsr
	lsr
	lsr
	tax				; X = size / 8
	lda p2d1
	sta ptr
	lda p2d2
	sta ptr_bank
	
	jsr read_words
	lda p1d1
	sta.l entrypoint_jmp+1
	lda p1d2
	sta.l entrypoint_jmp+3
	ldy #$0000
	lda #$0017
	pha
-	
	jsr read_words
	lda p1d1
	sta [ptr], y
	iny
	lda p1d2
	sta [ptr], y
	iny
	lda p2d1
	sta [ptr], y
	iny
	lda p2d2
	sta [ptr], y
	pla
	dec a
	bne +
	jsr wait_frame
	lda #$0016
+
	pha
	dex
	bne -
	
-
	pla
	lda.l (LOCATION+TMP),x
	sta TMP,x
	inx
	cpx #$10
	bne -	
	
	plb
	plp
	bra entrypoint_jmp
		
read_words:
	phx
	phy
	lda #$0000
	sta p1d1
	sta p1d2
	sta p2d1
	sta p2d2
	inc a
	sta $4016
	dec a
	sta $4016
	ldy #$0010
--
	lda $4016
	sta input
	ldx #$0003
-
	lda input
	and.w masks,x
	cmp.w masks,x
	rol p1d1,x
	dex
	bpl -
	
	dey
	bne --
	ply
	plx
	rts

masks:
	.dw $0001, $0002, $0000
	
wait_frame:
-
	bit $4211
	bpl -
-
	bit $4211
	bmi -	
	rts
	
entrypoint_jmp:
	.db $5c
	
	
	
	