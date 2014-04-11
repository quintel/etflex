{ HeaderIcon } = require 'views/props/header_icon'

class exports.AppliancesProp extends HeaderIcon
  queries: [ 'etflex_households_amount_of_appliances' ]

  # If you update these hurdles, you also need to update the hurdles in
  # AppliancesGirlProp and AppliancesManProp.
  hurdles: [ 2050, 2400, 2600, 2900, 3350, 3800, 4300, 4800 ]
  states:  [ 'none', 'extremely_low', 'very_low', 'low', 'medium', 'high', 'very_high', 'extremely_high', 'all' ]


