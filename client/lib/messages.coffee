# A module which shows messages, alerts, and errors using a modal overlay on
# the screen.

{ OverlayMessage } = require 'views/overlay_message'

# Holds the currently displayed message.
currentMessage = null

# Shows a simple modal message containing a title and single paragraph.
#
# title   - The title for the message.
# message - The message to be shown.
#
exports.showMessage = (title, message) ->
  if currentMessage and $(currentMessage.el).is(':visible')
    currentMessage.hide()
    currentMessage = null
  else
    currentMessage = new OverlayMessage

    currentMessage.render title, message
    currentMessage.appendTo $ '#chrome'
