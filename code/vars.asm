//***************************************************************************
//	Generic Variables
//***************************************************************************
.var charname = "../chars/chars.raw"


//***************************************************************************
//	Addresses
//***************************************************************************
.var CHAR_SET	=	$C000
.var SCR_BUFFER	=	$C800
.var DBL_BUFFER =	$CC00


//***************************************************************************
//	Load Chars
//***************************************************************************
.pc = CHAR_SET "Chars"
.var chars = LoadBinary(charname)
.fill chars.getSize(), chars.get(i)