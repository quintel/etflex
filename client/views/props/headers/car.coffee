{ HeaderIcon } = require 'views/props/header_icon'

class exports.CarProp extends HeaderIcon
  @queries: [ 'share_of_renewable_electricity' ]
  states:   [ 'suv', 'eco' ]
