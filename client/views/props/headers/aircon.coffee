{ HeaderIcon } = require 'views/props/header_icon'

class exports.AirconProp extends HeaderIcon
  queries: [ 'etflex_households_cooling_demand' ]
  hurdles: [ 3, 7 ]

  states: [ 'none', 'living_room', 'whole_house' ]
