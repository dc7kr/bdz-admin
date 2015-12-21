$(function() {
  $('.datePicker').datepicker({ dateFormat: 'yy-mm-dd' });
  $('input.ui-datepicker').datepicker({ dateFormat: 'yy-mm-dd' });
  $.ajaxSetup({ dataType: 'json' });

  $('.dateTimePicker').datetimepicker();
  $('.timePicker').timepicker();

  $('a[data-popup]').on('click', function(e) { window.open($(this).attr('href')); e.preventDefault(); });
});

var fade_flash = function() {
    $("#flash_notice").delay(2000).fadeOut(500);
    $("#flash_alert").delay(2000).fadeOut(500);
    $("#flash_error").delay(2000).fadeOut(500);
}
fade_flash();

var show_ajax_message = function(msg, type) {
    $("#flash-message").html('<div class="message '+type+'" id="flash_'+type+'"><p>BLABLA'+msg+'</p></div>');
    fade_flash();
}

$(document).ajaxComplete(function(event,xhr,settings)  {
    msg = xhr.getResponseHeader('X-Message');
    type = xhr.getResponseHeader('X-Message-Type');

    if (msg != null) {
      show_ajax_message(msg, type);
    }
}
);

var counter=0;
var drawable;
var maxIdx=0;

function startTimer() {

  var nr = random(maxIdx);
  $('.win_nr').text(drawable[nr]);
  setTimeout(stopTimer,100);
}

function stopTimer() {
  counter--;
  if (counter >0) {
  startTimer();
  } else {
    var nr = $('.win_nr').text();
    retrieve_details(nr);
  }
}

function retrieve_details(nr) {
  $.getJSON( "https://"+window.location.host+"/competition_entries/"+nr+"/winner.json", function( data ) {
  $('#winner').text(data.first_name+" "+data.last_name);
  $('#winner').fadeIn(1000);
  
});
}


function random(max) {

  return Math.floor(Math.random() * max);
}

function startZiehung() {
  $.getJSON("https://"+window.location.host+"/competition_entries/drawable.json", function (data) {
    drawable = data;
    maxIdx=drawable.length;
    counter=50;
    $('#winner').fadeOut();
    startTimer();
  });
}

$(document).on('change', '.btn-file :file', function() {
  var input = $(this),
      numFiles = input.get(0).files ? input.get(0).files.length : 1,
      label = input.val().replace(/\\/g, '/').replace(/.*\//, '');
  input.trigger('fileselect', [numFiles, label]);
});

$(document).ready( function() {
    $('.btn-file :file').on('fileselect', function(event, numFiles, label) {
        
        var input = $(this).parents('.input-group').find(':text'),
            log = numFiles > 1 ? numFiles + ' files selected' : label;
        
        if( input.length ) {
            input.val(log);
        } else {
            if( log ) alert(log);
        }
        
    });
});
