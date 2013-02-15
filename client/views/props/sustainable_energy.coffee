{ IconDashboardProp } = require 'views/props/dashboard'

class exports.SustainableEnergyView extends IconDashboardProp

  queries: [ 'etflex_households_production_renewable_energy_per_household' ]
  hurdles: [ 29, 49, 69, 89 ]
  states:  [ 'very-low', 'low', 'medium', 'high', 'very-high' ]

  name: I18n.t 'scenes.etlite.sustainable_energy'

