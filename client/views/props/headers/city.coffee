{ HeaderIcon } = require 'views/props/header_icon'

# Creates a new CityProp, used to change between small, medium and large
# cities in the modern theme header. Be sure to provide an "el" option
# containing the element in the header.
#
class exports.CityProp extends HeaderIcon
  queries: [ 'number_of_electric_cars' ]

  hurdles: [ 2000000 ]
  states:  [ 'large', 'medium' ]
