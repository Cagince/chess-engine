$ ->
  init()
  console.log("Initialization complete")


initFilesRanksBRD = ->
  
  # set offboards to offboard nums
  index = 0
  while index < BOARD_SQUARE_NUMBER
    FILESBOARD[index] = SQUARES.OFFBOARD
    RANKSBOARD[index] = SQUARES.OFFBOARD
    index++



  # set file and rank values dependent
  # on their square
  for rank in [RANKS.RANK_1..RANKS.RANK_8]
    for file in [FILES.FILE_A..FILES.FILE_H]
      sq = FR2SQ(file,rank)
      FILESBOARD[sq] = file
      RANKSBOARD[sq] = rank
  
  console.log "files ranks and board has been initialized"
  

initHashKeys = ->
  for i in [0..14*120]
    PieceKeys[i] = RAND_32()
  
  SideKey = RAND_32()

  for i in [0..16]
    CastleKeys[i] = RAND_32()
 
  console.log "Hash Keys has been initialized"

initLookupTables = ->
  
  # fill array with nonvalid numbers
  Sq120tosq64.fill(65)
  Sq64tosq120.fill(120)
  
  sq64 = 0

  for rank in [RANKS.RANK_1..RANKS.RANK_8]
    for file in [FILES.FILE_A..FILES.FILE_H]
      sq = FR2SQ(file,rank)
      Sq64tosq120[sq64] = sq
      Sq120tosq64[sq] = sq64
      sq64++
  console.log "Lookup Tables hasbeen initialized"


init = ->
  
  console.log("initializing...")
  initFilesRanksBRD()
  initHashKeys()
  initLookupTables()
