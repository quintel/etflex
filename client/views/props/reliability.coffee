{ GenericProp } = require 'views/props/generic'
{ IconProp }    = require 'views/props/icon'

class exports.ReliabilityView extends GenericProp
  @queries: [ 'security_of_supply_blackout_risk' ]
  states:   [ 'off', 'blinking', 'on' ]

  className: 'prop reliability'

  # Creates a new renewability prop. Calculates the percentage of total energy
  # generated which is derived from solar and window energy.
  #
  constructor: (options) ->
    super options

    @icon = new IconProp

    @query = options.queries.get 'security_of_supply_blackout_risk'
    @query.bind 'change:future', @updateValues

  render: ->
    super '', I18n.t 'scenes.etlite.reliability'

    $(@el).find('.icon').replaceWith @icon.render().el
    @updateValues()

    this

  # Updates the value shown to the user, and swaps the icon if necessary,
  # without re-rendering the whole view.
  #
  updateValues: =>
    value = (1 - @query.get('future')) * 100 # risk is bad, no risk is good

    # Reduce the value to three decimal places when shown.
    $(@el).find('.output').html("#{@precision value, 2}%")

    @icon.setState @hurdleState value

    this
