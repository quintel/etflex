$(function() {
  $('.description .preview .button').each(function(id) {
    $(this).click(function() {
      $(this).parent().siblings('.full').show();
      $(this).parent().hide();
    });
  });
  $('.description .full .button').each(function(id) {
    $(this).click(function() {
      $(this).parent().siblings('.preview').show();
      $(this).parent().hide();
    });
  });
});
