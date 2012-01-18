{ HeaderIcon } = require 'views/props/header_icon'

class exports.TurbinesProp extends HeaderIcon
  @queries: [ 'share_of_total_costs_assigned_to_wind' ]
  states:   [ 'wind', 'coal' ]
