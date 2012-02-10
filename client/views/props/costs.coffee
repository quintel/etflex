{ GenericProp } = require 'views/props/generic'
{ IconProp }    = require 'views/props/icon'

class exports.CostsView extends GenericProp
  @queries: [ 'total_costs' ]

  states:   [ 'nine', 'eight', 'seven', 'six', 'five',
              'four', 'three', 'two', 'one' ]

  className: 'prop costs'

  # Creates a new Costs prop. Calculates the cost of the choices the user
  # makes in the ETLite scene.
  #
  constructor: (options) ->
    super options

    @icon = new IconProp

    @query = options.queries.get 'total_costs'
    @query.on 'change:future', @updateValues

  # Renders the UI; calculates the C02 emissions. Can be safely called
  # repeatedly to update the UI.
  #
  render: ->
    super '', I18n.t 'scenes.etlite.costs'

    @$el.find('.icon').replaceWith @icon.render().el
    @updateValues()

    this

  # Updates the value shown to the user, and swaps the icon if necessary,
  # without re-rendering the whole view.
  #
  updateValues: =>
    # Divide to get the cost in billions.
    value = @query.get('future') / 1000000000
    previous = @query.previous('future') / 1000000000

    # Reduce the shown value to three decimal places.
    @$el.find('.output').html(
      "€ #{@precision value, 1} #{I18n.t 'scenes.etlite.billion'}")

    # Show difference with same precision
    @setDifference @precision value-previous, 1

    @icon.setState @hurdleState value

    this
