contents              = require 'templates/legacy_browser'
{ FullscreenMessage } = require 'views/fullscreen_message'

# Displays a message to the user informing them that their choice of browser
# is... less than optimal.
#
# It allows the user to dismiss the message so that they may opt to continue
# anyway, setting a cookie so that the message isn't displayed on repeat
# visits (or render() calls, for that matter).
#
class exports.LegacyBrowser extends FullscreenMessage
  render: ->
    renderedMessage = contents()

    # Add links to Chrome and Firefox.
    renderedMessage = renderedMessage.replace(
      /Google Chrome/, '<a href="http://google.com/chrome">Google Chrome</a>')

    renderedMessage = renderedMessage.replace(
      /Mozilla Firefox/, '<a href="http://getfirefox.com">Mozilla Firefox</a>')

    @$el.html renderedMessage

    super
