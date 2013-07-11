# Contains logic associated with overlay messages - messages shown to the user
# in a black pop-up box.

class exports.OverlayMessageView extends Backbone.View
  className: 'overlay-background'

  events:
    'click .hide':              'hide'
    'click':                    'clickOutsideHide'
    'click a[data-action-key]': 'handleAction'

  # Creates the HTML elements for the modal overlay.
  #
  # Returns self.
  #
  # title   - The title for the message.
  # message - The message to be shown.
  #
  render: (title, message) ->
    content = $('<div class="overlay-message"></div>')

    # A "cross" which closes the message when clicked.
    hider = $ """
      <span class="hide">
        <span class="cross">&#215;</span> #{ I18n.t('close') }
      </span>"""

    content.append hider
    content.append $('<h3></h3>').html(title)

    for paragraph in message.split("\n\n")
      content.append $('<p></p>').html(paragraph)

    @keypressEvent = $('body').on('keyup', @keyboardHide)
    $(hider).on('click', @hide)

    @$el.append(content)

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

    # We position the message using JavaScript since using display: table
    # has some oddities in IE9 whereby the horizontal scrollbar will
    # occasionally appear, causing the message to jump up and down on the
    # page. Rather troublesome when you're trying to hit a "close" button.
    content = @$('.overlay-message')
    margin  = content.height() / -2

    # Push messages slightly higher up the page unless there is little space
    # available (phones).
    margin  = if @$el.height() > 720 then margin - 100 else margin

    content.css('margin-top', "#{ margin }px")

    # Fix alignment of close "cross" in IE.
    if $.browser.msie
      @$('.hide .cross').css('line-height', 'inherit')

    unless Modernizr.cssanimations
      @$el.hide().fadeIn(300)

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

  # Triggered when the user clicks outside the message box. Hides the message
  # UNLESS the click occurred inside the message box.
  clickOutsideHide: (event) =>
    $target = $ event.target

    @hide() unless \
      $target.hasClass('overlay-message') or
      $target.parents('.overlay-message').length

  # Activates an action to a JS-call and hides the overlay-message.
  handleAction: (event) ->
    @hide()

    intro = introJs()

    intro.setOptions({
      jQuerySelector: true,
      steps: [
        {
          element: '#left-inputs'
          intro: I18n.t 'intro.left-controls'
          position: 'right'
        },
        {
          element: '.world .house'
          intro: I18n.t 'intro.house'
          position: 'right'
        },
        {
          element: '#right-inputs'
          intro: I18n.t 'intro.right-controls'
          position: 'left'
        },
        {
          element: '.dashboard'
          intro: I18n.t 'intro.dashboard'
          position: 'top'
        },
        {
          element: '#scores'
          intro: I18n.t 'intro.highscores'
          position: 'top'
        },
      ]
    })

    intro.start()

    event.preventDefault()
    event.stopPropagation()
