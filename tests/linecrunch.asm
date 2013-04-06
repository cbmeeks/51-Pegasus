// Imports

.pc = $0801 "Basic Upstart"
:BasicUpstart(start)

.pc = $0900 "FLD"

start:	
	sei
	lda #%11111111		// make sure $3FFF is visible
	sta $3fff

	// lda	#%00010111		// make sure characters like 'y', 'g', etc. are visible in linecrunch area
	// sta $d018	

loop1:
	bit $d011 			// Wait for new frame
	bpl *-3
	bit $d011
	bmi *-3

	lda #%00011011		// Set y-scroll to normal position (because we FLD later on..)
	sta $d011

	jsr CalcNumLines		 	// Call sinus substitute routine

	lda #$30 			// Wait for position where we want LineCrunch to start
	cmp $d012
	bne *-3

	ldx NumCrunchLines
	beq loop1 			// Skip if we want 0 crunched lines

loop2:
	lda $d012			// Wait for beginning of next line
	cmp $d012
	bpl *-3

	clc 				// Do one line of FLD
	lda $d011
	adc #1
	and #7
	ora #$18
	sta $d011


	dex
	bne loop2			// branch if not 0
	jmp loop1			// next frame


CalcNumLines:
	lda #0
	bpl *+4
	eor #%11111111

	lsr
	
	sta NumCrunchLines
	inc CalcNumLines + 1

	rts

NumCrunchLines:
	.byte 0