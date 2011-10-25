# Contains logic associated with overlay messages - messages shown to the user
# in a black pop-up box.

class exports.OverlayMessageView extends Backbone.View
  className: 'overlay-wrap'

  events:
    'mousedown': 'hide'

  # Creates the HTML elements for the modal overlay.
  #
  # Returns self.
  #
  # title   - The title for the message.
  # message - The message to be shown.
  #
  render: (title, message) ->
    @messageEl = $(@make 'div', class: 'overlay-message')

    @messageEl.append @make('h3', {}, title)
    @messageEl.append @make('p', {}, message)

    $(@el).append @messageEl

    @delegateEvents()
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
      $(@messageEl).hide().fadeIn 300

    this

  # Hides the message, then destroys the HTML elements after the hide
  # animations have completed.
  #
  hide: =>
    window.setTimeout (=> @remove()), 325

    if Modernizr.cssanimations
      $(@messageEl).addClass('out')
    else
      $(@messageEl).fadeOut 300
