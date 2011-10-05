# Contains logic associated with overlay messages - messages shown to the user
# in a black pop-up box.

class exports.OverlayMessage extends Backbone.View
  className: 'overlay-message'

  events:
    'click': 'hide'

  # Creates the HTML elements for the modal overlay.
  #
  # Returns self.
  #
  # title   - The title for the message.
  # message - The message to be shown.
  #
  render: (title, message) ->
    $(@el).append(@make('h3', {}, title), @make('p', {}, message))

    @delegateEvents()
    this

  # Given an HTML element, adds the overlay message to it and triggers the
  # initial animation.
  #
  # Returns self.
  #
  # element - The HTML element which the message will be appended to.
  #
  appendTo: (element) ->
    element.append @el

    if Modernizr.cssanimations
      $(@el).addClass 'in'
    else
      $(@el).hide().fadeIn 300

    this

  # Hides the message, then destroys the HTML elements after the hide
  # animations have completed.
  #
  hide: =>
    window.setTimeout (=> @remove()), 425

    if Modernizr.cssanimations
      $(@el).removeClass('in').addClass('out')
    else
      $(@el).fadeOut 300
