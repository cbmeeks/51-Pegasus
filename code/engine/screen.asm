/*
	Character memory
	$D018 = %xxxx000x -> charmem is at $0000
	$D018 = %xxxx001x -> charmem is at $0800
	$D018 = %xxxx010x -> charmem is at $1000
	$D018 = %xxxx011x -> charmem is at $1800
	$D018 = %xxxx100x -> charmem is at $2000
	$D018 = %xxxx101x -> charmem is at $2800
	$D018 = %xxxx110x -> charmem is at $3000
	$D018 = %xxxx111x -> charmem is at $3800
	
	Screen memory
	$D018 = %0000xxxx -> screenmem is at $0000
	$D018 = %0001xxxx -> screenmem is at $0400
	$D018 = %0010xxxx -> screenmem is at $0800
	$D018 = %0011xxxx -> screenmem is at $0c00
	$D018 = %0100xxxx -> screenmem is at $1000
	$D018 = %0101xxxx -> screenmem is at $1400
	$D018 = %0110xxxx -> screenmem is at $1800
	$D018 = %0111xxxx -> screenmem is at $1c00
	$D018 = %1000xxxx -> screenmem is at $2000
	$D018 = %1001xxxx -> screenmem is at $2400
	$D018 = %1010xxxx -> screenmem is at $2800
	$D018 = %1011xxxx -> screenmem is at $2c00
	$D018 = %1100xxxx -> screenmem is at $3000
	$D018 = %1101xxxx -> screenmem is at $3400
	$D018 = %1110xxxx -> screenmem is at $3800
	$D018 = %1111xxxx -> screenmem is at $3c00
*/
.macro SetScreenAndCharLocation(screen, charset) {
	lda	#[[screen & $3FFF] / 64] | [[charset & $3FFF] / 1024]
	sta	$D018
}

.macro ClearScreen(screen, clearByte) {
	lda #clearByte
	ldx #0
!loop:
	sta screen, x
	sta screen + $100, x
	sta screen + $200, x
	sta screen + $300, x
	inx
	bne !loop-
}

.macro ClearColorRam(clearByte) {
	lda #clearByte
	ldx #0
!loop:
	sta $D800, x
	sta $D800 + $100, x
	sta $D800 + $200, x
	sta $D800 + $300, x
	inx
	bne !loop-
}

// $DD00 = %xxxxxx11 -> bank0: $0000-$3fff
// $DD00 = %xxxxxx10 -> bank1: $4000-$7fff
// $DD00 = %xxxxxx01 -> bank2: $8000-$bfff
// $DD00 = %xxxxxx00 -> bank3: $c000-$ffff
.macro SetVICBank0() {
	lda $DD00
	and #%11111100
	ora #%00000011
	sta $DD00
}

.macro SetVICBank1() {
	lda $DD00
	and #%11111100
	ora #%00000010
	sta $DD00
}

.macro SetVICBank2() {
	lda $DD00
	and #%11111100
	ora #%00000001
	sta $DD00
}

.macro SetVICBank3() {
	lda $DD00
	and #%11111100
	ora #%00000000
	sta $DD00
}

.macro SetBorderColor(color) {
	lda #color
	sta $d020
}

.macro SetBackgroundColor(color) {
	lda #color
	sta $d021
}

.macro SetMultiColor1(color) {
	lda #color
	sta $d022
}

.macro SetMultiColor2(color) {
	lda #color
	sta $d023
}

.macro SetMultiColorMode() {
	lda	$d016
	ora	#16
	sta	$d016	
}

.macro SetScrollMode() {
	lda $D016
	eor #%00001000
	sta $D016
}
