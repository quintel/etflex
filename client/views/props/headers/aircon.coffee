{ HeaderIcon } = require 'views/props/header_icon'

class exports.AirconProp extends HeaderIcon
  queries: [ 'etflex_households_cooling_demand' ]
  hurdles: [ 2, 4 ]

  states: [ 'none', 'living_room', 'whole_house' ]
