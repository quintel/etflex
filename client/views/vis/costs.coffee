{ GenericVisualisation } = require 'views/vis/generic'
{ IconVisualisation }    = require 'views/vis/icon'

class exports.CostsView extends GenericVisualisation
  @queries: [ 'total_costs' ]

  states:   [ 'nine', 'eight', 'seven', 'six', 'five',
              'four', 'three', 'two', 'one' ]

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
    # Divide to get the cost in billions.
    value = @query.get('future') / 1000000000

    # Reduce the shown value to three decimal places.
    $(@el).find('.output').html(
      "€#{@precision value, 3} #{I18n.t 'scenes.etlite.billion'}")

    @icon.setState @hurdleState value

    this
