# Displays a message box to the user while obscuring everything behind it.
# Used, for example, on login forms, the legacy browser notices, etc.
#
# When initialized, you may pass an optional callback function as the
# "dismiss" option which will be called when the user dismisses the message.
#
# Add one or more elements with the .dismiss class; any such element when
# clicked will remove the message from view.
#
class exports.FullscreenMessage extends Backbone.View
  # Create a LegacyBrowser view.
  #
  # If given, an optional "dismiss" option (a function) will be run whenever
  # the user dismisses the warning message.
  #
  constructor: ({ @dismiss }) -> super

  # Fades out the message, then removes it from the DOM. Runs the "dismiss"
  # callback if one was provided when the instance was initialized.
  #
  dismissMessage: =>
    @dismiss?()
    @$el.fadeOut => @remove()

  # Events are bound in here so that subclasses may define their own events
  # hash without having to worry about duplicating these defaults.
  #
  # In subclasses, call super *at the end* of your render method.
  #
  render: ->
    @$el.on 'click', '.dismiss', @dismissMessage
    @$el.addClass 'fullscreen-message'

    this
