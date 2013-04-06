startdrawmap:						// (bytes : cycles) * = add 1 cycle if page boundary crossed
	lda #0							// (2 : 2)	Reset Row/Col
	sta COL_NUMBER
	sta ROW_NUMBER
	ldx #0							// (2 : 2)
drawmap:
!loop:
	ldy #0							// (2 : 2)	current buffer offset (char position = upper left char)
	lax (MAP_PTR_LO), y   			// (2 : 5*)	X now contains tile number (from Map Data)	$AF

	lda TileCharLookupA, x			// (2 : 4)	A now contains upper left char from tile
	sta (CUR_BUFFER_PTR_LO), y		// (2 : 6)	draw upper-left of tile
	lda TileCharLookupB, x			// (2 : 4)	A now contains upper-right char from tile
	iny                 			// (1 : 2)	current buffer offset (char pos = upper left char + 1) Y = #01
	sta (CUR_BUFFER_PTR_LO), y		// (2 : 6)	draw upper-right char from tile
	lda TileCharLookupC, x 			// (2 : 4)	A now contains lower-left char from tile
	ldy #40                			// (2 : 2)	jump down next line in buffer (char pos = 2nd row, left side)
	sta (CUR_BUFFER_PTR_LO), y		// (2 : 6)	draw lower-left char from tile
	lda TileCharLookupD, x 			// (2 : 4)	A now contains lower-right char from tile
	iny								// (1 : 2)	current buffer offset (char pos = 2nd row, right side) Y = #41
	sta (CUR_BUFFER_PTR_LO), y		// (2 : 6)	draw lower-right char from tile

	clc                    			// (1 : 2)	clear the carry bit
	lda CUR_BUFFER_PTR_LO	   		// (2 : 3)	current drawing buffer
	adc #2				   			// (2 : 2)	add 2 to current buffer  (since our tiles are 2x2)
	sta CUR_BUFFER_PTR_LO			// (2 : 3)	update the current buffer pointer
	bcc *+4							// skip the next instruction if C is clear (didn't roll over)
	inc CUR_BUFFER_PTR_HI			// we rolled over so increase the HIGH byte (ie, $34FE + 2 = $3500)

	// inc MAP_PTR_LO					// move to the next map data position
	clc
	lda MAP_PTR_LO
	adc #1
	sta MAP_PTR_LO
	bcc *+4
	inc MAP_PTR_HI



	inc	COL_NUMBER					// move to the next column
	lda	COL_NUMBER					// load the column number
	cmp	#20							// have we reached the right side?
	bne	!loop-						// not yet...repeat loop
	lda	#0							// yes, now reset the column number
	sta	COL_NUMBER					// and store it.

!startnextrow:
	clc
	lda MAP_PTR_LO
	adc #20							// add 1/2 room width in tiles to drop down to next row
	sta MAP_PTR_LO
	bcc *+4
	inc MAP_PTR_HI


	clc
	lda	CUR_BUFFER_PTR_LO			// jump down to the next row
	adc	#40							// add 40 (jumps down a row)
	sta	CUR_BUFFER_PTR_LO			// update current buffer pointer
	bcc	*+4							// have we rolled over?
	inc	CUR_BUFFER_PTR_HI			// yes so increase the high byte
	inc	ROW_NUMBER					// increase the row number
	lda	ROW_NUMBER					// load current row number
	cmp	#10							// have we reached the bottom of the screen?
	bne	drawmap						// no, continue drawing the next row
	rts								// yes, return
