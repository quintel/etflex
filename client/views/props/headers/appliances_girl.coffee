{ HeaderIcon } = require 'views/props/header_icon'

class exports.AppliancesGirlProp extends HeaderIcon
  queries: [ 'etflex_households_amount_of_appliances' ]

  hurdles: [ 3750 ]
  states:  [ 'reading', 'browsing' ]
