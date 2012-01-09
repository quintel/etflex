{ HeaderIcon }  = require 'views/props/header_icon'
{ hurdleState } = require 'views/props'

class exports.EcoBuildingsProp extends HeaderIcon
  @queries: [ 'share_of_renewable_electricity', 'co2_emission_total' ]
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
