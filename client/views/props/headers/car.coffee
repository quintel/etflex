{ HeaderIcon } = require 'views/props/header_icon'

class exports.CarProp extends HeaderIcon
  @queries: [ 'number_of_electric_cars' ]
  states:   [ 'suv', 'eco' ]
