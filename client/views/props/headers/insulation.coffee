{ HeaderIcon } = require 'views/props/header_icon'

class exports.InsulationProp extends HeaderIcon
  queries: [ 'etflex_households_insulation_level' ]

  hurdles: [ 1.28, 1.56, 1.84, 2.12, 2.4, 2.68 ]
  states:  [ 'extremely_low', 'very_low', 'low', 'medium', 'high', 'very_high', 'extremely_high' ]

