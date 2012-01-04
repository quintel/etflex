{ updateInputs } = require 'lib/session_manager'

# Since Inputs aren't stored on ETengine using a "proper" REST API,
# InputManager keeps track of the "user_values" object which it returns,
# and is used as the persistance layer for Input instances.
#
# The values held by InputManager are updated only when Input instances
# are saved; you should use the inputs collection directly when you want
# to find the value of an input.
#
class exports.InputManager

  # Creates a new InputManager.
  #
  # session       - An instance of the Session model. Required so that
  #                 InputManager can persist new values to the correct URL.
  # initialValues - An object mapping input ID keys to their initial values.
  #
  constructor: (@session) ->
    @values = {}

    for own key, data of @session.get 'userValues'
      @values[key] = data.user_value or data.start_value

  # Reads the value for an input.
  read: (input) -> @values[ input.get 'id' ]

  # Updates the value of an input. You don't need to call this directly; is
  # used internally by Input::sync.
  #
  # input   - The input whose value is being persisted.
  # options - The options which were passed to Input::sync. Expects an
  #           optional array (or Backbone collection) containing Queries
  #           which should be updated once the input value has been saved.
  #
  update: (input, options) ->
    # Update the local copy of the input.
    @values[ input.get 'id' ] = input.get 'value'

    data = inputs: [input], queries: options?.queries, sanitize_groups: true

    # Then persist it back to ETengine.
    updateInputs @session.id, data, (err) ->
      if err? then console.error(err) else
        # TODO Update the input(s) to the returned values.
        true
