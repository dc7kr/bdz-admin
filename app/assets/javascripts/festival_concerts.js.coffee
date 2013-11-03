# Place all the behaviors and hooks related to the matching controller here.
# All this logic will automatically be available in application.js.
# You can use CoffeeScript in this file: http://jashkenas.github.com/coffee-script/
$ ->
  $('#festival_concert_event_time').datetimepicker({stepMinute:15, dateFormat: 'dd.mm.yy'});
