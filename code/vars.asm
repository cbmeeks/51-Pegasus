//***************************************************************************
//	Generic Variables
//***************************************************************************
.var charname	=	"../chars/chars.raw"
.var room001	=	"../rooms/001.map"

.var tilesname 	=	"../chars/tiles.raw"
.var num_tiles 	=	64

//***************************************************************************
//	Zero Page
//***************************************************************************
.var ROW_NUMBER			=	$10
.var COL_NUMBER			=	$11

.var MAP_PTR_LO			=	$12
.var MAP_PTR_HI			=	$13

.var CUR_BUFFER_PTR_LO	=	$14		// pointer to current buffer
.var CUR_BUFFER_PTR_HI	=	$15		// (ie, either SCR or DBL)
//***************************************************************************
//	Addresses
//***************************************************************************
.var CHAR_SET	= $C000
.var SCR_BUFFER	= $C800
.var DBL_BUFFER = $CC00
.var MAP_BUFFER	= $8800

//***************************************************************************
//	Load Chars
//***************************************************************************
.pc = CHAR_SET "Chars"
.var chars = LoadBinary(charname)
.fill chars.getSize(), chars.get(i)

//***************************************************************************
//	Tiles
//***************************************************************************
.pc = * "Tiles"
.var tiles = LoadBinary(tilesname)
.fill tiles.getSize(), tiles.get(i)

//***************************************************************************
//	Load Maps (Rooms)
//***************************************************************************
.pc = MAP_BUFFER "Maps"
.var maps = LoadBinary(room001)
.fill maps.getSize(), maps.get(i)

//***************************************************************************
//	Lookup Tables 
//	Tiles are in:
//		AB
//		CD
//	format.
//***************************************************************************
.pc = * "Tile Char Lookups"
TileCharLookupA: 	.for(var i=0; i < num_tiles; i++) .byte i * 4
TileCharLookupB: 	.for(var i=0; i < num_tiles; i++) .byte [i * 4] + 1
TileCharLookupC: 	.for(var i=0; i < num_tiles; i++) .byte [i * 4] + 2
TileCharLookupD: 	.for(var i=0; i < num_tiles; i++) .byte [i * 4] + 3
