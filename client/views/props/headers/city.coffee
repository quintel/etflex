{ HeaderIcon } = require 'views/props/header_icon'

# Creates a new CityProp, used to change between small, medium and large
# cities in the modern theme header. Be sure to provide an "el" option
# containing the element in the header.
#
class exports.CityProp extends HeaderIcon
  @queries: [ 'co2_emission_total' ]
  states:   [ 'small', 'medium', 'large' ]

  # Query result is in kilograms. Divide by 1000 to get tons, then 1000000
  # to get Mtons.
  refresh: (value) -> super value / 1000000000
