$ ->
  $("a[data-remote]").on "ajax:success", (e, data, status, xhr) ->
    if data. type == 'data' 
    else if data.status=='ok' 
      target = $('#row'+data.entityId)
      target.fadeOut(300, -> $(this).remove() )
    else 
      alert "Something went wrong."
    
