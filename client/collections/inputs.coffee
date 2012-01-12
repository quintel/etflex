{ InputManager } = require 'lib/input_manager'

# Contains all of the Inputs. The main instantiated collection can be found
# on app.collections.inputs.
#
class exports.Inputs extends Backbone.Collection
  model: require('models/input').Input

  # Sets the session to which the inputs contained in the collection belong.
  #
  # Sets the @manager variable so that changes to the inputs may be persisted
  # back to ETengine.
  #
  # Sets the value of all the  inputs to the values contained in the session;
  # but only if you haven't run setSession previously. Running setSession more
  # than once will be ignored.
  #
  setSession: (session) ->
    @manager = new InputManager session
