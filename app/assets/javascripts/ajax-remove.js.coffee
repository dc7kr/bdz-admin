$ ->
  $("a[data-remote]").on "ajax:success", (e, data, status, xhr) ->
    alert "The URL was deleted."
