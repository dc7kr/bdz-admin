
$('#<%= dom_id(@festival_piece) %>')
  .fadeOut ->
    $(this).remove()
