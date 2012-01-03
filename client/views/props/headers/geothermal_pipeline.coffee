{ HeaderIcon } = require 'views/props/header_icon'

class exports.GeothermalPipelineProp extends HeaderIcon
  @queries: [ 'share_of_renewable_electricity' ]
  states:   [ 'pipeline', 'none', 'geothermal' ]
  className:  'geothermal-pipeline'
