startdrawmap:
	lda #0						// Reset Row/Col
	sta ColumnNumber
	sta RowNumber
	ldx #0
drawmap:
!loop:
	ldy #0
	lax (MAP_PTRL), y	   		// X now contains tile number (from Map Data)	$AF

	lda TileCharLookupA, x		// A now contains upper left char from tile
	sta (CURBUFFER_PTRL), y		// draw upper-left of tile
	lda TileCharLookupB, x		// A now contains upper-right char from tile
	ldy #1                 		
	sta (CURBUFFER_PTRL), y		// draw upper-right char from tile
	lda TileCharLookupC, x 		// A now contains lower-left char from tile
	ldy #40                		// jump down to next line in screen buffer
	sta (CURBUFFER_PTRL), y		// draw lower-left char from tile
	lda TileCharLookupD, x 		// A now contains lower-right char from tile
	ldy #41                		
	sta (CURBUFFER_PTRL), y		// draw lower-right char from tile
	
	clc                    		// clear the carry bit
	lda CURBUFFER_PTRL	   		// screen buffer
	adc #2				   		// add 2 to screen buffer  (since our tiles are 2x2)
	sta CURBUFFER_PTRL			// update the screen buffer pointer
	bcc *+4						// skip the next instruction if C is clear (didn't roll over)
	inc CURBUFFER_PTRH			// we rolled over so increase the HIGH byte (ie, $34FE + 2 = $3500)
	inc MAP_PTRL				// move to the next map data position
	inc	ColumnNumber			// move to the next column
	lda	ColumnNumber			// load the column number
	cmp	#20						// have we reached the right side?  
	bne	!loop-					// not yet...repeat loop
	lda	#0						// yes, now reset the column number
	sta	ColumnNumber			// and store it.
	clc							// clear carry
	lda	CURBUFFER_PTRL			// jump down to the next row
	adc	#40						// add 40 (jumps down a row)
	sta	CURBUFFER_PTRL			// update current buffer pointer
	bcc	*+4						// have we rolled over?
	inc	CURBUFFER_PTRH			// yes so increase the high byte
	inc	RowNumber				// increase the row number
	lda	RowNumber				// load current row number
	cmp	#12						// have we reached the bottom of the screen?
	bne	drawmap					// no, continue drawing the next row
	rts							// yes, return
