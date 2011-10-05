# Contains logic associated with overlay messages - messages shown to the user
# in a black pop-up box.

class exports.OverlayMessage extends Backbone.View
  className: 'overlay-message'

  'click h3': 'hide'

  # Creates the HTML elements for the modal overlay.
  #
  # Returns self.
  #
  # title   - The title for the message.
  # message - The message to be shown.
  #
  render: (title, message) ->
    console.log "Rendering", title, message

    $(@el)
      .append(@make('h3', {}, title), @make('p', {}, message))

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
    $(@el).addClass('in')
    @delegateEvents()

    this

  # Hides the message, then destroys the HTML elements after the hide
  # animations have completed.
  #
  hide: =>
    # window.setTimeout (=> @remove()), 0.4
    window.setTimeout =>
      @remove()
      console.log 'rempving'
    , 425

    $(@el)
      .removeClass('in')
      .addClass('out')
