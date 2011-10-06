# A module which shows messages, alerts, and errors using a modal overlay on
# the screen.

{ OverlayMessage } = require 'views/overlay_message'

# Shows a simple modal message containing a title and single paragraph.
#
# title   - The title for the message.
# message - The message to be shown.
#
exports.showMessage = (title, message) ->
  currentMessage = new OverlayMessage

  currentMessage.render title, message
  currentMessage.prependTo $ 'body'
