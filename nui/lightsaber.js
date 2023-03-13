$(document).ready(function(){
  var $debug = $("#debug");
  
  window.addEventListener('message', function(event){
    if ( event.data.display == true ) {
      $('.hud').fadeIn();
      $('body').show();
    }   
    else {
      $('.hud').fadeOut();
    }

    if ( event.data.incar == true ) {
      $("#car").fadeIn(750).css('bottom','39px');
    } 
    else {
      $('#car').css('bottom','-99px');
      $("#car").fadeOut(750);
    }
    if ( event.data.cinto == true ) {
      $('.cintoon').css('display', 'block');    
      $('.cintooff').css('display', 'none'); 
    }   
    else {
      $('.cintooff').css('display', 'block');
      $('.cintoon').css('display', 'none'); 
    }
  });
});