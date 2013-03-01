// Imports
.import source "vars.asm"
.import source "engine/screen.asm"

.pc = $0801 "Basic Upstart"
:BasicUpstart(start)

.pc = $0900 "51 Pegasus"
start:
	
	:SetVICBank3()
	:SetScreenAndCharLocation(SCR_BUFFER, CHAR_SET)
	:ClearScreen(SCR_BUFFER, 10)
	:ClearScreen(DBL_BUFFER, 1)

	:ClearColorRam(10)
	:SetBorderColor(BLACK)
	:SetBackgroundColor(BLACK)
	:SetMultiColor1(LIGHT_BLUE)
	:SetMultiColor2(BLUE)
	:SetMultiColorMode()	

	


loop:
	jmp loop