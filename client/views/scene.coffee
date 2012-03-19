app                  = require 'app'

api                  = require 'lib/api'
template             = require 'templates/scene'
scenarioTempl        = require 'templates/scenario'
badgeTempl           = require 'templates/badge'

{ RangeView }        = require 'views/range'
{ SceneNav }         = require 'views/scene_nav'
{ HighScores }       = require 'views/high_scores'
{ HighScoreRequest } = require 'views/high_score_request'

{ getProp }          = require 'views/props'
{ clientNavigate }   = require 'lib/client_navigate'

# Scene ----------------------------------------------------------------------

# The heart of ETflex; given a Scene model creates an HTML representation
# displaying the left and right sliders, props, etc.
#
class exports.SceneView extends Backbone.View
  id: 'scene-view'
  className: 'modern' # TODO Set dynamically based on server-sent JSON.

  pageTitle: -> @model.get('name')

  events:
    'click a':                clientNavigate
    'click #score-notifier': 'clickScoreNotifier'

  # Creates the HTML elements for the view, and binds events. Returns self.
  #
  # Example:
  #
  #   view = new SceneView model: scene
  #   $('body').html view.render().el
  #
  render: ->
    @$el.html template()

    @renderTheme()
    @renderProps()
    @renderNavigation()
    @initLoadingNotice()
    @initShareLinks()
    @initHighScores()

    this

  postRender: ->
    @renderInputs()
    @renderBadge() if app.isBeta()

  # When a user tries to alter inputs on a scenario which isn't theirs, a "not
  # authorized" modal dialog appears allowing them to take suitable action.
  #
  showNotAuthorizedModal: =>
    modalDialog = $ '#modal-dialog'

    modalDialog.children('#modal-content').html(
      "<h6>Cannot change scene: it belongs to someone else.</h6>").append(
      """<p>
        A dialog box will soon be added which informs the user of this fact,
        and provides the option of "forking" the scenario so that they may
        customise the values, or of starting the scenario from scratch.
      </p>""")

    modalDialog.reveal()

  # Creates a new instance of a prop. Takes the key of the prop and and
  # additional arguments to be passed the constructor.
  #
  # key  - The key name for the prop. See views/props.
  # args - Additional arguments passed to the constructor.
  #
  prop: (key, args...) ->
    new (getProp key)(args...)

  # Returns a Hash of Div elements, each of which is a location in the
  # template where props may be rendered. Each hash key is the prop location.
  #
  propContainers: ->
    @containersFor 'prop'

  # Returns a Hash of div elements, each of which is a location in the
  # template where inputs may be rendered. Each hash key is the input
  # location.
  #
  inputContainers: ->
    @containersFor 'input'

  # Used to find locations at which a type of element may be rendered. Used by
  # propContainers and inputContainers.
  #
  containersFor: (place) ->
    containers = {}

    for element in @$ "[data-#{ place }-location]"
      element = $ element
      containers[ element.attr "data-#{ place }-location" ] = element

    containers

  # TODO: move this function to a generic class of Application wide helpers
  #       It now also lives in generic.coffee
  #
  # Given a number, rounds to to a certain number of decimal places. Returns
  # a string.
  #
  # number    - The number to be rounded.
  # precision - The number of decimal places to be shown.
  #
  precision: (number, precision) ->
    if precision is 0
      "#{Math.round number}"
    else
      # When precision is >= 1, we first round the number using the desired
      # precision and then, since floating-point arithmetic means that we may
      # still end up with a number with too many decimal places, forcefully
      # truncate the number.

      multiplier = Math.pow 10, precision

      rounded = Math.round(number * multiplier) / multiplier
      rounded = rounded.toString().split '.'

      if rounded.length is 1 then rounded else
        "#{rounded[0]}.#{rounded[1][0...precision]}"

  # Triggered when the user clicks the "You got a high score" box. Smoothly
  # scrolls to the high scores list, and shows the user name form.
  #
  clickScoreNotifier: (event) ->
    $.scrollTo('#scores', offset: { top: -20 }, duration: 350)
    @requestScenarioGuestName()

    event.stopPropagation()
    event.preventDefault()

  # Shows an overlay message asking the user for a guest name to be associated
  # with the scenario.
  #
  # This does nothing if the visitor is a logged-in user whose name is set. It
  # will always trigger for guests (allowing them to change the name if
  # they want).
  #
  requestScenarioGuestName: ->
    if app.user.isGuest or app.user.name.length is 0
      new HighScoreRequest(model: @model.scenario).renderInto $ 'body'

  # RENDERING STEPS ----------------------------------------------------------

  # Renders the modern theme by extending the default scene template.
  #
  # This will likely be extracted to a separete "ModernView extends
  # SceneView" class later.
  #
  renderTheme: ->
    modernHeader = require 'templates/scenes/modern/header'
    @$('#core').prepend modernHeader()

  # Renders the inputs into the scene using RangeView instances, which contain
  # the Quinn sliders.
  #
  renderInputs: ->
    canChange      = @model.scenario.canChange(app.user)
    inputLocations = @inputContainers()

    for input in @model.inputs.models
      rangeView = new RangeView model: input, canChange: canChange

      rangeView.bind 'notAuthorizedToChange', @showNotAuthorizedModal

      # If the input location doesn't exist in the template, the input will
      # not rendered. This is intentional so that "hidden" and "$internal"
      # inputs don't raise errors.
      if into = inputLocations[ input.get 'location' ]
        rangeView.renderInto into

  # Renders each of the props into the scene.
  #
  # Props are inserted into the correct elements by looking for
  # "data-prop-location" attributes, and rendering the prop views into
  # elements which correspond with the prop's "location" attribute.
  #
  renderProps: ->
    propLocations = @propContainers()

    for prop in @model.get('props')
      propView = @prop prop.behaviour,
        key:     prop.key
        hurdles: prop.hurdles
        queries: @model.queries
        region:  => @model.scenario.get('country')

      # If the prop location doesn't exist in the template, the prop will not
      # rendered. This is intentional so that "hidden" props don't raise
      # errors.
      propLocations[ prop.location ]?.append propView.render().el

  # Sets up the top navigation element for the scene, providing the ability
  # to navigate to other pages, view the scene on ET-Model, etc.
  #
  renderNavigation: ->
    @$('#footer').before (new SceneNav model: @model).render().el

  # Fires up the high scores list, and monitors changes to the active list so
  # that we can inform the user if their scenario appear or disappears from
  # the list.
  #
  initHighScores: ->
    highScores = new HighScores {}
    notifier   = new Notifier @$('#score-notifier')

    @$('#scores').html highScores.render().el

    highScores.on 'update', (summary, coll) =>
      return false unless summary.get('session_id') is @model.scenario.id
      return false unless summary.get('user_id') is app.user.id

      unless coll.isTopN(summary, highScores.show)
        notifier.hide()
        return false

      notifier.show()

      # Don't prompt for a name if we already know one.
      if summary.get('user_name')?.length or @model.scenario.stayAnonymous
        return false

      @requestScenarioGuestName()

  # Creates the "Loading..." box which pops up at the bottom-left of the
  # scene view whenever an XHR request is pending.
  #
  initLoadingNotice: ->
    loader = @$ '#loader'

    loader.ajaxStart -> loader.stop().animate bottom:   '0px', 'fast'
    loader.ajaxStop  -> loader.stop().animate bottom: '-36px', 'fast'

  renderBadge: ->
    $('body').append badgeTempl()

  # Sets up the social media "share" links.
  #
  initShareLinks: ->
    link = encodeURIComponent(
      "http://etflex.et-model.com/scenes/" +
      "#{ @model.id }/#{ @model.scenario.get('sessionId') }")

    # Facebook.
    fbLink = "http://www.facebook.com/sharer.php?u=#{link}&t=ETFlex"
    @$('#social-media .facebook a').attr('href', fbLink)

    # Twitter
    twitterLink = "http://www.twitter.com/share?url=#{link}"
    @$('#social-media .twitter a').attr('href', twitterLink)

    # Google Plus (+)
    googleLink = "http://plusone.google.com/_/+1/confirm?hl=en&url=#{link}"
    @$('#social-media .google a').attr('href', googleLink)

# Handles the "You got a high score" notification message.
class Notifier
  # Expects a single argument; the notifier DOM element.
  constructor: (@el) -> @$el = $ @el

  show: ->
    if @$el.css('bottom') is '-38px'
      @$el.animate bottom: '0px', 350, 'easeInOutCubic'

  hide: ->
    if @$el.css('bottom') is '0px'
      @$el.animate bottom: '-38px', 350, 'easeInOutCubic'
