{ IconDashboardProp } = require 'views/props/dashboard'

class exports.SustainableEnergyView extends IconDashboardProp
  className: 'sustainable-energy'

  queries: [ 'etflex_households_percentage_renewable_energy_per_household' ]
  hurdles: [ 25, 50, 75 ]
  states:  [ 'low', 'medium', 'high', 'very-high' ]

  name: I18n.t 'scenes.etlite.sustainable_energy'

  # Help Texts
  helpHeader: -> "props.sustainable_energy.header"
  helpBody:   -> "props.sustainable_energy.body"
