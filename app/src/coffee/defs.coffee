# chess pieces
# notation: 
# wK = white King, bK = black King

PIECES =
  EMPTY : 0
  wP : 1
  wN : 2
  wB : 3
  wR : 4
  wQ : 5
  wK : 6
  bP : 7
  bN : 8
  bB : 9
  bR : 10
  bQ : 11
  bK : 12

BOARD_SQUARE_NUMBER = 120

FILES =
  FILE_A:0
  FILE_B:1
  FILE_C:2
  FILE_D:3
  FILE_E:4
  FILE_F:5
  FILE_G:6
  FILE_H:7
  FILE_NONE:8

RANKS =
  RANK_1:0
  RANK_2:1
  RANK_3:2
  RANK_4:3
  RANK_5:4
  RANK_6:5
  RANK_7:6
  RANK_8:7
  RANK_NONE:8

COLOURS =
  WHITE:0
  BLACK:1
  BOTH:2

CASTLEBIT =
  WKCA:1
  WQCA:2
  BKCA:4
  BQCA:8


SQUARES =
  A1:21
  A8:91
  B1:22
  B8:92
  C1:23
  C8:93
  D1:24
  D8:94
  E1:25
  E8:95
  F1:26
  F8:96
  G1:27
  G8:97
  H1:28
  H8:98
  NO_SQ:99
  OFFBOARD:100

BOOL =
  FALSE:0
  TRUE:1



MAXGAMEMOVE = 2048 # list of moves board has in given position
MAXPOSITIONMOVES = 256
MAXDEPTH = 64 # max depth the engine will search 



FILESBOARD = new Array(BOARD_SQUARE_NUMBER)
RANKSBOARD = new Array(BOARD_SQUARE_NUMBER)

PieceBig = [
  BOOL.FALSE
  BOOL.FALSE
  BOOL.TRUE
  BOOL.TRUE
  BOOL.TRUE
  BOOL.TRUE
  BOOL.TRUE
  BOOL.FALSE
  BOOL.TRUE
  BOOL.TRUE
  BOOL.TRUE
  BOOL.TRUE
  BOOL.TRUE
]
PieceMaj = [
  BOOL.FALSE
  BOOL.FALSE
  BOOL.FALSE
  BOOL.FALSE
  BOOL.TRUE
  BOOL.TRUE
  BOOL.TRUE
  BOOL.FALSE
  BOOL.FALSE
  BOOL.FALSE
  BOOL.TRUE
  BOOL.TRUE
  BOOL.TRUE
]
PieceMin = [
  BOOL.FALSE
  BOOL.FALSE
  BOOL.TRUE
  BOOL.TRUE
  BOOL.FALSE
  BOOL.FALSE
  BOOL.FALSE
  BOOL.FALSE
  BOOL.TRUE
  BOOL.TRUE
  BOOL.FALSE
  BOOL.FALSE
  BOOL.FALSE
]
PieceVal = [
  0
  100
  325
  325
  550
  1000
  50000
  100
  325
  325
  550
  1000
  50000
]
PieceCol = [
  COLOURS.BOTH
  COLOURS.WHITE
  COLOURS.WHITE
  COLOURS.WHITE
  COLOURS.WHITE
  COLOURS.WHITE
  COLOURS.WHITE
  COLOURS.BLACK
  COLOURS.BLACK
  COLOURS.BLACK
  COLOURS.BLACK
  COLOURS.BLACK
  COLOURS.BLACK
]
PiecePawn = [
  BOOL.FALSE
  BOOL.TRUE
  BOOL.FALSE
  BOOL.FALSE
  BOOL.FALSE
  BOOL.FALSE
  BOOL.FALSE
  BOOL.TRUE
  BOOL.FALSE
  BOOL.FALSE
  BOOL.FALSE
  BOOL.FALSE
  BOOL.FALSE
]
PieceKnight = [
  BOOL.FALSE
  BOOL.FALSE
  BOOL.TRUE
  BOOL.FALSE
  BOOL.FALSE
  BOOL.FALSE
  BOOL.FALSE
  BOOL.FALSE
  BOOL.TRUE
  BOOL.FALSE
  BOOL.FALSE
  BOOL.FALSE
  BOOL.FALSE
]
PieceKing = [
  BOOL.FALSE
  BOOL.FALSE
  BOOL.FALSE
  BOOL.FALSE
  BOOL.FALSE
  BOOL.FALSE
  BOOL.TRUE
  BOOL.FALSE
  BOOL.FALSE
  BOOL.FALSE
  BOOL.FALSE
  BOOL.FALSE
  BOOL.TRUE
]
PieceRookQueen = [
  BOOL.FALSE
  BOOL.FALSE
  BOOL.FALSE
  BOOL.FALSE
  BOOL.TRUE
  BOOL.TRUE
  BOOL.FALSE
  BOOL.FALSE
  BOOL.FALSE
  BOOL.FALSE
  BOOL.TRUE
  BOOL.TRUE
  BOOL.FALSE
]
PieceBishopQueen = [
  BOOL.FALSE
  BOOL.FALSE
  BOOL.FALSE
  BOOL.TRUE
  BOOL.FALSE
  BOOL.TRUE
  BOOL.FALSE
  BOOL.FALSE
  BOOL.FALSE
  BOOL.TRUE
  BOOL.FALSE
  BOOL.TRUE
  BOOL.FALSE
]
PieceSlides = [
  BOOL.FALSE
  BOOL.FALSE
  BOOL.FALSE
  BOOL.TRUE
  BOOL.TRUE
  BOOL.TRUE
  BOOL.FALSE
  BOOL.FALSE
  BOOL.FALSE
  BOOL.TRUE
  BOOL.TRUE
  BOOL.TRUE
  BOOL.FALSE
]

# hashing variables
PieceKeys = new Array(14*120)
SideKey = 0
CastleKeys = new Array(16)

# lookup tables between squre board notations
Sq120tosq64 = new Array(BOARD_SQUARE_NUMBER)
Sq64tosq120 = new Array(64)


FR2SQ = (f, r) ->
  (21+f) + (r*10)

RAND_32 = ->
  (Math.floor((Math.random()*255)+1) << 23) | (Math.floor((Math.random()*255)+1) << 16) | (Math.floor((Math.random()*255) + 1) << 8) | Math.floor((Math.random()*255)+1)

SQ64 = (piece) ->
  Sq120tosq64[piece]

SQ120 = (piece) ->
  Sq64tosq120[piece]
