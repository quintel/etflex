{ IconDashboardProp } = require 'views/props/dashboard'

class exports.CostsView extends IconDashboardProp
  @queries: [ 'total_costs' ]

  hurdles:  [ 38, 40, 42, 44, 48, 50, 52 ]
  states:   [ 'nine', 'eight', 'seven', 'six', 'five',
              'four', 'three', 'two', 'one' ]

  className: 'costs lower-better'

  # Renders the UI; calculates the C02 emissions. Can be safely called
  # repeatedly to update the UI.
  #
  render: ->
    super I18n.t 'scenes.etlite.costs'
    @updateValues()
    this

  # Updates the value shown to the user, and swaps the icon if necessary,
  # without re-rendering the whole view.
  #
  updateValues: =>
    # Divide to get the cost in billions.
    value     = @query.get('future') / 1000000000
    previous  = @query.previous('future') / 1000000000

    formatted = I18n.toNumber value, precision: 1

    # Reduce the shown value to three decimal places.
    @$el.find('.output').html(
      "€ #{formatted} #{I18n.t 'scenes.etlite.billion'}")

    # Show difference with same precision
    @setDifference value - previous

    @icon.setState @hurdleState value

    this
