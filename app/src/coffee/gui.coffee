$ ->
  $("#SetFen").click ->
    fenStr = $("#fenIn").val()
    ParseFen(fenStr)
    PrintBoard()
