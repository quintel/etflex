{ IconDashboardProp, DISPLAY_PERCENTAGE } = require 'views/props/dashboard'

# Calculates the percentage of total energy generated which is derived from
# solar and window energy.
#
class exports.RenewablesView extends IconDashboardProp

  className: 'renewables'

  # Queries and hurdle values.

  queries: [ 'renewability' ]
  hurdles: [ 3.75, 7.0, 10 ]
  states:  [ 'low', 'medium', 'high', 'extreme' ]

  # Display settings.

  name: I18n.t 'scenes.etlite.renewables'

  # Convert fractions to a percentage.
  mutateValue:  (value) -> value * 100
  displayValue: DISPLAY_PERCENTAGE
