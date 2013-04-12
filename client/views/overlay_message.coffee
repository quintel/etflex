# Contains logic associated with overlay messages - messages shown to the user
# in a black pop-up box.

class exports.OverlayMessageView extends Backbone.View
  className: 'overlay-message'

  events:
    'mousedown':    'hide'
    'touchstart':   'hide'
    'clickoutside': 'hide'

  # Creates the HTML elements for the modal overlay.
  #
  # Returns self.
  #
  # title   - The title for the message.
  # message - The message to be shown.
  #
  render: (title, message) ->
    # A "cross" which closes the message when clicked.
    hider = @make('span', { class: 'hide' }, '')

    @$el.append hider
    @$el.append @make('h3', {}, title)

    for paragraph in message.split("\n\n")
      @$el.append @make('p', {}, paragraph)

    @keypressEvent = $('body').on('keyup', @keyboardHide)
    $(hider).on('click', @hide)

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

  # Bound to <body>, hides the message if the user hits [escape].
  keyboardHide: (event) =>
    if event.keyCode is 27 then @hide()

  # Hides the message, then destroys the HTML elements after the hide
  # animations have completed.
  #
  hide: (event) =>
    # For some reason, clickoutside is triggering when the message is shown.
    # Ignore calls to hide within 100ms of the message becoming visible.
    #
    # TODO Find out why this happens...
    #
    return false if (new Date - @shownAt) < 100

    window.setTimeout (=> @remove()), 325
    $('body').off('keyup', @keyboardHide)

    if Modernizr.cssanimations
      @$el.addClass('out')
    else
      @$el.fadeOut 300

    # Ensure that clicking outside the message doesn't activate anything else.
    false
