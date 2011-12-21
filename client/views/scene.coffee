app           = require 'app'
template      = require 'templates/scene'

{ RangeView } = require 'views/range'
{ getProp }   = require 'views/props'

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

    centerProps = @$ '#center-props'
    mainProps   = @$ '#main-props'

    for prop in @model.get('props')
      propView = @prop prop.behaviour,
        hurdles: prop.hurdles
        queries: @model.queries

      if prop.location is 'bottom'
        mainProps.append propView.render().el
      else
        centerProps.append propView.render().el

    # Render additional elements used in the modern theme (the animated
    # header element, etc).

    @renderTheme()

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

  # Creates a new instance of a prop. Takes the key of the prop and and
  # additional arguments to be passed the constructor.
  #
  # key  - The key name for the prop. See views/props.
  # args - Additional arguments passed to the constructor.
  #
  prop: (key, args...) ->
    new (getProp key)(args...)
