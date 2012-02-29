{ HeaderIcon } = require 'views/props/header_icon'

class exports.EnergySourcesProp extends HeaderIcon
  queries: [ 'total_electricity_produced',
             'electricity_produced_from_uranium'
             'electricity_produced_from_solar'
             'electricity_produced_from_oil' ]

  refresh: (total, nuclear, solar, oil) ->
    if nuclear / total > 0.08
      @setState 'nuclear'
    else if solar / total > 0.001
      @setState 'solar'
    else
      @setState 'oil'
