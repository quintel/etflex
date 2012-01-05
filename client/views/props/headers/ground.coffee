{ HeaderIcon } = require 'views/props/header_icon'

# GroundProp swaps the main ground layer between the highly-saturated green
# layer and a darker, less saturated "dried out" version.
#
class exports.GroundProp extends HeaderIcon
  @queries: [ 'co2_emission_total' ]
  states:   [ 'green', 'dry' ]

  # Query result is in kilograms. Divide by 1000 to get tons, then 1000000
  # to get Mtons.
  refresh: (value) -> super value / 1000000000
