{ InputManager } = require 'lib/input_manager'

# Retrieves the starting value of an input based on the result returned by
# ETengine. Prefers values set by the user, but falls back to the input
# default otherwise.
#
valueFrom = (data) ->
  return null unless data?

  if data.hasOwnProperty('user_value')
    data.user_value
  else
    data.start_value

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
    return true if @manager?

    @manager = new InputManager session
    values   = session.get 'userValues'

    for input in @models
      if (value = valueFrom values[ input.id ])?
        input.set value: value
