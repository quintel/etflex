# Holds all of the Prop classes with their "key" names, used in the database
# to identify the class.

PROPS    = {}
MAP      = require 'lib/prop_map'

humanize = require 'lib/humanize'

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
  hurdles = view.hurdles or view.options?.hurdles

  return null unless hurdles and view.states?

  _.detect view.states, (state, index) =>
    # If no such hurdle value exists, it means we have run out... the value
    # is higher than the last hurdle value; use the last state.
    hurdles[ index ] is undefined or
      # Is the value less than the hurdle value (we check each hurdle in
      # ascending order)?
      value < hurdles[ index ]

# Given the localized description of a prop, pre-parses the text to add query
# values where applicable.
#
# E.g.: "You emit (Q:total_co2_emissions) tonnes of CO<sub>2</sub>"
#
# Query values are inserted using the pattern (Q:query_key) with the number
# being nicely formatted by humanize::number.
#
# After the query key, you may add a space followed by a period (present or
# future) to specify whether to show the value from the present graph, or the
# future graph. Omitting this will default to the future graph.
#
exports.insertQueryData = (raw, queries) ->
  unless raw.match (/\(Q:/) then raw else
    raw.replace /\(Q:([^)]+)\)/g, (ignore, data) =>
      split = data.split(' ')
      queries.get(split[0])?.formatted(split[1] or 'future')
