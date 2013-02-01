{ IconDashboardProp } = require 'views/props/dashboard'

class exports.EnergyBillView extends IconDashboardProp

  className: 'energy-bill'
  lowerBetter: true

  queries: [ 'etflex_households_monthly_energy_bill' ]
  hurdles: [ 29, 49, 69, 89 ]
  states:  [ 'very-low', 'low', 'medium', 'high', 'very-high' ]

  name: I18n.t 'scenes.etlite.energy_bill'
