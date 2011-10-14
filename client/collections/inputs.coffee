{ Store } = require 'lib/store'

# Contains all of the Inputs. The main instantiated collection can be found
# on app.collections.inputs.
#
class exports.Inputs extends Backbone.Collection
  model: require('models/input').Input

  # Until ETEngine integration is set up, use HTML5 localStorage to persist
  # input values.
  localStorage: new Store 'inputs'

  # Creates a new Inputs instance with only the models specified in the given
  # array of IDs.
  #
  # ids - An array containing numbers; IDs of Input instances which should be
  #       included in the returned Inputs instance.
  #
  subset: (ids) ->
    new Inputs ( @get(id) for id in ids )
