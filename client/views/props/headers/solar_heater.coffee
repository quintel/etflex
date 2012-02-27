{ HeaderIcon } = require 'views/props/header_icon'

class exports.SolarHeaterProp extends HeaderIcon
  @queries: [ 'share_of_solar_boiler_in_hot_water_produced_in_households' ]

  hurdles:  [ 0.25 ]
  states:   [ 'none', 'heater' ]
