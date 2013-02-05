{ HeaderIcon } = require 'views/props/header_icon'

class exports.LightingProp extends HeaderIcon
  queries: [ 'etflex_households_lighting_technology_in_use' ]

  refresh: (lightingTechnology) ->
    console.log lightingTechnology
    @setState lightingTechnology
