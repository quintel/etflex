$(document).ready(function(){
  setInterval(function(){animate_header();}, 3000);
});

function animate_header(){
  var number_of_props = $('.icon-prop').size();
  var random_index    = Math.floor(Math.random()*number_of_props);
  var selected_prop   = $('.icon-prop').eq(random_index);

  var to_be_hidden = selected_prop.find('.active');
  var to_be_shown  = selected_prop.find('.inactive').first();

  to_be_hidden.removeClass('active').addClass('inactive').fadeOut(2000);
  to_be_shown.removeClass('inactive').addClass('active').fadeIn(2000);
}