{ Input } = require 'models/input'
{ Store } = require 'lib/store'

# Contains all of the Inputs. The main instantiated collection can be found
# on app.collections.inputs.
#
class exports.Inputs extends Backbone.Collection
  model: require('models/input').Input

  # Until ETEngine integration is set up, use HTML5 localStorage to persist
  # input values.
  localStorage: new Store 'inputs'

  # Retrieves an Input by it's localised name. Requires iterating through the
  # whole collection ( O(N) ), so this exists only to serve the ETLite
  # recreation, and will be removed once ETEngine integration is complete.
  #
  # name - The localised name for the Input you want fetching.
  #
  # Returns an Input, or undefined if none match the given name.
  #
  getByName: (name) ->
    @find (input) -> input.def.name is name
