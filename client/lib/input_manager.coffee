{ OneToOneInput }   = require 'models/inputs/one_to_one'
{ OneToManyInput }  = require 'models/inputs/one_to_many'
{ ManyToOneInput }  = require 'models/inputs/many_to_one'

{ updateInputs } = require 'lib/api'

currentUpdate = null
pendingUpdate = null

class exports.InputManager extends Backbone.Collection
  @fromScene: (scene) ->
    inputs      = scene.get 'inputs'
    collection  = new InputManager

    for location in inputs
      position = location.position

      for group in location.groups
        group_key = group.key

        for input_definition in group.inputs
          input_definition.position = location.position
          input_definition.group    = group.key

          switch input_definition.type
            when 'one_to_one'
              input = new OneToOneInput input_definition
            when 'one_to_many'
              input = new OneToManyInput input_definition

          collection.add input

          if input_definition.parent
            parent_input = new ManyToOneInput input_definition.parent
            collection.add parent_input

    collection

  getKey: (key) ->
    _.find @models, (input) ->
      input.get('key') == key

  values: ->
    values = {}

    for input in @models
      _.extend values, input.values()
    values

  rawValues: ->
    rawValues = {}

    for input in @models
      _.extend rawValues, input.rawValues()
    rawValues

  persistTo: (scenario) ->
    if ! (@sessionId = scenario.get 'sessionId')
      throw 'Cannot persist inputs to a scenario which has no sessionId'

  # Updates the value of an input. You don't need to call this directly; is
  # used internally by Input::sync.
  #
  # input   - The input whose value is being persisted.
  # options - The options which were passed to Input::sync. Expects an
  #           optional array (or Backbone collection) containing Queries
  #           to be requested once the input value has been saved.
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

      pendingUpdate or= new QueuedUpdate
      pendingUpdate.isRollback = true

      queuedUpdate.rollback()
    else
      # collection = _.values(currentUpdate.inputs)[0].collection
      @trigger 'updateInputsDone'

    if pendingUpdate
      currentUpdate = pendingUpdate
      pendingUpdate = null

      currentUpdate.perform(@sessionId).always(@afterUpdate)
    else
      currentUpdate = null

# QueuedUpdate ---------------------------------------------------------------

# If the user changes multiple sliders in a short period, responses from
# ETengine may arrive in a different order than the requests were sent.
# QueuedUpdate will combine all input changes, and the queries affected, and
# perform them all simultaneously.
#
class QueuedUpdate
  constructor: ->
    @inputs     = {}
    @origValues = {}
    @queries    = {}

    # If isRollback is true, then the update is being used to rollback input
    # values rejected by ETengine. We do not allow a rollback to also
    # rollback, otherwise we may end up in an infinite loop alternating
    # between two invalid input values.
    @isRollback = false

  # Adds an input update to the queue so that it may be performed.
  #
  # input   - The Input model whose value is to be sent to ETEngine.
  # queries - An optional array or Backbone collection containing queries
  #           whose values we want ETEngine to return to us.
  #
  update: (input, queries = []) ->
    console.log 'Called update'
    @inputs = input.collection
    # @inputs[ input.id ]  = input
    @queries[ query.id ] = query for query in (queries?.models or queries)

    # unless @origValues.hasOwnProperty(input.id)
    #   @origValues[ input.id ] = input.previous('value')

  # Sends the HTTP request to ETEngine.
  #
  # sessionId - The current ETEngine session ID.
  #
  perform: (sessionId) ->
    console.log 'Performing update'
    queries  = ( query for own k, query of @queries )
    # inputs   = ( input for own k, input of @inputs  )
    data     = { inputs: @inputs, queries: queries }

    deferred = $.Deferred()

    updateInputs sessionId, data, (err) =>
      (if err? then deferred.reject else deferred.resolve)(err, this)

    return deferred.promise()

  # Restores the inputs to their original values.
  #
  rollback: ->
    if @isRollback then throw 'Cannot rollback a rollback' else
      for own k, input of @inputs
        input.set(value: @origValues[ input.id ])













