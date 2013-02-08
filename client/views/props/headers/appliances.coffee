{ HeaderIcon } = require 'views/props/header_icon'

class exports.AppliancesProp extends HeaderIcon
  queries: [ 'etflex_households_amount_of_appliances' ]

  hurdles: [ 2040, 2502, 2964, 3426, 3888, 4350, 4812, 5200 ]
  states:  [ 'none', 'extremely_low', 'very_low', 'low', 'medium', 'high', 'very_high', 'extremely_high', 'all' ]


