PIECEINDEX = (pce, pceNum) ->
  (pce* 10 + pceNum)

GameBoard = {}

GameBoard.pieces = new Array(BOARD_SQUARE_NUMBER)
GameBoard.side = COLOURS.WHITE
GameBoard.fiftyMove = 0 # fiftymove for withdraw

GameBoard.playHistory = 0 # play history
GameBoard.ply = 0 # half plays

###
# 0001 white king castling
# 0010 white queen castling
# 0100 black king castling
# 1000 black queen castling
# -----------------------------
# 1101 = 13 <- white cannot castle queen side
# Bitwise & to implement
# .............................
###
GameBoard.castlingPermission = 0 # Castling permission
GameBoard.enPasant = 0 # En Passant rule for pawns
GameBoard.material= new Array(2) # material of pieces


GameBoard.pieceAmount = new Array(13) # indexed by piece for each unique piece
GameBoard.pieceListArray = new Array(14*10)
GameBoard.positionKey = 0


GeneratePosKey = ->
  
  piece = PIECES.EMPTY
  finalKey = 0
  
  # iterate through all squares
  for sq in [0..BOARD_SQUARE_NUMBER]
    
    piece = GameBoard.pieces[sq]
    # xor square hash into finalkey if not empty and offboard  
    if piece != PIECES.EMPTY && piece != SQUARES.OFFBOARD
      finalKey ^= PieceKeys[(piece*120)+sq]
   
  # xor colour key if white 
  if GameBoard.side == COLOURS.WHITE
    finalkey ^= SideKey
  # xor en Passant key 
  if GameBoard.enPasant != SQUARES.NO_SQ
    finalKey ^= PieceKeys[GameBoard.enPasant]
  # xor castling Permission 
  finalKey ^= CastleKeys[GameBoard.castlingPermission]

  return finalKey
























