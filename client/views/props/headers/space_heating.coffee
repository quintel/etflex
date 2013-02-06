{ HeaderIcon } = require 'views/props/header_icon'

class exports.SpaceHeatingProp extends HeaderIcon
  queries: [ 'etflex_households_heating_technology_in_use' ]

  refresh: (spaceHeatingMethod) ->
    console.log spaceHeatingMethod
    @setState spaceHeatingMethod

