{ GenericVisualisation } = require 'views/vis/generic'
{ IconVisualisation }    = require 'views/vis/icon'

class exports.CostsView extends GenericVisualisation
  @queries: [ 'total_costs' ]

  className: 'visualisation costs'

  # Creates a new Costs visualisation. Calculates the cost of the choices the
  # user makes in the ETLite scene.
  #
  constructor: (options) ->
    super options

    @icon = new IconVisualisation

    @query = options.queries.get 'total_costs'
    @query.bind 'change:future', @updateValues

  # Renders the UI; calculates the C02 emissions. Can be safely called
  # repeatedly to update the UI.
  #
  render: ->
    super '', I18n.t 'scenes.etlite.costs'

    $(@el).find('.icon').replaceWith @icon.render().el
    @updateValues()

    this

  # Updates the value shown to the user, and swaps the icon if necessary,
  # without re-rendering the whole view.
  #
  updateValues: =>
    value   = @precision @query.get('future') / 1000000000, 3
    element = $ @el

    element.find('.output').html "€#{value} #{I18n.t 'scenes.etlite.billion'}"

    if value < 40
      @icon.setState 'nine'
    else if value < 40.4
      @icon.setState 'eight'
    else if value < 40.8
      @icon.setState 'seven'
    else if value < 41.2
      @icon.setState 'six'
    else if value < 41.6
      @icon.setState 'five'
    else if value < 42.0
      @icon.setState 'four'
    else if value < 42.4
      @icon.setState 'three'
    else if value < 42.8
      @icon.setState 'two'
    else
      @icon.setState 'one'

    this
