{ HeaderIcon }  = require 'views/props/header_icon'
{ hurdleState } = require 'views/props'

class exports.EcoBuildingsProp extends HeaderIcon
  @queries: [ 'renewable_electricity_share' ]
  states:   [ 'coal', 'eco' ]

  # After running refresh which chooses between the eco building and quarry,
  # use the renewables query to match the style to the ground layer (bright
  # green or desaturated green.
  refresh: (renewables) ->
    stateName = hurdleState(this, renewables)

    if renewables <= 0.075
      stateName = "#{ stateName }-dry"
    else
      stateName = "#{ stateName }-green"

    @setState stateName
