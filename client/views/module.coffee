app           = require 'app'
template      = require 'templates/module'

{ RangeView } = require 'views/range'

{ getVisualisation } = require 'views/vis'

# Module ---------------------------------------------------------------------

# The heart of ETflex; given a Module model creates an HTML representation
# displaying the left and right sliders, visualisations, etc.
#
class exports.ModuleView extends Backbone.View
  id: 'module-view'
  className: 'modern' # TODO Set dynamically based on server-sent JSON.

  events:
    'click #main-nav a': 'fakeNavClick'

  # Creates the HTML elements for the view, and binds events. Returns self.
  #
  # Example:
  #
  #   view = new ModuleView model: module
  #   $('body').html view.render().el
  #
  render: ->
    $(@el).html template()

    # Render each of the Inputs as a Range.

    leftRangesEl  = @$ '#left-inputs'
    rightRangesEl = @$ '#right-inputs'

    for input in @model.inputs.models
      view = new RangeView model: input

      if _.include @model.get('leftInputs'), input.get('id')
        leftRangesEl.append view.render().el
      else
        rightRangesEl.append view.render().el

    # Renders the center visualisation (in between the two slider groups).

    centerVis = @visualisation @model.get('centerVis'), queries: @model.queries
    @$('#center-vis').html centerVis.render().el

    # Renders the three visualisations below the sliders.

    for key in @model.get('mainVis')
      visualisation = @visualisation key, queries: @model.queries
      @$('#main-vis').append visualisation.render().el

    @renderTheme()

    this

  # Renders the modern theme by extending the default module template.
  #
  # This will likely be extracted to a separete "ModernView extends
  # ModuleView" class later.
  #
  renderTheme: ->
    modernHeader = require 'templates/modules/modern/header'
    @$('#core').prepend modernHeader()

  # Fakes a click on a navigation item. Does nothing for the moment.
  #
  fakeNavClick: (event) =>
    event.preventDefault()

  # Creates a new instance of a visualisation. Takes the key of the
  # visualisation and and additional arguments to be passed the constructor.
  #
  # key  - The key name for the visualisation. See views/vis.
  # args - Additional arguments passed to the constructor.
  #
  visualisation: (key, args...) ->
    new (getVisualisation key)(args...)
