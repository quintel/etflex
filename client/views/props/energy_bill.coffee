{ IconDashboardProp } = require 'views/props/dashboard'

class exports.EnergyBillView extends IconDashboardProp

  className: 'energy-bill'
  lowerBetter: true

  queries: [ 'etflex_households_monthly_energy_bill' ]
  hurdles: [ 11, 84, 159, 233 ]
  states:  [ 'very-low', 'low', 'medium', 'high', 'very-high' ]

  name: I18n.t 'scenes.etlite.energy_bill'

  # Help Texts
  helpHeader: -> "props.energy_bill.header"
  helpBody:   -> "props.energy_bill.body"
