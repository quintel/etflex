{ HeaderIcon } = require 'views/props/header_icon'

class exports.HotWaterProp extends HeaderIcon
  queries: [ 'hot_water_demand_households' ]

  hurdles: [ 85, 135 ]
  states:  [ 'none', 'low', 'high' ]

