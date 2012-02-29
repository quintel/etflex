{ IconDashboardProp } = require 'views/props/dashboard'

# Calculates the percentage of total energy generated which is derived from
# solar and window energy.
#
class exports.ReliabilityView extends IconDashboardProp
  @queries: [ 'security_of_supply_blackout_risk' ]

  hurdles:  [ 0.05 ]
  states:   [ 'on', 'off' ]

  className: 'reliability'

  render: ->
    super I18n.t 'scenes.etlite.reliability'
    @updateValues()
    this

  # Updates the value shown to the user, and swaps the icon if necessary,
  # without re-rendering the whole view.
  #
  updateValues: =>
    value     = (1 - @query.get('future')) * 100 # risk is bad, none is good
    previous  = (1 - @query.previous('future')) * 100

    formatted = I18n.toNumber value, precision: 1

    # Reduce the value to three decimal places when shown.
    @$el.find('.output').html("#{formatted}%")

    @icon.setState @hurdleState @query.get('future')

    @setDifference value - previous, precision: 1

    this
