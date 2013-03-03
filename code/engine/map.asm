startdrawmap:
	lda #0							// Reset Row/Col
	sta COL_NUMBER
	sta ROW_NUMBER
	ldx #0
drawmap:
!loop:
	ldy #0
	lax (MAP_PTR_LOW), y   			// X now contains tile number (from Map Data)	$AF

	lda TileCharLookupA, x			// A now contains upper left char from tile
	sta (CUR_BUFFER_PTR_LOW), y		// draw upper-left of tile
	lda TileCharLookupB, x			// A now contains upper-right char from tile
	ldy #1                 		
	sta (CUR_BUFFER_PTR_LOW), y		// draw upper-right char from tile
	lda TileCharLookupC, x 			// A now contains lower-left char from tile
	ldy #40                			// jump down to next line in screen buffer
	sta (CUR_BUFFER_PTR_LOW), y		// draw lower-left char from tile
	lda TileCharLookupD, x 			// A now contains lower-right char from tile
	ldy #41                		
	sta (CUR_BUFFER_PTR_LOW), y		// draw lower-right char from tile
	
	clc                    			// clear the carry bit
	lda CUR_BUFFER_PTR_LOW	   		// current drawing buffer
	adc #2				   			// add 2 to current buffer  (since our tiles are 2x2)
	sta CUR_BUFFER_PTR_LOW			// update the current buffer pointer
	bcc *+4							// skip the next instruction if C is clear (didn't roll over)
	inc CUR_BUFFER_PTR_HI			// we rolled over so increase the HIGH byte (ie, $34FE + 2 = $3500)

	clc
	inc MAP_PTR_LOW					// move to the next map data position
	bcc *+4
	inc MAP_PTR_HI


	inc	COL_NUMBER					// move to the next column
	lda	COL_NUMBER					// load the column number
	cmp	#20							// have we reached the right side?  
	bne	!loop-						// not yet...repeat loop
	lda	#0							// yes, now reset the column number
	sta	COL_NUMBER					// and store it.


	clc								// add ROOM_WIDTH and jump down next row in map 
	lda MAP_PTR_LOW
	adc #20
	sta MAP_PTR_LOW
	bcc !nextcharrow+
	inc MAP_PTR_HI
	clc								// clear carry

!nextcharrow:
	lda	CUR_BUFFER_PTR_LOW			// jump down to the next row
	adc	#40							// add 40 (jumps down a row)
	sta	CUR_BUFFER_PTR_LOW			// update current buffer pointer
	bcc	*+4							// have we rolled over?
	inc	CUR_BUFFER_PTR_HI			// yes so increase the high byte
	inc	ROW_NUMBER					// increase the row number
	lda	ROW_NUMBER					// load current row number
	cmp	#10							// have we reached the bottom of the screen?
	bne	drawmap						// no, continue drawing the next row
	rts								// yes, return
