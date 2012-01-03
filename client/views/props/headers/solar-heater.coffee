{ HeaderIcon } = require 'views/props/header_icon'

class exports.SolarHeaterProp extends HeaderIcon
  @queries: [ 'share_of_renewable_electricity' ]
  states:   [ 'none', 'heater' ]
  className:  'solar-heater'
