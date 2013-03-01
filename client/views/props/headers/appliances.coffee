{ HeaderIcon } = require 'views/props/header_icon'

class exports.AppliancesProp extends HeaderIcon
  queries: [ 'etflex_households_amount_of_appliances' ]

  hurdles: [ 1400, 1750, 2100, 2450, 2800, 3150, 3400, 3750 ]
  states:  [ 'none', 'extremely_low', 'very_low', 'low', 'medium', 'high', 'very_high', 'extremely_high', 'all' ]


