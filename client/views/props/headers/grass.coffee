{ HeaderIcon } = require 'views/props/header_icon'

class exports.GrassProp extends HeaderIcon
  queries: [ 'etflex_households_co2_emissions_per_household' ]
  hurdles: [ 2.6, 3.4 ]
  states:  [ 'green', 'pale', 'dry' ]

