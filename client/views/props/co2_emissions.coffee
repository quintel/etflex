{ IconDashboardProp } = require 'views/props/dashboard'

class exports.CO2EmissionsView extends IconDashboardProp

  className:   'co2-emissions'
  lowerBetter: true

  # Queries and hurdle values.

  queries: [ 'total_co2_emissions' ]
  hurdles: [ 140, 154, 161 ]
  states:  [ 'low', 'medium', 'high', 'extreme' ]

  # Display settings.

  name: 'CO<sub>2</sub>'
  unit: 'Mton'

  # Convert tons into megatons.
  mutateValue: (value) -> value / 1000000000
