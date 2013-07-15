{ HeaderIcon } = require 'views/props/header_icon'

class exports.AppliancesGirlProp extends HeaderIcon
  queries: [ 'etflex_households_amount_of_appliances' ]

  # Must be no lower than the "high" hurdle in AppliancesProp.
  hurdles: [ 2800 ]
  states:  [ 'reading', 'browsing' ]
