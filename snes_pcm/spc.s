architecture spc700
origin $0000
fill $100, $00

origin $0200
	str $f4=#$00
	str $f5=#$00
	str $f6=#$00
	str $f7=#$00
	str $f1=#$00
	
	str $f2=#$0c
	str $f3=#$00
	
	str $f2=#$1c
	str $f3=#$00
	
	str $f2=#$5c
	str $f3=#$ff

	str $f2=#$5d
	str $f3=#$a0

	str $f2=#$2d
	str $f3=#$00

	str $f2=#$7c
	str $f3=#$00

	str $f2=#$3d
	str $f3=#$00

	str $f2=#$4d
	str $f3=#$00
	
	str $f2=#$6c
	str $f3=#$a0
	
	str $f2=#$6d
	str $f3=#$00
	
	str $f2=#$7d
	str $f3=#$00
		
	str $f2=#$0f
	str $f3=#$7f
	str $f2=#$1f
	str $f3=#$00
	str $f2=#$2f
	str $f3=#$00
	str $f2=#$3f
	str $f3=#$00
	str $f2=#$4f
	str $f3=#$00
	str $f2=#$5f
	str $f3=#$00
	str $f2=#$6f
	str $f3=#$00
	str $f2=#$7f
	str $f3=#$00

	str $00=#$00
	str $01=#$00
	
	str $f2=#$2c
	str $f3=#$80
	
	str $f2=#$3c
	str $f3=#$80

	str $f2=#$0d
	str $f3=#$80

	jmp loop
	
origin $0300
loop:
	stx $f6		// 4	  // 14
	
	ldw $f4		// 5	  // 31.5
	stw $00		// 5	  // 49
	ldw $f6		// 5	  // 66.5
	stw $02		// 5	  // 84
	
	nop			// 2	  // 91
	nop			// 2	  // 98
	nop			// 2	  // 105
	nop			// 2 (32) // 111

	ldw $f4		// 5	  // 128.5
	stw $00		// 5	  // 146
	ldw $f6		// 5	  // 163.5
	stw $02		// 5	  // 181

	nop			// 2	  // 412
	nop			// 2	  // 419
	inx			// 2	  // 436.5
	jmp end		// 3	  // 429.5	
end:
	jmp loop	// 3	  // 446
				// (64)

				
				

				
				
	
				