{ HeaderIcon } = require 'views/props/header_icon'

class exports.TurbinesProp extends HeaderIcon
  @queries: [ 'co2_emissions_per_kwh_electricity' ]
  states:   [ 'wind', 'coal' ]
