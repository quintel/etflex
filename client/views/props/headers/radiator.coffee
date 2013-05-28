{ HeaderIcon } = require 'views/props/header_icon'

# GroundProp swaps the main ground layer between the highly-saturated green
# layer and a darker, less saturated "dried out" version.
#
class exports.RadiatorProp extends HeaderIcon
  queries: [ 'etflex_households_useful_demand_heat_per_person' ]

  hurdles: [ 3.1, 3.6 ]
  states:  [ 'low', 'medium', 'high' ]

