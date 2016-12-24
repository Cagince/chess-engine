###
#
# 0000 0000 0000 0000 0000 0000 0000
# 
# 0000 0000 0000 0000 0000 0111 1111 ->  from SQ 0x7F
# 0000 0000 0000 0011 1111 1000 0000 ->  to SQ >> 7 , 0x7F
# 0000 0000 0011 1100 0000 0000 0000 ->  Captured >> 14 , 0xF
# 0000 0000 0100 0000 0000 0000 0000 ->  EP 0x40000
# 0000 0000 1000 0000 0000 0000 0000 ->  Pawn start 0x8000
# 0000 1111 1000 0000 0000 0000 0000 ->  Promoted piece >> 20 , 0xF
# 0001 0000 1000 0000 0000 0000 0000 ->  Castle 0x1000000
#
###

Move = (from, to , captured, promoted, flag) ->
  from | to << 7 | captured << 14 | promoted << 20 | flag


###
# GameBoard.moveListStart[] -> index for the first move at a given ply
# GameBoard.moveList[index] =  new Array(MAXDEPTH * MAXPOSITIONMOVES)
###
GenerateMoves = ->

  console.log "generatin moves..."
  
  GameBoard.moveListStart[GameBoard.ply + 1] = GameBoard.moveListStart[GameBoard.ply]
  
  if GameBoard.side == COLOURS.WHITE

    pieceType = PIECES.wP

    for pceNum in [0..GameBoard.pceNum[pceType]
      sq = GameBoard.pieceListArray[PIECEINDEX(pceType,pceNum)]
      
      # non-capturing moves
      if GameBoard.pieces[sq+10] == PIECES.EMPTY
        # add pawn move
        if RANKS[sq] == RANKS.RANK_2 && GameBoard.pieceListArray[sq+ 20] == PIECES.EMPTY
          # add quite move here 
      
      if SQOFFBOARD(sq+9) == BOOL.FALSE && PieceCol[GameBoard.pieceListArray[sq+9]] == COLOURS.BLACK
        # add pawn capture move
    
      if SQOFFBOARD(sq+11) == BOOL.FALSE && PieceCol[GameBoard.pieceListArray[sq+11]] == COLOURS.BLACK
        # add pawn capture move
      

      if GameBoard.enPasant != SQUARES.NOSQ
        
        if sq+9 == GameBoard.enPasant
          # add enpasant move

        if sq+11 == GameBoard.enPasant
          # add enpasant move
    

    if GameBoard.castlingPermission & CASTLEBIT.WKCA
      # add quiet move1
      if (GameBoard.pieceListArray[SQUARES.F1] == PIECES.EMPTY) && (GameBoard.pieceListArray[SQUARES.G1] == PIECES.EMPTY)
        # add quiet move2
        if SquareAttacked(SQUARES.F1, COLOURS.BLACK) == BOOL.FALSE && SquareAttacked(SQUARES.E1, COLOURS.BLACK) == BOOL.FALSE
          # add quiet move3

    if GameBoard.castlingPermission & CASTLEBIT.WQCA
      # add quiet move4

      if GameBoard.pieceListArray[SQUARES.D1] == PIECES.EMPTY && GameBoard.pieceListArray[SQUARES.C1] == PIECES.EMPTY && GameBoard.pieceListArray[SQUARES.B1] == PIECES.EMPTY
        # add quiet move5

        if (SquareAttacked(SQUARES.D1, COLOURS.BLACK) == BOOL.FALSE) && (SquareAttacked(SQUARES.E1,COLOURS.BLACK) == BOOL.FALSE)
          console.log "quiet move"

          # add quiet move6
          
    



  else

    pieceType = PIECES.bP
    
    for pceNum in [0..GameBoard.pceNum[pceType]
      sq = GameBoard.pieceListArray[PIECEINDEX(pceType,pceNum)]
      
      # non-capturing moves
      if GameBoard.pieces[sq-10] == PIECES.EMPTY
        # add pawn move
        if RANKS[sq] == RANKS.RANK_7 && GameBoard.pieceListArray[sq- 20] == PIECES.EMPTY
          # add quite move here 
      
      if SQOFFBOARD(sq-9) == BOOL.FALSE && PieceCol[GameBoard.pieceListArray[sq-9]] == COLOURS.WHITE
        # add pawn capture move
    
      if SQOFFBOARD(sq-11) == BOOL.FALSE && PieceCol[GameBoard.pieceListArray[sq-11]] == COLOURS.WHITE
        # add pawn capture move
      

      if GameBoard.enPasant != SQUARES.NOSQ
        
        if sq-9 == GameBoard.enPasant
          # add enpasant move

        if sq-11 == GameBoard.enPasant
          # add enpasant move
   
    if GameBoard.castlingPermission & CASTLEBIT.BKCA
      if GameBoard.pieceListArray[SQUARES.F8] == PIECES.EMPTY && GameBoard.pieceListArray[SQUARES.G8] == PIECES.EMPTY
        if SquareAttacked(SQUARES.F8, COLOURS.WHITE) == BOOL.FALSE && SquareAttacked(SQUARES.E8, COLOURS.WHITE) == BOOL.FALSE
          # add quiet move

    if GameBoard.castlingPermission & CASTLEBIT.BQCA
      if GameBoard.pieceListArray[SQUARES.D8] == PIECES.EMPTY && GameBoard.pieceListArray[SQUARES.C8] == PIECES.EMPTY && GameBoard.pieceListArray[SQUARES.B8] == PIECES.EMPTY
        if SquareAttacked(SQUARES.D8, COLOURS.WHITE) == BOOL.FALSE && SquareAttacked(SQUARES.E8, COLOURS.WHITE) == BOOL.FALSE
          # add quiet move


  







