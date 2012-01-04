{ HeaderIcon } = require 'views/props/header_icon'

class exports.EnergySourcesProp extends HeaderIcon
  @queries: [ 'share_of_renewable_electricity' ]
  states:   [ 'solar', 'nuclear', 'oil' ]
  className:  'energy-sources'
