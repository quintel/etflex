{ HeaderIcon } = require 'views/props/header_icon'

class exports.TurbinesProp extends HeaderIcon
  @queries: [ 'share_of_renewable_electricity' ]
  states:   [ 'coal', 'wind' ]
