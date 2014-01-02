app                  = require 'app'

template             = require 'templates/scene'
badgeTempl           = require 'templates/badge'

{ GroupView }        = require 'views/group'
{ RangeView }        = require 'views/range'
{ OptionsView }      = require 'views/options'
{ SceneNav }         = require 'views/scene_nav'
{ HighScores }       = require 'views/high_scores'
{ HighScoreRequest } = require 'views/high_score_request'
{ HighScoreGrowl }   = require 'views/growl'
{ TourRequestView }  = require 'views/tour_request'

{ getProp }          = require 'views/props'
{ clientNavigate }   = require 'lib/client_navigate'
{ createUser }       = require 'models/user'

# Scene ----------------------------------------------------------------------

# The heart of ETflex; given a Scene model creates an HTML representation
# displaying the left and right sliders, props, etc.
#
class exports.SceneView extends Backbone.View
  id: 'scene-view'

  pageTitle: -> I18n.t "scenes.#{@model.get('name_key')}"

  events:
    'click a':                clientNavigate
    'click #score-notifier': 'clickScoreNotifier'

  # Public: Creates a new SceneView.
  #
  # SceneView renders the current only scene in ETflex -- the supply and
  # demand scene. It expects a Scene object which determines the structure of
  # the scene (inputs, props, etc), and a Scenario which has the keeps track
  # of the values.
  #
  constructor: ({ @scenario }) ->
    @scene      = @scenario.scene
    @className  = @scene.get('name_key')
    super

  # Called when a new page is to be shown, so that we may unbind events.
  destructor: ->
    @highScores?.destructor()
    @scenario.stop()

  # Creates the HTML elements for the view, and binds events. Returns self.
  #
  # Example:
  #
  #   view = new SceneView model: scene
  #   $('body').html view.render().el
  #
  render: ->
    @$el.html template(conferenceMode: app.conference)

    @renderTheme()
    @renderProps()
    @renderNavigation()
    @initHighScores()

    this

  postRender: ->
    @renderInputs()
    @renderBadge() if app.isBeta()
    @showIntro()

  # When a user tries to alter inputs on a scenario which isn't theirs, a "not
  # authorized" modal dialog appears allowing them to take suitable action.
  #
  showNotAuthorizedModal: =>
    modalDialog = $ '#modal-dialog'

    modalDialog.children('#modal-content').
      html("<h6>#{ I18n.t('scenes.cannot_change.title') }</h6>").
      append("<p>#{ I18n.t('scenes.cannot_change.message') }</p>")

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
    $.scrollTo('#scores', 350, offset: { top: -20 })
    @requestScenarioGuestName(true)

    event.stopPropagation()
    event.preventDefault()

  # Shows an overlay message asking the user for a guest name to be associated
  # with the scenario.
  #
  # This does nothing if the visitor is a logged-in user whose name is set. It
  # will always trigger for guests (allowing them to change the name if
  # they want).
  #
  requestScenarioGuestName: (force, namespace) ->
    if not app.user.name or app.user.name.length is 0
      @highScoreRequest or= new HighScoreRequest
        model: @scenario
        into:  $ '#master-content'

      @highScoreRequest.show force, namespace

  # RENDERING STEPS ----------------------------------------------------------

  # Renders the modern theme by extending the default scene template.
  #
  # This will likely be extracted to a separete "ModernView extends
  # SceneView" class later.
  #
  renderTheme: ->
    header = require "templates/scenes/#{ @className }/header"
    footer = require "templates/scenes/#{ @className }/footer"
    @$('#core').prepend header()
    @$('#scores').before footer()

  # Renders the inputs into the scene using RangeView instances, which contain
  # the Quinn sliders.
  #
  renderInputs: ->
    canChange      = @scenario.canChange(app.user)
    inputLocations = @inputContainers()

    lastGroup = ""
    for input in @scenario.inputs.models
      # If the input location doesn't exist in the template, the input will
      # not rendered. This is intentional so that "hidden" inputs don't raise
      # errors.
      into = inputLocations[ input.get 'position' ]
      continue unless into

      if lastGroup != input.get 'group'
        groupView = new GroupView model: input.get 'group'
        groupView.renderInto into

        lastGroup = input.get 'group'

      display = input.get 'display'

      if display == "slider"
        rangeView = new RangeView model: input, canChange: canChange
        rangeView.bind 'notAuthorizedToChange', @showNotAuthorizedModal
        rangeView.renderInto into

      else
        optionsView = new OptionsView model: input, canChange: canChange
        optionsView.renderInto into
    # for input in @scenario.inputs.models
    #   rangeView = new RangeView model: input, canChange: canChange

    #   rangeView.bind 'notAuthorizedToChange', @showNotAuthorizedModal

    #   if into = inputLocations[ input.get 'location' ]
    #     rangeView.renderInto into

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
        queries: @scenario.queries
        region:  => @scenario.get('country')
        scene:   @

      # If the prop location doesn't exist in the template, the prop will not
      # rendered. This is intentional so that "hidden" props don't raise
      # errors.
      propLocations[ prop.location ]?.append propView.render().el

  # Sets up the top navigation element for the scene, providing the ability
  # to navigate to other pages, view the scene on ETmodel, etc.
  #
  renderNavigation: ->
    @$('#footer').before (new SceneNav model: @scenario).render().el

  # Fires up the high scores list, and monitors changes to the active list so
  # that we can inform the user if their scenario appear or disappears from
  # the list.
  #
  initHighScores: ->
    @highScores = new HighScores scenario: @scenario
    notifier    = new HighScoreGrowl @$('#score-notifier')

    @$('#scores').html @highScores.render().el

    @highScores.on 'update', (summary, coll) =>
      return false unless summary.get('session_id') is @scenario.id
      return false unless summary.get('user_id') is app.user.id

      unless coll.isTopN(summary, @highScores.show)
        notifier.hide()
        return false

      # Don't show if the inputs are unchanged from the defaults. This happens
      # when the site is inactive; there may be fewer than 10 items on the
      # score board, and without this check the high score request would be
      # shown as soon as the scene loads.
      return false if @scenario.isDefault()

      notifier.show()

      # Don't prompt for a name if we already know one.
      if summary.get('user_name')?.length or @scenario.stayAnonymous
        return false

      @requestScenarioGuestName()

  # When the scenario belongs to the current user, and no name is set, we ask
  # them to let us know how to identify them.
  #
  doNameRequest: ->
    seenPrelaunchId = localStorage?.getItem 'seen-prelaunch'

    return true if     seenPrelaunchId and seenPrelaunchId is "#{app.user.id}"
    return true unless createUser(@scenario.get 'user').id is app.user.id
    return true if     app.user.name?.length > 0

    localStorage?.setItem 'seen-prelaunch', app.user.id

    @requestScenarioGuestName true, 'prelaunch'

  showIntro: ->
    unless localStorage?.getItem 'seen-tour'
      tour = new TourRequestView()
      tour.render(I18n.t('first_intro.header'), I18n.t('first_intro.body'))
      tour.prependTo $ 'body'

  renderBadge: ->
    $('#master-content').append badgeTempl()

