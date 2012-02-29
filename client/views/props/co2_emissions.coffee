{ IconDashboardProp } = require 'views/props/dashboard'

{ hurdleStateNew } = require 'views/props'

class exports.CO2EmissionsView extends IconDashboardProp
  @queries: [ 'total_co2_emissions' ]
  hurdles:  [ 140, 154, 161 ]
  states:   [ 'low', 'medium', 'high', 'extreme' ]

  className: 'co2-emissions lower-better'

  # Renders the UI; calculates the C02 emissions. Can be safely called
  # repeatedly to update the UI.
  #
  render: ->
    super 'CO<sub>2</sub>'
    @updateValues()
    this

  # Updates the value shown to the user, and swaps the icon if necessary,
  # without re-rendering the whole view.
  #
  updateValues: =>
    # Query result is in kilograms. Divide by 1000 to get tons, then 1000_000
    # to get Mtons.
    value     = @query.get('future') / (1000 * 1000000)
    previous  = @query.previous('future') / (1000 * 1000000)

    formatted = I18n.toNumber value, precision: 1

    # Reduce the value to one decimal place when shown.
    @$el.find('.output').html "#{formatted} Mton"

    # Show difference with same precision
    @setDifference value - previous

    @icon.setState @hurdleState value

    this
