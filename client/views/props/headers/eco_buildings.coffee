{ HeaderIcon }  = require 'views/props/header_icon'
{ hurdleState } = require 'views/props'

class exports.EcoBuildingsProp extends HeaderIcon
  @queries: [ 'renewable_electricity_share', 'total_co2_emissions' ]
  states:   [ 'coal', 'eco' ]

  # After running refresh which chooses between the eco building and quarry,
  # use the CO2 query to match the style to the ground layer (bright green or
  # desaturated green.
  refresh: (renewables, co2) ->
    stateName = hurdleState(this, renewables)

    if ( co2 / 1000000000 ) >= 155
      stateName = "#{ stateName }-dry"
    else
      stateName = "#{ stateName }-green"

    @setState stateName
