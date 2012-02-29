{ HeaderIcon } = require 'views/props/header_icon'

# GroundProp swaps the main ground layer between the highly-saturated green
# layer and a darker, less saturated "dried out" version.
#
class exports.GroundProp extends HeaderIcon
  queries: [ 'renewability' ]

  hurdles: [ 0.06 ]
  states:  [ 'dry', 'green' ]
