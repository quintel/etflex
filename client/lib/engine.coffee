# Each scene uses a separate ETEngine session so that the inputs from one
# scene don't affect the outcome of another. SessionManager keeps track of
# each scene ID and the ETEngine session it uses.

api         = require 'lib/api'
{ Session } = require 'models/session'

# Exports --------------------------------------------------------------------

# Returns the ETEngine session which corresponds with a scene ID.
#
# "getSession" will always hit ETEngine for the session details, and will
# return a new Session. This method is used in conjunction with
# Scene::start and probably shouldn't be celled directly unless you know
# what you're doing.
#
# In all cases, the session will be returned to the callback as the second
# argument. The first argument will be null unless an error occurred.
#
# sceneId  - A number which uniquely identifies the session.
# queries  - Queries whose results should be fetched with the session.
# callback - A function which is run after the session is retrieved.
#
exports.getSession = (sceneId, queries, inputs, callback) ->
  lsKey = "ete.#{sceneId}"

  queries = queries.models or queries
  inputs  = inputs.models  or inputs

  if existingId = localStorage.getItem lsKey
    restoreSession existingId, queries, inputs, (err, session) ->
      if err? and err is 'Not Found'
        # Session was missing. Create a new one.
        localStorage.removeItem lsKey
        exports.getSession sceneId, queries, inputs, callback
      else if err?
        callback err
      else
        # Success!
        callback null, session
  else
    createSession queries, inputs, (err, session) ->
      if err? then callback(err) else
        localStorage.setItem lsKey, session.id
        callback null, session

# Session Helpers ------------------------------------------------------------

# An abstraction around api::send which hits ETEngine for the basicinformation
# about a session (country, etc).
#
# sessionId - The ID of the session being fetched from ETengine.
# queries   - Queries whose results should be fetched with the session.
# callback  - Is run with the error or retrieved session data.
#
fetchSession = (sessionId, queries, callback) ->
  api.updateInputs sessionId, { queries }, (err, result) ->
    if err? then callback(err) else callback null, result

# Hits user_values.json to get the state of the user's Inputs.
#
# sessionId - The ID of the ETengine session whose values are to be retrieved.
# inputs    - The inputs whose values are to be retrieved.
# callback  - Is called with the parsed values.
#
fetchUserValues = (sessionId, inputs, callback) ->
  inputKeys = ( input.def.key for input in inputs )

  api.send "#{sessionId}/input_data", inputs: inputKeys, callback

# Used to create a new Session instance, pre-initialized with values from
# ETengine. Use this in preference over `new Session` since creating a session
# explicitly will not actually create a session on ETengine.
#
# See `initSession`.
#
createSession = (queries, inputs, callback) ->
  fetchSession 'new', null, (err, sessionData) ->
    return callback(err) if err?

    sessionId = parseInt(sessionData.api_scenario.id, 10)

    # The ETengine API does not presently support requesting query results
    # when creating a session. We need to start the session, and _then_
    # fetch the values.
    api.updateInputs sessionId, { queries, inputs }, (err, userValues) ->
      if err? then callback(err) else
        callback null, new Session(id: sessionId)

# Restores the session state by retrieving it from ETengine.
#
# See `initSession`.
#
# sessionId - The ID of the ETengine session to be restored.
# queries   - Queries whose results should be fetched with the session.
# inputs    - The inputs whose values are to be restored.
# callback  - Is called with the restored Session.
#
restoreSession = (sessionId, queries, inputs, callback) ->
  # Currently we have to fetch both the session information and user values
  # separately; it would be just marvellous if we could do both in a single
  # request. ;-)
  #
  async.parallel
    # Fetches information about the session.
    session: (cb) -> fetchSession sessionId, queries, cb
    # Fetches the persisted input values.
    values:  (cb) -> fetchUserValues sessionId, inputs, cb

  , (err, result) ->
    return callback(err) if err?

    # Update each of the inputs with the value retrieved from ETEngine.
    for input in inputs
      continue unless inputData = result.values[ input.def.key ]

      value = if inputData.hasOwnProperty('user_value')
        inputData.user_value
      else
        inputData.start_value

      input.set value: value if value?

    callback null, new Session(id: parseInt(sessionId, 10))
