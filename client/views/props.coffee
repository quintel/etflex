# Holds all of the Prop classes with their "key" names, used in the database
# to identify the class.

PROPS = {}
MAP   = require 'lib/prop_map'

# Helpers --------------------------------------------------------------------

loadProp = ({ path, klass }) ->
  try
    require("views/props/#{path}")[klass]
  catch e
    throw "No such file: views/props/#{path}"

# Exports --------------------------------------------------------------------

# Returns the prop whose key is "name".
#
# Example:
#
#   getProp 'supply-demand'
#   # => SupplyDemand
#
exports.getProp = (name) ->
  PROPS[name] or= loadProp MAP[name]
  PROPS[name]

# Given a query value, returns which "state" that value corresponds to based
# on the array of "hurdles" which the instance was initialized with. If the
# instance does not have a "states" attribute, or @options does not have a
# "hurdles" attribute, then "null" will be returned.
#
# view  - The prop view instance.
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

# A new version of hurdleState which determines the state of a prop by using
# percentage-based hurdle values -- instead of explicit values -- using the
# query extrema provided by the server.
#
# query   - The query ID whose value is being used to get the hurdle state.
# extrema - An array containing two elements - the minimum and maximum values
#           for the query in the current scenario region.
# value   - The query value
#
# TODO Should provide the hurdle and state values explicitly instead of
#      passing a view instance.
#
exports.hurdleStateNew = (view, [ min, max ], value) ->
  unless min? and max? then null else
    exports.hurdleState view, ( value - min ) / ( max - min )
