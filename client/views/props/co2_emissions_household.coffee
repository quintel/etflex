{ IconDashboardProp } = require 'views/props/dashboard'

class exports.CO2EmissionsHouseholdView extends IconDashboardProp

  className:   'co2-emissions-household'
  lowerBetter: true

  # Queries and hurdle values.

  queries: [ 'etflex_households_co2_emissions_per_household' ]
  hurdles: [ 0.75, 1.6, 2.5, 3.4 ]
  states:  [ 'very-low', 'low', 'medium', 'high', 'very-high' ]

  # Display settings.

  name: 'CO<sub>2</sub>'

  # Help Texts
  helpHeader: -> "props.co2_emissions_household.header"
  helpBody:   -> "props.co2_emissions_household.body"

