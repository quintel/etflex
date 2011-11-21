# Holds all of the Visualisation classes with their "key" names, used in the
# database to identify the class.

visualisations =
  co2Emissions: require('vis/co2_emissions').CO2Emissions
  costs:        require('vis/costs').Costs
  icon:         require('vis/icon').Icon
  renewables:   require('vis/renewables').Renewables
  supplyDemand: require('vis/supply_demand').SupplyDemand

# Exports --------------------------------------------------------------------

# Returns the visualisation whose key is "name".
#
# Example:
#
#   getVisualisation 'supply-demand'
#   # => SupplyDemand
#
exports.getVisualisation = (name) ->
  if visualisations.hasOwnProperty name
    visualisations[name]
  else
    throw "No such visualisation: #{name}"
