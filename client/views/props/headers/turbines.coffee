{ HeaderIcon } = require 'views/props/header_icon'

class exports.TurbinesProp extends HeaderIcon
  queries: [ 'share_of_total_costs_assigned_to_wind' ]
  hurdles: [ 0.01 ]
  states:  [ 'coal', 'wind' ]
