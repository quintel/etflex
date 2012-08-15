{ IconDashboardProp } = require 'views/props/dashboard'

# Calculates the percentage of total energy generated which is derived from
# solar and window energy.
#
class exports.ReliabilityView extends IconDashboardProp

  className: 'reliability'

  # Queries and hurdle values.

  queries: [ 'security_of_supply_reliability' ]
  hurdles: [ 95 ]
  states:  [ 'off', 'on' ]

  # Display settings.

  name: I18n.t 'scenes.etlite.reliability'

  # Help Texts
  helpHeader: -> "props.reliability.header.#{@icon.currentState}"
  helpBody:   -> "props.reliability.body"
