api = require 'lib/api'
app = require 'app'

# Exports --------------------------------------------------------------------

# Returns the ETEngine session which corresponds with a scene ID.
#
# "getSession" will always hit ETEngine for the session details, and will
# return the ID of the session. This method is used as part of Scene::start
# and probably shouldn't be called directly unless you know what you're doing.
#
# In all cases, the session will be returned to the callback as the second
# argument. The first argument will be null unless an error occurred.
#
# scenario - The scenario whose session is to be fetched from the Engine. If
#            the scenario has no session ID value, a new session will be
#            created.
#
# queries  - Queries whose results should be fetched with the session.
#
# inputs   - Inputs whose values should be retrieved from ETEngine when
#            restoring an existing session, or sent when creating a new
#            session.
#
# callback - A function run after the session is retrieved.
#
exports.getSession = (scenario, queries, inputs, callback) ->
  queries = queries.models or queries
  inputs  = inputs.models  or inputs

  if existingId = scenario.get 'sessionId'
    if scenario.canStartLocally queries, inputs
      localRestore scenario, queries, inputs, callback
    else
      restoreSession existingId, queries, inputs, callback
  else
    createSession queries, inputs, scenario, callback

# Session Helpers ------------------------------------------------------------

# An abstraction around api::send which hits ETEngine for the basic
# information about a session (country, etc).
fetchSession = (sessionId, queries, callback) ->
  api.updateInputs sessionId, { queries }, (err, result) ->
    if err? then callback(err) else callback null, result

# Requests input_data.json to get the state of the user's Inputs.
fetchUserValues = (sessionId, inputs, callback) ->
  api.send 'get', "#{sessionId}/inputs", callback

# Used to create a new session, pre-initialized with values from ETengine.
createSession = (queries, inputs, scenario, callback) ->
  data = settings:
    end_year: scenario.get('endYear')
    area_code:  scenario.get('country')
    source: 'ETFlex'

  api.send 'post', '', data, (err, sessionData) ->
    return callback(err) if err?

    # "scenario" = post-July ETengine deploy.
    sessionId = sessionData.id

    # The ETengine API does not presently support requesting query results
    # when creating a session. We need to start the session, and _then_
    # fetch the values.
    api.updateInputs sessionId, { queries, inputs }, (err) ->
      if err? then callback(err) else callback(null, sessionId)

# Restores the session state by retrieving it from ETengine.
#
# Currently we have to fetch both the session information and user values
# separately; it would be just marvellous if we could do both in a single
# request. ;-)
restoreSession = (sessionId, queries, inputs, callback) ->
  async.parallel
    # Fetches information about the session.
    session: (cb) -> fetchSession sessionId, queries, cb
    # Fetches the persisted input values.
    values:  (cb) -> fetchUserValues sessionId, inputs, cb

  , (err, result) ->
    return callback(err) if err?

    # Update each of the inputs with the value retrieved from ETEngine.
    for input in inputs
      continue unless inputData = result.values[ input.id ]

      value = if inputData.hasOwnProperty('user')
        inputData.user
      else
        inputData.default

      input.set value: value if value?

    callback null, parseInt(sessionId, 10)

# When a scenario already has a complete set of input and query data, we can
# start the scene without goign to ETengine.
localRestore = (scenario, queries, inputs, callback) ->
  localInputs  = scenario.get 'inputValues'
  localQueries = scenario.get 'queryResults'

  input.set(value: localInputs[input.def.id.toString()]) for input in inputs
  query.set(future: localQueries[query.id]) for query in queries

  callback null, scenario.get('sessionId')
