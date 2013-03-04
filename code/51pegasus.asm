// Imports
.import source "vars.asm"
.import source "engine/screen.asm"
.import source "engine/map.asm"

.pc = $0801 "Basic Upstart"
:BasicUpstart(start)

.pc = $0900 "51 Pegasus"

start:	
	:SetVICBank3()
	:SetScreenAndCharLocation(SCR_BUFFER, CHAR_SET)
	:ClearScreen(SCR_BUFFER, 0)
	:ClearScreen(DBL_BUFFER, 0)

	:ClearColorRam(10)
	:SetBorderColor(BLACK)
	:SetBackgroundColor(BLACK)
	:SetMultiColor1(LIGHT_BLUE)
	:SetMultiColor2(BLUE)
	:SetMultiColorMode()

	lda #<MAP_BUFFER
	sta MAP_PTR_LO
	lda #>MAP_BUFFER
	sta MAP_PTR_HI

	lda #<SCR_BUFFER
	sta CUR_BUFFER_PTR_LO
	lda #>SCR_BUFFER
	sta CUR_BUFFER_PTR_HI

	jsr startdrawmap

loop:
	jmp loop
