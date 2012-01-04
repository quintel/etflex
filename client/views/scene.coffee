api           = require 'lib/api'
template      = require 'templates/scene'

{ RangeView } = require 'views/range'
{ getProp }   = require 'views/props'

{ beta }      = require 'lib/session_manager'

# ----------------------------------------------------------------------------

# Returns the path to the current ETEngine session on ETModel.
#
# session - The session instance we want to view on ETModel.
#
pathToSessionOnETM = (session) ->
  host = if beta?
    'http://beta.et-model.com'
  else
    'http://et-model.com'

  "#{ host }/scenarios/#{ session.id }/load"

# Scene ----------------------------------------------------------------------

# The heart of ETflex; given a Scene model creates an HTML representation
# displaying the left and right sliders, props, etc.
#
class exports.SceneView extends Backbone.View
  id: 'scene-view'
  className: 'modern' # TODO Set dynamically based on server-sent JSON.

  events:
    'click #main-nav a': 'fakeNavClick'

  # Creates the HTML elements for the view, and binds events. Returns self.
  #
  # Example:
  #
  #   view = new SceneView model: scene
  #   $('body').html view.render().el
  #
  render: ->
    $(@el).html template()

    # Render additional elements used in the modern theme (the animated
    # header element, etc).

    @renderTheme()

    # Render each of the Inputs as a Range.

    leftRangesEl  = @$ '#left-inputs'
    rightRangesEl = @$ '#right-inputs'

    for input in @model.inputs.models
      view = new RangeView model: input

      if input.get('location') is 'left'
        leftRangesEl.append view.render().el
      else
        rightRangesEl.append view.render().el

    # Render each of the Props.

    propLocations = @propContainers()

    for prop in @model.get('props')
      propView = @prop prop.behaviour,
        hurdles: prop.hurdles
        queries: @model.queries

      # If the prop location doesn't exist in the template, the prop will not
      # rendered. This is intentional so that "hidden" props don't raise
      # errors.
      propLocations[ prop.location ]?.append propView.render().el

    # Link to the session on ET-Model.
    @$('#social-media .etmodel a').attr('href',
      pathToSessionOnETM(@model.session))

    this

  # Renders the modern theme by extending the default scene template.
  #
  # This will likely be extracted to a separete "ModernView extends
  # SceneView" class later.
  #
  renderTheme: ->
    modernHeader = require 'templates/scenes/modern/header'
    @$('#core').prepend modernHeader()

  # Fakes a click on a navigation item. Does nothing for the moment.
  #
  fakeNavClick: (event) =>
    event.preventDefault()

  # Sends the user to view their session on ET-Model.
  #
  navigateToETModel: (event) =>
    host = if api.beta?
      'http://beta.et-model.com'
    else
      'http://et-model.com'

    window.navigate "#{ host }/scenarios/#{ @model.session.id }/load"

    event.preventDefault()

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
    containers = {}

    for element in @$ '[data-prop-location]'
      element = $ element
      containers[ element.attr 'data-prop-location' ] = element

    containers
