# Contains all of the Inputs. The main instantiated collection can be found
# on app.collections.inputs.
#
class exports.Inputs extends Backbone.Collection
  model: require('models/input').Input
