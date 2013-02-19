{ HeaderIcon } = require 'views/props/header_icon'

# GroundProp swaps the main ground layer between the highly-saturated green
# layer and a darker, less saturated "dried out" version.
#
class exports.RadiatorProp extends HeaderIcon
  queries: [ 'etflex_households_heat_demand_per_person' ]

  hurdles: [ -0.3, 0.8 ]
  states:  [ 'low', 'medium', 'high' ]

