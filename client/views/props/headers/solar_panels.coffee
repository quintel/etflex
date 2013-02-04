{ HeaderIcon } = require 'views/props/header_icon'

# GroundProp swaps the main ground layer between the highly-saturated green
# layer and a darker, less saturated "dried out" version.
#
class exports.SolarPanelsProp extends HeaderIcon
  queries: [ 'etflex_households_solar_pv_installed' ]

  hurdles: [ 33, 66 ]
  states:  [ 'none', 'low', 'high' ]

