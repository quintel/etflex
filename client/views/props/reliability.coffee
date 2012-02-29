{ IconDashboardProp, DISPLAY_PERCENTAGE } = require 'views/props/dashboard'

# Calculates the percentage of total energy generated which is derived from
# solar and window energy.
#
class exports.ReliabilityView extends IconDashboardProp

  className: 'reliability'

  # Queries and hurdle values.

  queries: [ 'security_of_supply_blackout_risk' ]
  hurdles: [ 95 ]
  states:  [ 'off', 'on' ]

  # Display settings.

  name: I18n.t 'scenes.etlite.reliability'

  # Risk is bad, none is good.
  mutateValue:  (value) -> (1 - value) * 100
  displayValue: DISPLAY_PERCENTAGE
