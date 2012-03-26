# iOS4 does not support position: fixed.
exports.ENABLE_GROWL = not navigator.userAgent?.match(/CPU (iPhone )?OS 4_/)

# Handles the "You got a high score" notification message.
class Growl
  # Expects a single argument; the notifier DOM element.
  constructor: (@el, @height) ->
    @$el = $ @el

    # If growl is not supported by the current browser, we ensure that the
    # growl element is completely removed from the DOM.
    @$el.remove() unless exports.ENABLE_GROWL

  show: =>
    @$el.stop().animate bottom: '0px', 350, 'easeInOutCubic'

  hide: =>
    @$el.stop().animate bottom: @height, 350, 'easeInOutCubic'

# Shown on the scene page whenever the user has a high score.
class exports.HighScoreGrowl extends Growl
  constructor: (el) -> super(el, '-38px')

# Shown whenever an XHR request is pending.
class exports.LoadingGrowl extends Growl
  # Loading growl has no top border, making it 1px shorter.
  constructor: (el) -> super(el, '-37px')
