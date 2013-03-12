{ IconDashboardProp } = require 'views/props/dashboard'

class exports.ElectricityUseView extends IconDashboardProp

  className: 'electricity-use'
  lowerBetter: true

  queries: [ 'etflex_households_final_demand_electricity_per_household' ]
  hurdles: [ 1210, 2379, 3657, 4936, 6215, 7493 ]
  states:  [ 'extremely-low', 'very-low', 'low', 'medium', 'high', 'very-high', 'extremely-high' ]

  name: I18n.t 'scenes.etlite.electricity_use'

