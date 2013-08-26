{ HeaderIcon } = require 'views/props/header_icon'

class exports.InsulationProp extends HeaderIcon
  queries: [ 'etflex_households_insulation_level' ]

  hurdles: [ 0.75, 1.00, 1.25, 1.75, 2.25, 2.75 ]
  states:  [ 'extremely_low', 'very_low', 'low', 'medium', 'high', 'very_high', 'extremely_high' ]

