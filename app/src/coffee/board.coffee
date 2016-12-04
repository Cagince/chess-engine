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



GameBoard.moveList =  new Array(MAXDEPTH * MAXPOSITIONMOVES)
GameBoard.moveScores = new Array(MAXDEPTH * MAXPOSITIONMOVES)
GameBoard.moveListStart = new Array(MAXDEPTH)





###
# Generating Position keys for
# later usage.
# helps us getting aware of our game "input"
# and add-remove pieces by xor'ing the final key
###
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






###
# Reset the board
# clear all to 0 , offset etc.
###
ResetBoard = ->
  
  # clear board 
  GameBoard.pieces.fill(SQUARES.OFFBOARD)
  Gameboard.pieceListArray.fill(PIECES.EMPTY)
  Gameboard.material.fill(0)
  Gameboard.pieceAmount.fill(0)
  Gameboard.pieces[SQ120(i)] for i in [0..64]# not sureabout the not.
  
  Gameboard.side = COLOURS.BOTH
  Gameboard.enPasant = SQUARES.NO_SQ
  Gameboard.fiftymove = 0
  Gameboard.ply = 0
  Gameboard.playHistory = 0
  Gameboard.castlingPermission = 0
  Gameboard.positionKey = 0
  Gameboard.moveListStart[Gameboard.ply] = 0




###
# Method for parsing Forsyth–Edwards Notation String
# more info on FEN: https://en.wikipedia.org/wiki/Forsyth%E2%80%93Edwards_Notation
###
PaeseFedn = (fen) ->
  
  ResetBoard()

  fenCnt = 0
  sq120 = 0
  i = 0
  count = 0
  piece = 0
  file = FILES.FILE_A
  rank = RANKS.RANK_8
  
  while ((rank >= RANKS.RANK_1) && fenCnt < fen.length)
    count = 1

    switch fen[fenCnt]
      when 'p' then piece = PIECES.bP
      when 'r' then piece = PIECES.bR
      when 'n' then piece = PIECES.bN
      when 'b' then piece = PIECES.bB
      when 'k' then piece = PIECES.bK
      when 'q' then piece = PIECES.bQ
      when 'P' then piece = PIECES.wP
      when 'R' then piece = PIECES.wR
      when 'N' then piece = PIECES.wN
      when 'B' then piece = PIECES.wB
      when 'K' then piece = PIECES.wK
      when 'Q' then piece = PIECES.wQ
      when '1','2','3','4','5','6','7','8'
        piece = PIECES.EMPTY
        count = fen[fenCnt].charCodeAt() - '0'.charCodeAt()
      when '/', ' '
        rank--
        file = FILES.FILE_A
        fenCnt++
        continue
      else
        alert "not a valid FEN"

    for i in [0..count]
      sq120 = FR2SQ(file,rank)
      GameBoard.pieces[sq120] = piece
      file++
  
    fenCnt++
  
  
  # whose turn is it
  GameBoard.side = if (fen[fenCnt] == 'w') then  COLOURS.WHITE else COLOURS.BLACK
  fenCnt += 2
  

  # castling permissions
  for i in [0..4]
    if fen[fenCnt] == ' '
      break
    switch fen[fenCnt]
      when 'K' then GameBoard.castlingPermission |= CASTLEBIT.WKCA
      when 'Q' then GameBoard.castlingPermission |= CASTLEBIT.WQCA
      when 'k' then GameBoard.castlingPermission |= CASTLEBIT.BKCA
      when 'q' then GameBoard.castlingPermission |= CASTLEBIT.BQCA
      else break
    fenCnt++
  fenCnt++

  # en Pasant squares.
  if fen[fenCnt] != '-'
    file = fen[fenCnt].charCodeAt() - 'a'.charCodeAt()
    rank = fen[fenCnt + 1].charCodeAt() - '1'.charCodeAt()
    console.log "fen[fenCnt]: " + fen[fenCnt], " File: " + file + " Rank: " + rank
    GameBoard.enPasant = FR2SQ(rank,file)
  

  Gameboard.posKey = GeneratePosKey()
























