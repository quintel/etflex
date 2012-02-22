message = require 'templates/legacy_browser'

# Displays a message to the user informing them that their choice of browser
# is... less than optimal.
#
# It allows the user to dismiss the message so that they may opt to continue
# anyway, setting a cookie so that the message isn't displayed on repeat
# visits (or render() calls, for that matter).
#
class exports.LegacyBrowser extends Backbone.View
  className: 'fullscreen-message'

  events:
    'click .dismiss': 'doDismiss'

  # Create a LegacyBrowser view.
  #
  # If given, an optional "dismiss" option (a function) will be run whenever
  # the user dismisses the warning message.
  #
  constructor: ({ @dismiss }) -> super

  # Triggered when the user clicks the "Continue anyway..." button. Fades out
  # the message and removes it from the DOM.
  #
  doDismiss: ->
    @dismiss?()
    @$el.fadeOut => @remove()

  render: ->
    renderedMessage = message()

    # Add links to Chrome and Firefox.
    renderedMessage = renderedMessage.replace(
      /Google Chrome/, '<a href="http://google.com/chrome">Google Chrome</a>')

    renderedMessage = renderedMessage.replace(
      /Mozilla Firefox/, '<a href="http://getfirefox.com">Mozilla Firefox</a>')

    @$el.html renderedMessage
    this
