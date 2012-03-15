app                   = require 'app'

api                   = require 'lib/api'
template              = require 'templates/scene'
scenarioTempl         = require 'templates/scenario'
badgeTempl            = require 'templates/badge'

{ RangeView }         = require 'views/range'
{ SceneNav }          = require 'views/scene_nav'
{ HighScores }        = require 'views/high_scores'
{ ScenariosWindow }   = require 'views/scenarios_window'

{ ScenarioSummaries } = require 'collections/scenario_summaries'

{ getProp }           = require 'views/props'
{ clientNavigate }    = require 'lib/client_navigate'

# Scene ----------------------------------------------------------------------

# The heart of ETflex; given a Scene model creates an HTML representation
# displaying the left and right sliders, props, etc.
#
class exports.SceneView extends Backbone.View
  id: 'scene-view'
  className: 'modern' # TODO Set dynamically based on server-sent JSON.

  pageTitle: -> @model.get('name')
  events: { 'click a': clientNavigate }

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
    @initHighScores()
    @initLoadingNotice()
    @initShareLinks()

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

  # Creates the high scores list also present on the root page.
  #
  initHighScores: ->
    @$('.score a').click =>
      scenariosWindow = new ScenariosWindow scene: @model
      scenariosWindow = scenariosWindow.render().el

      overlayElement  = $ '<div id="fade-overlay" style="display:none"></div>'

      $('body').append overlayElement.append(scenariosWindow).fadeIn 250

      return false

  # Creates the "Loading..." box which pops up at the bottom-left of the
  # scene view whenever an XHR request is pending.
  #
  initLoadingNotice: ->
    loader = @$ '#loader'

    loader.ajaxStart -> loader.stop().animate bottom:   '0px', 'fast'
    loader.ajaxStop  -> loader.stop().animate bottom: '-36px', 'fast'

  renderBadge: ->
    $('body').append badgeTempl()

  # Initializes the scenarios list which appears on the right-hand side of the
  # scene and links to scenarios belonging to other users.
  #
  # Note that this method is asynchronous; the scenes are shown only after
  # completing a request to the ET-Flex server.
  #
  initOtherScenarios: ->
    app.collections.scenarios.fetch
      add:  true
      data: { current_session_id: @model.scenario.get 'sessionId' }
      success: (collection) =>
        for scenario in collection.models
          @$('#updates').append scenarioTempl
            scene:       scenario.get('scene')
            sessionId:   scenario.get('sessionId')
            score:       @precision scenario.get('queryResults').score, 0
            userName:    scenario.get('user').id?.toString()[0..10]
            userCountry: 'United Kingdom'
            userCity:    'London'

  # Sets up the social media "share" links.
  #
  initShareLinks: ->
    link = encodeURIComponent(
      "http://etflex.et-model.com/scenes/" +
      "#{ @model.id }/#{ @model.scenario.get('sessionId') }")

    # Facebook.
    fbLink = "http://www.facebook.com/sharer.php?u=#{link}&t=ETFlex"
    @$('#social-media .facebook a').attr('href', fbLink)
