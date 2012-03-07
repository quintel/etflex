{ HeaderIcon }  = require 'views/props/header_icon'
{ GroundProp }  = require 'views/props/headers/ground'
{ hurdleState } = require 'views/props'

class exports.EcoBuildingsProp extends HeaderIcon
  queries: [ 'renewability' ]

  hurdles: [ 0.15 ]
  states:  [ 'coal', 'eco' ]

  # After running refresh which chooses between the eco building and quarry,
  # use the renewables query to match the style to the ground layer (bright
  # green or desaturated green.
  refresh: (renewables) ->
    stateName = hurdleState(this, renewables)

    if renewables <= GroundProp::hurdles[0]
      stateName = "#{ stateName }-dry"
    else
      stateName = "#{ stateName }-green"

    @setState stateName
