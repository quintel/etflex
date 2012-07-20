app = require 'app'
api = require 'lib/api'

{ createUser } = require 'models/user'
{ getSession } = require 'lib/engine'

{ Inputs }     = require 'collections/inputs'
{ Queries }    = require 'collections/queries'

# Scenario keeps track of a user's attempt to complete a scene. Holding on to
# the scene ID, user ID, and the corresponding ETengine session ID, it allows
# a user to attempt a scene multiple times, and to share their scenes with
# others.
#
# The session ID is the ETengine session ID.
#
class exports.Scenario extends Backbone.Model
  idAttribute: 'sessionId'

  constructor: (attributes) ->
    attributes.country   or= 'nl'
    attributes.endYear   or= 2030
    attributes.showScore or= true

    super

  # Returns the URL to the scenario. Raises an error if the scenario ID or
  # scene ID are missing.
  #
  url: ->
    unless @get('sessionId') and @get('scene').id
      throw 'Cannot generate scenario URL when missing ID or scene ID'

    "/scenes/#{ @get('scene').id }/with/#{ @get 'sessionId' }.json"

  # Starts the scenario by fetching the ETengine session, then starting the
  # scene. The scene must already exist in the Scenes collection.
  #
  # callback - A function which will be run after the scenari has been set up.
  #            The callback will be provided with the scenario, scene, and
  #            session instances.
  #
  start: (callback) ->
    app.collections.scenes.get( @get('scene').id ).start this, (err, scene) =>
      return callback(err) if err

      @scene   or= scene
      @queries or= new Queries({ id: id } for id in @scene.dependantQueries())
      @inputs  or= new Inputs @scene.get('inputs')

      isNewScenario = not @get('sessionId')?

      # Fetch the ETengine session. This may return instantaneously if we
      # already have all the data we need without having to send a request to
      # the Engine.
      getSession this, @queries, @inputs, (err, sessionId) =>
        return callback(err) if err

        @inputs.initializeBalancers()

        this.set { sessionId }

        # Required so that changes to inputs can be sent back to the Engine.
        @inputs.persistTo this

        # Watch for changes to the inputs and send them back to the Engine.
        @inputs.on 'change:value', @onInputChange

        # Changes to the scenario end year or country need to be saved back
        # to both ETflex and ETengine.
        @on 'change', @onSettingsChange

        # Returns input value and query information to ETflex when results
        # are received from ETengine.
        @inputs.on 'updateInputsDone', @onEngineResponse

        callback null, scene, this

        # New scenarios need to be saved back to the ETflex server.
        @inputs.trigger 'updateInputsDone' if isNewScenario

  # Cleans up when the scenario is no longer beign displayed to the user.
  stop: ->
    @inputs.off 'change:value',     @onInputChange
    @inputs.off 'updateInputsDone', @onEngineResponse

    @off 'change', @onSettingsChange

  # Returns if any of the inputs have been moved by the user.
  isDefault: ->
    # Ignore differences in hidden inputs used purely for balancing.
    originals = _.filter @scene.get('inputs'), (orig) ->
      orig.location isnt '$internal'

    not _.any originals, (original) =>
      original.start isnt @inputs.get(original.remoteId).get('value')

  # Given an inputs and queries collection, sets up events to track changes so
  # that we can persist the values back to ETflex.
  #
  updateCollections: ({ queries, inputs }) ->
    queryResults = {}
    inputValues  = {}

    if queries?.length
      for query in queries.models
        queryResults[ query.id ] = query.get('future')

      @set { queryResults }

    if inputs?.length
      for input in inputs.models
        inputValues[ input.id ] = input.get('value')

      @set { inputValues }

    @save()

    true

  # Run after one of the settings attributes (end year, country) has changed,
  # and persists the values back to both ETFlex and ETEngine.
  #
  # queries - A collection of queries whose results should be fetched /
  #           updated when the settings are changed.
  #
  saveSettings: (queries) ->
    data =
      queries:    queries
      settings: { endYear: @get('endYear'), country: @get('country') }

    # Update ETengine
    api.updateInputs @get('sessionId'), data, (err) =>
      if err?
        @set {
          endYear: @previous 'endYear'
          country: @previous 'country'
        }, silent: true
      else
        # Update ETflex
        @updateCollections queries: queries

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
    user.id and createUser(@get('user') or {}).id is user.id

  # Don't send the scene information to the server; it doesn't care.
  #
  toJSON: ->
    attributes = _.clone @attributes

    if not attributes.guestName and @get('user').name?.length
      attributes.guestName = @get('user').name

    delete attributes.scene
    delete attributes.sessionId
    delete attributes.id
    delete attributes.user

    { scenario: attributes }

  # "start" Events -----------------------------------------------------------

  # Triggered when the user moves an input. Saves the value to ETengine.
  onInputChange: (input) =>
    # We ignore inputs which are internal, since changes to their values are
    # the result of balancing. These will be sent to ETengine with the
    # "master" (changed) input, so no explicit save is required.
    input.save {}, { @queries } unless input.isInternal()

  # Saves changes to the scenario when the user edits the end year or country.
  onSettingsChange: =>
    if @hasChanged('endYear') or @hasChanged('country')
      @saveSettings @queries if @canChange app.user

  # Saves the input and query values back to the ETflex server after receivng
  # a response from ETengine.
  onEngineResponse: =>
    @updateCollections { @inputs, @queries } if @canChange app.user
