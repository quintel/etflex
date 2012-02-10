{ HeaderIcon } = require 'views/props/header_icon'

# Creates a new CityProp, used to change between small, medium and large
# cities in the modern theme header. Be sure to provide an "el" option
# containing the element in the header.
#
class exports.CityProp extends HeaderIcon
  @queries: [ 'number_of_electric_cars' ]
  states:   [ 'medium', 'large' ]

  # Query result is in megajoules. Divide by 1000 to get giga, 1000 to get tera
  # then 1000 to get peta.
  refresh: (value) -> super value / 1000000000
