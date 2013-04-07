$('<%= escape_javascript(render(:partial => @festival_piece))%>')
  .appendTo('#festival_pieces')
  .hide()
  .fadeIn()

$('#new_festival_piece')[0].reset()
