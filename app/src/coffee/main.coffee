$ ->
  init()
  console.log("Main Init Called")


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
      sq = FR2SQ file,rank
      FILESBOARD[sq] = file
      RANKSBOARD[sq] = rank



init = ->
  
  console.log("initializing...")
  initFilesRanksBRD()
