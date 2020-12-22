{ OverlayMessageView } = require('views/overlay_message')

class exports.QuizRequestView extends OverlayMessageView
  prependTo: (element) ->
    super

    content = @$('.overlay-message')
    content.addClass('quiz')

    this
