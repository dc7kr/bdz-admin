# Workaround for displaying selected file
$(document).on 'ready turbolinks:load', ->
  $('.custom-file-input').change (event) ->
    $("label.custom-file-label[for='"+event.target.id+"']").text @value
    return
  return
