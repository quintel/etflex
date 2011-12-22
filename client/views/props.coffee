# Holds all of the Prop classes with their "key" names, used in the database
# to identify the class.

# Exports --------------------------------------------------------------------

# Returns the prop whose key is "name".
#
# Example:
#
#   getProp 'supply-demand'
#   # => SupplyDemand
#
exports.getProp = (name) ->
  if props.hasOwnProperty name
    props[name]
  else
    throw "No such prop: #{name}"

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

# ----------------------------------------------------------------------------

# This must go after all exports.
props =
  'co2-emissions': require('views/props/co2_emissions').CO2EmissionsView
  'costs':         require('views/props/costs').CostsView
  'icon':          require('views/props/icon').IconProp
  'renewables':    require('views/props/renewables').RenewablesView
  'supply-demand': require('views/props/supply_demand').SupplyDemandView

  # Header Props.
  'car':           require('views/props/headers/car').CarProp
  'city':          require('views/props/headers/city').CityProp
  'eco-buildings': require('views/props/headers/eco_buildings').EcoBuildingsProp
  'turbines':      require('views/props/headers/turbines').TurbinesProp
