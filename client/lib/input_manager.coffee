{ OneToOneInput }   = require 'models/inputs/one_to_one'
{ OneToManyInput }  = require 'models/inputs/one_to_many'
{ ManyToOneInput }  = require 'models/inputs/many_to_one'

{ Locations }       = require 'collections/locations'
{ Location }        = require 'models/location'
{ Group }           = require 'models/group'

class exports.InputManager extends Backbone.Model
  constructor: (scene_inputs) ->
    @locations  = new Locations
    @inputs     = {}

    for location_definition in scene_inputs
      location = new Location position: location_definition.position
      @locations.add location

      for group_definition in location_definition.groups

        group = new Group key: group_definition.key
        location.get('groups').add group

        for input_definition in group_definition.inputs

          input_definition.position = location_definition.position
          input_definition.group    = group_definition.key

          switch input_definition.type
            when 'one_to_one'   then input = new OneToOneInput input_definition
            when 'one_to_many'  then input = new OneToManyInput input_definition

          group.get('inputs').add input

          @inputs[input_definition.key] = input

          # Instanciate the ManyToOne input in case it exists. It doesn't need
          # to go into the collection as it doesn't show on the UI. This is
          # just for reference purposes.
          if input_definition.parent
            @inputs[input_definition.parent.key] = new ManyToOneInput input_definition.parent, @

  location: (position) ->
    _.find @locations.models, (location) ->
      location.get('position') == position

  values: ->
    values = {}

    for key, input of @inputs
      _.extend values, input.values()
    values

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
