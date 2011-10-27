app              = require 'app'
{ getSession }   = require 'lib/session_manager'
{ InputManager } = require 'lib/input_manager'

# Scenarios are pages such as the ETlite recreation, which have one or more
# inputs, fetch results from ETengine, and display these to the user.
#
# Each scenario is linked to an ETengine session which performs calculations.
#
class exports.Scenario extends Backbone.Model
  # Stores an Inputs collection used by the scenario.
  inputs: null

  # Stores a Query collection used by the scenario.
  queries: null

  # The ETengine session. null if the Scenario has not yet been started.
  session: null

  # Starts the scenario by fetching the ETengine session (if one already
  # exists; creates a new session otherwise).
  #
  # callback - A function which will be run after the scenario has been set
  #            up. The callback will be provided with the Scenario instance
  #            and the session instance.
  #
  start: (callback) ->
    if @session? then callback(null, @, @session) else

      # Determine which queries are used by the Scenario.
      queryIds = _.clone(@get('centerVis').queries or [])

      for visualisation in @get('mainVis') when visualisation.queries?
        queryIds.concat visualisation.queries

      @queries = app.collections.queries.subset queryIds

      getSession @id, (err, session) =>
        if err? then callback(err) else

          # Session::finalizeInputs is the old way of doing things, but
          # necessary until per-scenario collections are added.
          session.finalizeInputs app.collections.inputs

          # Same as above; will be removed once per-scenario collections are
          # added.
          app.inputManager = new InputManager session

          # Watch for changes to the inputs, and send them back to ETengine.
          app.collections.inputs.bind 'change:value', (input) =>
            input.save {}, queries: @queries

          # If the view has any queries, we need to fetch their values from
          # ETengine, I intend to merge this into "getSession", so this is
          # just a hack to get things up-and-running.
          if @queries.length > 0
            session.updateInputs [], @queries, (err) =>
              if err? then callback(err) else
                callback(null, @, @session = session)
          else
            callback(null, @, @session = session)
