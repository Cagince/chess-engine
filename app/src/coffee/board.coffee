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
# Print game board to console
###
PrintBoard = ->
  console.log( "printing board...")


  console.log("\nGame Board: \n")
  for rank in [RANKS.RANK_8..RANKS.RANK_1]
    line = RankChar[rank]+ "|"
    for file in [FILES.FILE_A..FILES.FILE_H]
      sq = FR2SQ(file,rank)
      piece = GameBoard.pieces[sq]
      line +=  " " + PceChar[piece] + " "
    console.log(line)

  console.log("------------------------------ ")
  line = "  "
  for file in [FILES.FILE_A..FILES.FILE_H]
    line += " " + FileChar[file] + " "
  
  # enpas and side
  console.log(line)
  console.log("side: " + SideChar[GameBoard.side])
  console.log("enPas: " + GameBoard.enPasant)
  line = ""
  
  # castling permissions
  line += "K" if (GameBoard.castlingPermission && CASTLEBIT.WKCA)
  line += "Q" if (GameBoard.castlingPermission && CASTLEBIT.WQCA)
  line += "k" if (GameBoard.castlingPermission && CASTLEBIT.BKCA)
  line += "q" if (GameBoard.castlingPermission && CASTLEBIT.BQCA)
  
  # 
  console.log("castle: " + line)
  console.log("Key: " + GameBoard.posKey.toString(16))






###
# Generating Position keys for
# later usage.
# helps us getting aware of our game "input"
# and add-remove pieces by xor'ing the final key
###
GeneratePosKey = ->
  console.log("Generating Position Key")

  piece = PIECES.EMPTY
  finalKey = 0
  
  # iterate through all squares
  for sq in [0..BOARD_SQUARE_NUMBER]
    
    piece = GameBoard.pieces[sq]
    # xor square hash into finalKey if not empty and offboard  
    if piece != PIECES.EMPTY && piece != SQUARES.OFFBOARD
      finalKey ^= PieceKeys[(piece*120)+sq]
   
  # xor colour key if white 
  if GameBoard.side == COLOURS.WHITE
    finalKey ^= SideKey
  # xor en Passant key 
  if GameBoard.enPasant != SQUARES.NO_SQ
    finalKey ^= PieceKeys[GameBoard.enPasant]
  # xor castling Permission 
  finalKey ^= CastleKeys[GameBoard.castlingPermission]

  return finalKey


###
# Print piece list
###

PrintPieceLists = ->
  console.log "Printing piece Lists..."
  for piece in [PIECES.wP..PIECES.bK]
    for pceNum in [0..GameBoard.pieceAmount[piece]-1]
      console.log "piece : " + PceChar[piece] + " on " + PringSq( GameBoard.pieceListArray[PIECEINDEX(piece,pceNum)])









###
#
###
UpdateListMaterial = ->
  console.log("Updating List Material...")
  
  GameBoard.pieceListArray.fill(PIECES.EMPTY)
  GameBoard.material.fill(0)
  GameBoard.pieceAmount.fill(0)

  for i in [0..63]
    sq = SQ120(i)
    piece = GameBoard.pieces[sq]
    if piece != PIECES.EMPTY
      console.log("piece " + piece + " on " + sq)
      colour = PieceCol[piece]
      
      GameBoard.material[colour] += PieceVal[piece]

      GameBoard.pieceListArray[PIECEINDEX(piece,GameBoard.pieceAmount[piece])] = sq
      GameBoard.pieceAmount[piece]++
  
  PrintPieceLists()



###
# Reset the board
# clear all to 0 , offset etc.
###
ResetBoard = ->
  console.log("reseting Board")
  
  # clear board 
  GameBoard.pieces.fill(SQUARES.OFFBOARD)
  GameBoard.pieces[SQ120(i)] for i in [0..64]# not sureabout the not.
  
  GameBoard.side = COLOURS.BOTH
  GameBoard.enPasant = SQUARES.NO_SQ
  GameBoard.fiftymove = 0
  GameBoard.ply = 0
  GameBoard.playHistory = 0
  GameBoard.castlingPermission = 0
  GameBoard.positionKey = 0
  GameBoard.moveListStart[GameBoard.ply] = 0




###
# Method for parsing Forsyth–Edwards Notation String
# more info on FEN: https://en.wikipedia.org/wiki/Forsyth%E2%80%93Edwards_Notation
###
ParseFen = (fen) ->
 
  console.log("parsing FEN...")
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
    
    for i in [1..count]
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
    GameBoard.enPasant = FR2SQ(file,rank)
  

  GameBoard.posKey = GeneratePosKey()
  UpdateListMaterial()

###
# check if square is being attacked
#
###
SquareAttacked = (sq,side) ->
  
  # check if pawn is attacking
  if side == COLOURS.WHITE
    if GameBoard.pieces[sq-11] == PIECES.wP || GameBoard.pieces[sq-9] == PIECES.wP
      true
  else
    if GameBoard.pieces[sq+11] == PIECES.bP || GameBoard.pieces[sq+9] == PIECES.bP
      true
  
  for i in KnightDirections
    piece =  GameBoard.pieces[sq + i]
    return true if piece != SQUARES.OFFBOARD && PieceCol[piece] == side && PieceKnight[piece] == BOOL.TRUE

  for direction in RookDirections
    t_sq = sq + direction
    piece = GameBoard.pieces[t_sq]
    while piece != SQUARES.OFFBOARD
      if piece != PIECES.EMPTY && PieceRookQueen[piece] == BOOL.TRUE && PieceCol[piece] == side then true else break
      t_sq += direction
      piece = GameBoard.pieces[t_sq]

    
  for direction in BishopDirections
    t_sq = sq + direction
    piece = GameBoard.pieces[t_sq]
    while piece != SQUARES.OFFBOARD
      if piece != PIECES.EMPTY && PieceBishopQueen[piece] == BOOL.TRUE && PieceCol[piece] == side then true else break
      t_sq += direction
      piece = GameBoard.pieces[t_sq]

  for i in KingDirections
    piece =  GameBoard.pieces[sq + i]
    return true if piece != SQUARES.OFFBOARD && PieceCol[piece] == side && PieceKing[piece] == BOOL.TRUE

  BOOL.FALSE















