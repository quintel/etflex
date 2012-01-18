{ HeaderIcon } = require 'views/props/header_icon'

class exports.GeothermalPipelineProp extends HeaderIcon
  @queries: [ 'share_of_heat_pump_in_heat_production_in_households' ]
  states:   [ 'pipeline', 'none', 'geothermal' ]
