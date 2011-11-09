app              = require 'app'
{ getSession }   = require 'lib/session_manager'
{ InputManager } = require 'lib/input_manager'

# Modules are pages such as the ETlite recreation, which have one or more
# inputs, fetch results from ETengine, and display these to the user.
#
# Each module is linked to an ETengine session which performs calculations.
#
class exports.Module extends Backbone.Model
  # Stores an Inputs collection used by the module.
  inputs: null

  # Stores a Query collection used by the module.
  queries: null

  # The ETengine session. null if the module has not yet been started.
  session: null

  # Starts the module by fetching the ETengine session (if one already exists;
  # creates a new session otherwise).

  # callback - A function which will be run after the module has been set up.
  #            The callback will be provided with the Module instance and the
  #            session instance.
  #
  start: (callback) ->
    if @session? then callback(null, @, @session) else

      @queries = app.stencils.queries @dependantQueries()
      @inputs  = app.stencils.inputs  @dependantInputs()

      getSession @id, @queries, (err, session) =>
        if err? then callback(err) else

          # Session::finalizeInputs is the old way of doing things, but
          # necessary until per-module collections are added.
          session.finalizeInputs @inputs

          # Same as above; will be removed once per-module collections are
          # added.
          app.inputManager = new InputManager session

          # Watch for changes to the inputs, and send them back to ETengine.
          @inputs.bind 'change:value', (ipt) => ipt.save {}, queries: @queries

          callback(null, @, @session = session)

  # Returns an array of query IDs used by the module.
  #
  dependantQueries: ->
    ids = _.clone( @get('centerVis')?.queries or [] )

    for visualisation in @get('mainVis') when visualisation.queries?
      ids.push visualisation.queries...

    _.uniq ids

  # Returns an array of inputs IDs used by the module.
  #
  dependantInputs: ->
    _.uniq @get('leftInputs').concat @get('rightInputs')
