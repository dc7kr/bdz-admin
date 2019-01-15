$ ->
  $("a[data-remote]").on "ajax:success", (e, data, status, xhr) ->
    if data.type == 'data' 
      console.log("Data!")
    else if data.status=='ok' 
      target = $('#row'+data.entityId)

      if data.op == 'delete' 
        target.fadeOut(500, -> target.remove())
    else 
      console.log("Event:")
      console.log(e) 
      console.log(status) 
      console.log(xhr)
