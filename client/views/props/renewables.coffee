{ IconDashboardProp } = require 'views/props/dashboard'

# Calculates the percentage of total energy generated which is derived from
# solar and window energy.
#
class exports.RenewablesView extends IconDashboardProp
  @queries: [ 'renewability' ]

  hurdles:  [ 6, 8, 10 ]
  states:   [ 'low', 'medium', 'high', 'extreme' ]

  className: 'renewables'

  # Renders the UI; calculates the CO2 emissions. Can be safely called
  # repeatedly to update the UI.
  #
  render: ->
    super I18n.t 'scenes.etlite.renewables'
    @updateValues()
    this

  # Updates the value shown to the user, and swaps the icon if necessary,
  # without re-rendering the whole view.
  #
  updateValues: =>
    # Multiply the query value by 100 to get a percentage.
    value     = @query.get('future') * 100
    previous  = @query.previous('future') * 100

    formatted = I18n.toNumber value, precision: 1

    @setDifference value - previous

    # Reduce the value to three decimal places when shown.
    @$el.find('.output').html "#{formatted}%"

    @icon.setState @hurdleState value

    this
