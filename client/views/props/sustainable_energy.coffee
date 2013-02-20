{ IconDashboardProp } = require 'views/props/dashboard'

class exports.SustainableEnergyView extends IconDashboardProp
  className: 'sustainable-energy'

  queries: [ 'etflex_households_production_renewable_energy_per_household' ]
  hurdles: [ 1250, 2500, 3750, 5000 ]
  states:  [ 'very-low', 'low', 'medium', 'high', 'very-high' ]

  name: I18n.t 'scenes.etlite.sustainable_energy'

