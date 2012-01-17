{ InputManager } = require 'lib/input_manager'

# Contains all of the Inputs. The main instantiated collection can be found
# on app.collections.inputs.
#
class exports.Inputs extends Backbone.Collection
  model: require('models/input').Input

  # Sets the session to which the inputs contained in the collection belong.
  #
  # scenario - The ET-Engine scenario to which the input values should be sent
  #            when changed.
  #
  persistTo: (scenario) ->
    if sessionId = scenario.get 'sessionId'
      @manager = new InputManager sessionId
    else
      throw 'Cannot persist inputs to a scenario which has no sessionId'
