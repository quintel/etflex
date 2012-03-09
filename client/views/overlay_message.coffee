# Contains logic associated with overlay messages - messages shown to the user
# in a black pop-up box.

class exports.OverlayMessageView extends Backbone.View
  className: 'overlay-message'

  events:
    'mousedown':    'hide'
    'clickoutside': 'hide'

  # Creates the HTML elements for the modal overlay.
  #
  # Returns self.
  #
  # title   - The title for the message.
  # message - The message to be shown.
  #
  render: (title, message) ->
    @$el.append @make('h3', {}, title)

    for paragraph in message.split("\n\n")
      @$el.append @make('p', {}, paragraph)

    this

  # Given an HTML element, adds the overlay message to it and triggers the
  # initial animation.
  #
  # Returns self.
  #
  # element - The HTML element which the message will be appended to.
  #
  prependTo: (element) ->
    element.prepend @el

    unless Modernizr.cssanimations
      @$el.hide().fadeIn 300

    @shownAt = new Date

    this

  # Hides the message, then destroys the HTML elements after the hide
  # animations have completed.
  #
  hide: (event) ->
    # For some reason, clickoutside is triggering when the message is shown.
    # Ignore calls to hide within 100ms of the message becoming visible.
    #
    # TODO Find out why this happens...
    #
    return false if (new Date - @shownAt) < 100

    window.setTimeout (=> @remove()), 325

    if Modernizr.cssanimations
      @$el.addClass('out')
    else
      @$el.fadeOut 300
