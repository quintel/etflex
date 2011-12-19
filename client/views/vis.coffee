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

# Given a query value, returns which "state" that value corresponds to based
# on the array of "hurdles" which the instance was initialized with. If the
# instance does not have a "states" attribute, or @options does not have a
# "hurdles" attribute, then "null" will be returned.
#
# value - The query value.
#
exports.hurdleState = (view, value) ->
  return null unless view.options?.hurdles and view.states?

  _.detect view.states, (state, index) =>
    # If no such hurdle value exists, it means we have run out... the value
    # is higher than the last hurdle value; use the last state.
    view.options.hurdles[ index ] is undefined or
      # Is the value less than the hurdle value (we check each hurdle in
      # ascending order)?
      value < view.options.hurdles[ index ]
