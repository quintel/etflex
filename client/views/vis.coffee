# Holds all of the Visualisation classes with their "key" names, used in the
# database to identify the class.

visualisations =
  'co2-emissions': require('views/vis/co2_emissions').CO2EmissionsView
  'costs':         require('views/vis/costs').CostsView
  'icon':          require('views/vis/icon').IconVisualisation
  'renewables':    require('views/vis/renewables').RenewablesView
  'supply-demand': require('views/vis/supply_demand').SupplyDemandView

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
