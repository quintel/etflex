{ GenericProp }    = require 'views/props/generic'
{ IconProp }       = require 'views/props/icon'

{ hurdleStateNew } = require 'views/props'

class exports.CO2EmissionsView extends GenericProp
  @queries: [ 'total_co2_emissions' ]
  states:   [ 'low', 'medium', 'high', 'extreme' ]

  className: 'prop co2-emissions lower-better'

  # Creates a new CO2Emissions prop. In addition to the usual Backbone
  # options, requires `gas` containing the gas-fired power plants input, and
  # `coal` containing the coal-fired power plans input.
  #
  constructor: (options) ->
    super options

    @icon = new IconProp

    @query = options.queries.get 'total_co2_emissions'
    @query.on 'change:future', @updateValues

  # Renders the UI; calculates the C02 emissions. Can be safely called
  # repeatedly to update the UI.
  #
  render: ->
    super '', 'CO<sub>2</sub>'

    @$el.find('.icon').replaceWith @icon.render().el
    @updateValues()

    this

  # Updates the value shown to the user, and swaps the icon if necessary,
  # without re-rendering the whole view.
  #
  updateValues: =>
    # Query result is in kilograms. Divide by 1000 to get tons, then 1000_000
    # to get Mtons.
    value = @query.get('future') / (1000 * 1000000)
    previous = @query.previous('future') / (1000 * 1000000)

    # Reduce the value to one decimal place when shown.
    @$el.find('.output').html "#{@precision value, 1} Mton"

    # Show difference with same precision
    @setDifference @precision value - previous, 1

    @icon.setState @hurdleState value

    this
