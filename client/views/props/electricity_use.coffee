{ IconDashboardWithNeedleProp } = require 'views/props/dashboard'

class exports.ElectricityUseView extends IconDashboardWithNeedleProp

  className: 'electricity-use'
  lowerBetter: true

  queries: [ 'etflex_households_final_demand_electricity_per_household' ]
  hurdles: [ 1800, 3491, 5345, 7200, 9054, 10909 ]
  states:  [ 'extremely-low', 'very-low', 'low', 'medium', 'high', 'very-high', 'extremely-high' ]

  name: I18n.t 'scenes.etlite.electricity_use'

  # Help Texts
  helpHeader: -> "props.electricity_use.header"
  helpBody:   -> "props.electricity_use.body"
