app = require 'app'

# Scenario keeps track of a user's attempt to complete a scene. Holding on to
# the scene ID, user ID, and the corresponding ET-Engine session ID, it allows
# a user to attempt a scene multiple times, and to share their scenes with
# others.
#
# The session ID is the ET-Engine session ID.
#
class exports.Scenario extends Backbone.Model

  # Returns the URL to the scenario. Raises an error if the scenario ID or
  # scene ID are missing.
  #
  url: ->
    unless @get('sessionId') and @get('scene').id
      throw 'Cannot generate scenario URL when missing ID or scene ID'

    "/scenes/#{ @get('scene').id }/with/#{ @get 'sessionId' }.json"

  # Starts the scenario by fetching th ET-Engine session, then starting the
  # scene. The scene must already exist in the Scenes collection.
  #
  # callback - A function which will be run after the scenari has been set up.
  #            The callback will be provided with the scenario, scene, and
  #            session instances.
  #
  start: (callback) ->
    app.collections.scenes.get( @get('scene').id ).start this, callback

  # Given an inputs and queries collection, sets up events to track changes so
  # that we can persist the values back to ET-Flex.
  #
  updateCollections: ({ queries, inputs }) ->
    queryResults = {}
    inputValues  = {}

    queryResults[ query.id ] = query.get('future') for query in queries.models
    inputValues[ input.id ]  = input.get('value')  for input in inputs.models

    @set { queryResults, inputValues }
    @save()

    true

  # Returns whether the scenario has enough information so that is can be used
  # to directly start a scene without having to hit ETEngine first.
  #
  # queries - The collection of queries which would be restored.
  # inputs  - The collection of inputs which would be restored.
  #
  canStartLocally: (queries, inputs) ->
    localInputs  = @get 'inputValues'
    localQueries = @get 'queryResults'

    return false unless localInputs
    return false unless localQueries

    inputIds  = ( input.def.id for input in inputs )
    queryIds  = ( query.id for query in queries )

    lInputIds = _.map(_.keys(localInputs), parseFloat)

    _.difference(inputIds, lInputIds).length is 0 and
      _.difference(queryIds, _.keys(localQueries)).length is 0

  # Given a user, determines if the user is permitted to change any part of
  # the scene. Currently, only the owner may change the scene.
  #
  # user - The user to test.
  #
  canChange: (user) ->
    user.id and @get('user').id is user.id

  # Don't send the scene information to the server; it doesn't care.
  #
  toJSON: ->
    attributes = _.clone @attributes

    delete attributes.scene
    delete attributes.sessionId
    delete attributes.id
    delete attributes.user

    { scenario: attributes }