#
#
#
# { updateInputs } = require 'lib/api'
#
# currentUpdate = null
# pendingUpdate = null
#
# # Since Inputs aren't stored on ETengine using a "proper" REST API,
# # InputManager keeps track of the "user_values" object which it returns,
# # and is used as the persistance layer for Input instances.
# #
# # The values held by InputManager are updated only when Input instances
# # are saved; you should use the inputs collection directly when you want
# # to find the value of an input.
# #
# class exports.InputManager
#
#   # Creates a new InputManager.
#   #
#   # sessionId - The ID of the ETengine session so that the manager can
#   #             persist the input values to the correct URL.
#   #
#   constructor: (@sessionId) ->
#
#   # Reads the value for an input.
#   read: (input) -> throw 'No support for reading input values'
#
#   # Updates the value of an input. You don't need to call this directly; is
#   # used internally by Input::sync.
#   #
#   # input   - The input whose value is being persisted.
#   # options - The options which were passed to Input::sync. Expects an
#   #           optional array (or Backbone collection) containing Queries
#   #           to be requested once the input value has been saved.
#   #
#   update: (input, options) ->
#     if currentUpdate?
#       pendingUpdate or= new QueuedUpdate
#       pendingUpdate.update(input, options?.queries)
#     else
#       currentUpdate = new QueuedUpdate
#       currentUpdate.update(input, options?.queries)
#       currentUpdate.perform(@sessionId).always(@afterUpdate)
#
#   # Called after an update is perform, regardless of the outcome.
#   afterUpdate: (err, queuedUpdate) =>
#     if err?
#       console.error err
#
#       pendingUpdate or= new QueuedUpdate
#       pendingUpdate.isRollback = true
#
#       queuedUpdate.rollback()
#     else
#       collection = _.values(currentUpdate.inputs)[0].collection
#       collection.trigger 'updateInputsDone'
#
#     if pendingUpdate
#       currentUpdate = pendingUpdate
#       pendingUpdate = null
#
#       currentUpdate.perform(@sessionId).always(@afterUpdate)
#     else
#       currentUpdate = null
#
# # QueuedUpdate ---------------------------------------------------------------
#
# # If the user changes multiple sliders in a short period, responses from
# # ETengine may arrive in a different order than the requests were sent.
# # QueuedUpdate will combine all input changes, and the queries affected, and
# # perform them all simultaneously.
# #
# class QueuedUpdate
#   constructor: ->
#     @inputs     = {}
#     @origValues = {}
#     @queries    = {}
#
#     # If isRollback is true, then the update is being used to rollback input
#     # values rejected by ETengine. We do not allow a rollback to also
#     # rollback, otherwise we may end up in an infinite loop alternating
#     # between two invalid input values.
#     @isRollback = false
#
#   # Adds an input update to the queue so that it may be performed.
#   #
#   # input   - The Input model whose value is to be sent to ETEngine.
#   # queries - An optional array or Backbone collection containing queries
#   #           whose values we want ETEngine to return to us.
#   #
#   update: (input, queries = []) ->
#     @inputs[ input.id ]  = input
#     @queries[ query.id ] = query for query in (queries?.models or queries)
#
#     unless @origValues.hasOwnProperty(input.id)
#       @origValues[ input.id ] = input.previous('value')
#
#   # Sends the HTTP request to ETEngine.
#   #
#   # sessionId - The current ETEngine session ID.
#   #
#   perform: (sessionId) ->
#     queries  = ( query for own k, query of @queries )
#     inputs   = ( input for own k, input of @inputs  )
#     data     = { inputs: inputs, queries: queries }
#
#     deferred = $.Deferred()
#
#     updateInputs sessionId, data, (err) =>
#       (if err? then deferred.reject else deferred.resolve)(err, this)
#
#     return deferred.promise()
#
#   # Restores the inputs to their original values.
#   #
#   rollback: ->
#     if @isRollback then throw 'Cannot rollback a rollback' else
#       for own k, input of @inputs
#         input.set(value: @origValues[ input.id ])
