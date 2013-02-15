{ IconDashboardProp } = require 'views/props/dashboard'

class exports.EnergyUseView extends IconDashboardProp

  className: 'energy-use'
  lowerBetter: true

  queries: [ 'etflex_households_final_demand_energy_per_household' ]
  hurdles: [ 7200, 18160, 29120, 40080, 51040, 62000 ]
  states:  [ 'extremely-low', 'very-low', 'low', 'medium', 'high', 'very-high', 'extremely-high' ]

  name: I18n.t 'scenes.etlite.energy_use'

