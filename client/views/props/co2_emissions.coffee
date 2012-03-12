{ IconDashboardProp } = require 'views/props/dashboard'

class exports.CO2EmissionsView extends IconDashboardProp

  className:   'co2-emissions'
  lowerBetter: true

  # Queries and hurdle values.

  queries: [ 'total_co2_emissions' ]
  hurdles: [ 140, 162.5, 166 ]
  states:  [ 'low', 'medium', 'high', 'extreme' ]

  # Display settings.

  name: 'CO<sub>2</sub>'

  # Help Texts
  helpHeader: -> "props.co2_emissions.header"
  helpBody:   -> "props.co2_emissions.body"
