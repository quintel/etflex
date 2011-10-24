{ createSession } = require 'models/session'

# Scenarios are pages such as the ETlite recreation, which have one or more
# inputs, fetch results from ETengine, and display these to the user.
#
# Each scenario is linked to an ETengine session which performs calculations.
#
class Scenario extends Backbone.Model
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
    if @session then callback(null, this, session) else
      createSession @get('id'), (err, session) =>
        if err? then callback(err) else callback(null, @, @session = session)
