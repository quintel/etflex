{ updateInputs } = require 'lib/api'

currentUpdate = null
pendingUpdate = null

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
  # sessionId - The ID of the ET-Engine session so that the manager can
  #             persist the input values to the correct URL.
  #
  constructor: (@sessionId) ->

  # Reads the value for an input.
  read: (input) -> throw 'No support for reading input values'

  # Updates the value of an input. You don't need to call this directly; is
  # used internally by Input::sync.
  #
  # input   - The input whose value is being persisted.
  # options - The options which were passed to Input::sync. Expects an
  #           optional array (or Backbone collection) containing Queries
  #           which should be updated once the input value has been saved.
  #
  update: (input, options) ->
    if currentUpdate?
      pendingUpdate or= new QueuedUpdate
      pendingUpdate.update(input, options?.queries)
    else
      currentUpdate = new QueuedUpdate
      currentUpdate.update(input, options?.queries)
      currentUpdate.perform(@sessionId).always(@afterUpdate)

  # Called after an update is perform, regardless of the outcome.
  afterUpdate: (err, queuedUpdate) =>
    if err?
      console.error err
      queuedUpdate.rollback()
    else
      collection = _.values(currentUpdate.inputs)[0].collection
      collection.trigger 'updateInputsDone'

    if pendingUpdate
      currentUpdate = pendingUpdate
      pendingUpdate = null

      currentUpdate.perform(@sessionId).always(@afterUpdate)
    else
      currentUpdate = null

# QueuedUpdate ---------------------------------------------------------------

# If the user changes multiple sliders in a short period, it can occur that
# the responses are returned out of order, and queries are update to incorrect
# values. QueuedUpdate will amalgamate all input changes, and the queries
# affected, and do them all simultaneously when you call perform().
#
class QueuedUpdate
  constructor: ->
    @inputs     = {}
    @origValues = {}
    @queries    = {}

  # Adds an input update to the queue so that it may be performed.
  #
  # input   - The Input model whose value is to be sent to ETEngine.
  # queries - An optional array or Backbone collection containing queries
  #           whose values we want ETEngine to return to us.
  #
  update: (input, queries = []) ->
    @inputs[ input.id ]  = input
    @queries[ query.id ] = query for query in (queries?.models or queries)

    unless @origValues.hasOwnProperty(input.id)
      @origValues[ input.id ] = input.previous('value')

  # Sends the HTTP request to ETEngine.
  #
  # sessionId - The current ETEngine session ID.
  #
  perform: (sessionId) ->
    queries  = ( query for own k, query of @queries )
    inputs   = ( input for own k, input of @inputs  )
    data     = { inputs: inputs, queries: queries }

    deferred = $.Deferred()

    updateInputs sessionId, data, (err) =>
      (if err? then deferred.reject else deferred.resolve)(err, this)

    return deferred.promise()

  # Restores the inputs to their original values.
  #
  rollback: ->
    for own k, input of @inputs
      input.set(value: @origValues[ input.id ])
