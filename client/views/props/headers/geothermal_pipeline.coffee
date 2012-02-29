{ HeaderIcon } = require 'views/props/header_icon'

class exports.GeothermalPipelineProp extends HeaderIcon
  queries: [ 'share_of_heat_pump_in_heat_produced_in_households',
             'share_of_heat_demand_saved_by_extra_insulation_in_existing_households' ]

  refresh: (heatpump, insulation) ->
    if heatpump > 0.3
      @setState 'geothermal'
    else if insulation > 0.4
      @setState 'none'
    else
      @setState 'pipeline'
