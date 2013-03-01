// Imports
.import source "vars.asm"
.import source "engine/screen.asm"

.pc = $0801 "Basic Upstart"
:BasicUpstart(start)

.pc = $0900 "51 Pegasus"
start:
	
	:SetVICBank3()
	:SetScreenAndCharLocation(SCR_BUFFER, CHAR_SET)
	:ClearScreen(SCR_BUFFER, 0)
	:SetMultiColorMode()

	// set background and border to black
	lda #BLUE
	sta $d021
	sta $d020
	
	


loop:
	jmp loop