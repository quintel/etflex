{ IconDashboardProp } = require 'views/props/dashboard'

class exports.EnergyUseView extends IconDashboardProp

  className: 'energy-use'
  lowerBetter: true

  queries: [ 'etflex_households_final_demand_electricity_per_household' ]
  hurdles: [ 2000, 2750, 3500, 4250, 5000, 5700 ]
  states:  [ 'extremely-low', 'very-low', 'low', 'medium', 'high', 'very-high', 'extremely-high' ]

  name: I18n.t 'scenes.etlite.energy_use'

