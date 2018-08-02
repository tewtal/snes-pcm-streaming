.INCLUDE "stage1.inc"

;========= Configure loader here =========
.DEFINE LOCATION $7fff00
.DEFINE TMP $00f0
;=========================================


;========= Defines and header ============
.DEFINE BANK (LOCATION >> 16)
.DEFINE ADDR (LOCATION & $ffff)
.ENUM TMP
	p1d1: DW
	p1d2: DW
	p2d1: DW
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
	lda.w #$00
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
	ldy #$0000
-
	lda TMP,x
	sta.l (LOCATION+TMP),x
	dex
	bpl -
		
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
	dex
	bne -
	
-
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
	lda #$0000
	sta p1d1
	sta p1d2
	sta p2d1
	sta p2d2
	inc a
	sta $4016
	dec a
	sta $4016
	ldx #$0010
-
	lda $4016
	sta input
	
	and #$0001
	rol p1d1
	lda input
	and #$0002
	rol p2d1
	lda input
	and #$0100
	rol p1d2
	lda input
	and #$0200
	rol p2d2
	dex
	bne -
	plx
	rts

entrypoint_jmp:
	.db $5c
	
	
	
	