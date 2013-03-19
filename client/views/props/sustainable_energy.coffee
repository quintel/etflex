{ IconDashboardProp } = require 'views/props/dashboard'

class exports.SustainableEnergyView extends IconDashboardProp
  className: 'sustainable-energy'

  queries: [ 'etflex_households_percentage_renewable_energy_per_household' ]
  hurdles: [ 10, 25, 50, 100 ]
  states:  [ 'very-low', 'low', 'medium', 'high', 'very-high' ]

  name: I18n.t 'scenes.etlite.sustainable_energy'

