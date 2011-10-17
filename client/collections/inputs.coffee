# Contains all of the Inputs. The main instantiated collection can be found
# on app.collections.inputs.
#
class exports.Inputs extends Backbone.Collection
  model: require('models/input').Input

  # Creates a new Inputs instance with only the models specified in the given
  # array of IDs.
  #
  # ids - An array containing numbers; IDs of Input instances which should be
  #       included in the returned Inputs instance.
  #
  subset: (ids) ->
    new Inputs ( @get(id) for id in ids )
