app = require 'app'

# Upon achieving a high score, HighScoreRequest shows the user a form asking
# for their name to be entered on the high score board.
class exports.HighScoreRequest extends Backbone.View
  id: 'fade-overlay'

  events:
    'submit form': 'commitName'
    'click #login-with-rtl a': 'loginWithRtl'

  # Renders the name request HTML.
  #
  # namespace - An I18n namespace within "scenes.name_request" which contains
  #             translations to be used. Provide "prelaunch" to instead show
  #             messages greeting the user to the scenario for the first time.
  #
  # Returns self.
  render: (namespace = 'score') ->
    @$el.html require('templates/high_score_request')
      name:      app.user.name or @model.get('guestName')
      namespace: namespace

    @delegateEvents()

    this

  # Callback triggered upon submission of the username form. Updates the
  # scenario with the name chosen by the user.
  commitName: (event) ->
    name = @$('#scenario-guest-name').val()

    if name?.length
      app.trigger 'current-user.name.request-change', name

    @close()
    event.preventDefault()

  # Shows the overlay message, fading it into view. This presumes that the
  # element has already been added to the DOM.
  #
  # If the user has previously entered a name (or opted to stay anonymous),
  # the name prompt won't be shown unless the "force" argument is true.
  show: (force, namespace) ->
    return true if @alreadyPrompted and force isnt true
    return true if @$el.is(':visible')

    @options.into.append @render(namespace).el

    # Try to position the modal box in the middle of the window (assumes the
    # box is ~270px high).
    @$('.overlay-content').css
      marginTop: "#{ ( $(window).height() - 270 ) / 2 }px"

    # Immediately close if the user hits escape.
    $('html').on 'keyup', @keyUpClose

    # Close if the user click outside the modal message. This isn't working
    # when in the events hash.
    @$('.overlay-content').on 'clickoutside', @close

    @$el.hide()
    @$el.fadeIn 250
    @$('#scenario-guest-name').focus()

  # Bound to the page keyUp event so that hitting escape removes the overlay.
  keyUpClose: (event) =>
    if event.keyCode is 27 then @close()

  # Closes the overlay message, removing it from the DOM after the animation
  # has completed.
  close: =>
    @alreadyPrompted = true

    $('html').off 'keyup', @keyUpClose
    @$el.fadeOut 350, => @remove()

  loginWithRtl: =>
    template = require 'templates/rtl_logon'
    console.log template()
    console.log 'Hello'
