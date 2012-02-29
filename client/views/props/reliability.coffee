{ DashboardProp } = require 'views/props/dashboard'
{ IconProp }      = require 'views/props/icon'

class exports.ReliabilityView extends DashboardProp
  @queries: [ 'security_of_supply_blackout_risk' ]

  hurdles:  [ 0.05 ]
  states:   [ 'on', 'off' ]

  className: 'reliability'

  # Creates a new renewability prop. Calculates the percentage of total energy
  # generated which is derived from solar and window energy.
  #
  constructor: (options) ->
    super options

    @icon = new IconProp

    @query = options.queries.get 'security_of_supply_blackout_risk'
    @query.on 'change:future', @updateValues

  render: ->
    super I18n.t 'scenes.etlite.reliability'

    @$el.find('.icon').replaceWith @icon.render().el
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
