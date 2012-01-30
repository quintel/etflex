app           = require 'app'

api           = require 'lib/api'
template      = require 'templates/scene'

{ RangeView } = require 'views/range'
{ SceneNav }  = require 'views/scene_nav'

{ getProp }   = require 'views/props'

# Scene ----------------------------------------------------------------------

# The heart of ETflex; given a Scene model creates an HTML representation
# displaying the left and right sliders, props, etc.
#
class exports.SceneView extends Backbone.View
  id: 'scene-view'
  className: 'modern' # TODO Set dynamically based on server-sent JSON.

  pageTitle: -> @model.get('name')

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

    canChange      = @model.scenario.canChange(app.user)
    inputLocations = @inputContainers()

    for input in @model.inputs.models
      rangeView = new RangeView model: input, canChange: canChange

      # If the input location doesn't exist in the template, the input will not
      # rendered. This is intentional so that "hidden" and "$internal" inputs
      # don't raise errors.
      inputLocations[ input.get('location') ]?.append rangeView.render().el

    # Render each of the Props.

    propLocations = @propContainers()

    for prop in @model.get('props')
      propView = @prop prop.behaviour,
        key:     prop.key
        hurdles: prop.hurdles
        queries: @model.queries

      # If the prop location doesn't exist in the template, the prop will not
      # rendered. This is intentional so that "hidden" props don't raise
      # errors.
      propLocations[ prop.location ]?.append propView.render().el

    # Initialize the nav menu.
    @$('#footer').before (new SceneNav model: @model).render().el

    # The "Loading..." events.
    loader = @$ '#loader'

    loader.ajaxStart -> loader.stop().animate bottom:   '0px', 'fast'
    loader.ajaxStop  -> loader.stop().animate bottom: '-36px', 'fast'

    # Social media links.
    @initShareLinks()

    this

  # Renders the modern theme by extending the default scene template.
  #
  # This will likely be extracted to a separete "ModernView extends
  # SceneView" class later.
  #
  renderTheme: ->
    modernHeader = require 'templates/scenes/modern/header'
    @$('#core').prepend modernHeader()

  # Sets up the social media "share" links.
  #
  initShareLinks: ->
    link = encodeURIComponent(
      "http://etflex.et-model.com/scenes/" +
      "#{ @model.id }/#{ @model.scenario.get('sessionId') }")

    # Facebook.
    fbLink = "http://www.facebook.com/sharer.php?u=#{link}&t=ETFlex"
    @$('#social-media .facebook a').attr('href', fbLink)

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
