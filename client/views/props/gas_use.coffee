{ IconDashboardWithNeedleProp } = require 'views/props/dashboard'

class exports.GasUseView extends IconDashboardWithNeedleProp

  className: 'gas-use'
  lowerBetter: true

  queries: [ 'etflex_households_final_demand_network_gas_per_household' ]
  hurdles: [ 45, 455, 870, 1284, 1698, 2112 ]
  states:  [ 'extremely-low', 'very-low', 'low', 'medium', 'high', 'very-high', 'extremely-high' ]

  name: I18n.t 'scenes.etlite.gas_use'

  # Help Texts
  helpHeader: -> "props.gas_use.header"
  helpBody:   -> "props.gas_use.body"
