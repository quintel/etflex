app = require 'app'

# Upon achieving a high score, HighScoreRequest shows the user a form asking
# for their name to be entered on the high score board.
class exports.HighScoreRequest extends Backbone.View
  id: 'fade-overlay'

  events:
    'submit form':                   'commitName'
    'clickoutside .overlay-content': 'close'

  render: ->
    @$el.append require('templates/high_score_request')
      name: app.user.name or @model.get('guestName')

    this

  # Inserts the contents of the view into the given element, and then fades
  # the overlay into view.
  renderInto: (element) ->
    element.append @render().el
    @show()

  # Callback triggered upon submission of the username form. Updates the
  # scenario with the name chosen by the user.
  commitName: (event) ->
    name = @$('#scenario-guest-name').val()

    if name?.length
      @model.set guestName: name
      @model.save()

    @close()
    event.preventDefault()

  # Shows the overlay message, fading it into view. This presumes that the
  # element has already been added to the DOM.
  show: ->
    @$el.hide()
    @$el.fadeIn 250

  # Closes the overlay message, removing it from the DOM after the animation
  # has completed.
  close: ->
    console.log 'close'
    @$el.fadeOut 350, => @remove()
