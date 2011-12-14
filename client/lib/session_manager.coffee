# Each scene uses a separate ETEngine session so that the inputs from one
# scene don't affect the outcome of another. SessionManager keeps track of
# each scene ID and the ETEngine session it uses.

{ Session } = require 'models/session'

# The base URL used for all session requests.
BASE_URL = 'http://et-engine.com/api/v2/api_scenarios'

# Send with the request as X-Api-Agent so that ETengine devs know where
# requests are coming from.
X_API_AGENT = 'ETflex Client'

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
exports.getSession = (sceneId, queries, callback) ->
  lsKey = "ete.#{sceneId}"

  if callback?
    # Convert Backbone collection to an array.
    queries = queries.models unless _.isArray queries
  else
    # queries argument may be omitted.
    [ callback, queries ] = [ queries, null ] unless callback?

  if existingId = localStorage.getItem lsKey
    restoreSession existingId, queries, callback
  else
    createSession queries, (err, session) ->
      if err? then callback(err) else
        localStorage.setItem lsKey, session.id
        callback null, session

# Given inputs, sends their values to ETengine. Given queries, will also fetch
# their values.
#
# This may be called without any inputs or queries as part of the session
# creation process.
#
# sessionId - The ID of the ETengine session whose input values are to be
#             updated.
#
# options   - An object containing an optional "input" item containing a
#             collection of inputs to be updated, and an optional "queries"
#             item containing queries whose results should be returned.
#
# callback  - A callback to the run after the XHR request has completed. The
#             first parameter will be null unless an error occurred (in which
#             case it will be an exception object). The updated Query
#             instances will be provided to the callback in an array.
#
# Example (with a Query collection)
#
#   updateInputs 1337, inputs: myInputs, queries: myQueries, (err, data) ->
#     if err? then ... else ...
#
# Example (without a Query collection)
#
#   updateInputs 1337, inputs: myInputs, (err, data) ->
#     if err? then ... else ...
#
# Example (fetching session information only)
#
#   updateInputs 1337, (err, data) ->
#     if err? then ... else ...
#
exports.updateInputs = (sessionId, options, callback) ->
  [ callback, options ] = [ options, {} ] if _.isFunction options
  { inputs,   queries } = options

  # Data sent to the server.
  params = { input: {} }

  # Queries and inputs may be a Backbone collection.
  inputs  = inputs?.models  or inputs or []
  queries = queries?.models or queries

  # Map the input IDs and their values.
  params.input[ input.get('id') ] = input.get('value') for input in inputs

  # If there are any queries, tell ETEngine to give us those results.
  params.result = ( query.get('id') for query in queries ) if queries?

  sendRequest sessionId, params, (err, data) ->
    if err? then callback(err) else
      if data.errors and data.errors.length
        # ETengine currently returns a 200 OK even when an input is invalid;
        # work around this by forming our own error and running the callback
        # as a failure:
        error = new Error('API Error')
        error.errors = data.errors

        callback? error

      else
        # Update the queries with the new values returned by the engine.
        if data.result?
          for query in queries when result = data.result[ query.get 'id' ]
            query.set present: result[0][1], future: result[1][1]

        callback null, data if callback

# Session Helpers ------------------------------------------------------------

# Sends a request to ETengine.
#
# path     - The path to which the request should be sent. This is suffixed to
#            BASE_URL, and then has ".json" added to the end.
# callback - Run after the request completes with either the jQuery error
#            returned, or the parsed JSON data.
#
sendRequest = (path, data, callback) ->
  [ callback, data ] = [ data, null ] unless callback?

  jQuery.ajax
    url:         "#{BASE_URL}/#{path}.json?callback=?&"
    type:        'GET'
    data:         data
    dataType:    'json'
    accepts:     'json'
    contentType: 'json'
    headers:   { 'X-Api-Agent':  X_API_AGENT }

  .done (data, textStatus, jqXHR) ->
    callback null, data

  .error (jqXHR, textStatus, error) ->
    callback error

# An abstraction around sendRequest which hits ETEngine for the basic
# information about a session (country, etc).
#
# sessionId - The ID of the session being fetched from ETengine.
# queries   - Queries whose results should be fetched with the session.
# callback  - Is run with the error or retrieved session data.
#
fetchSession = (sessionId, queries, callback) ->
  exports.updateInputs sessionId, { queries }, (err, result) ->
    if err? then callback(err) else
      # New sessions return the API information in "api_scenario"
      # while existing sessions return it in "settings".
      callback null, result

# Hits user_values.json to get the state of the user's Inputs.
#
# sessionId - The ID of the ETengine session whose values are to be retrieved.
# callback  - Is called with the parsed values.
#
fetchUserValues = (sessionId, callback) ->
  sendRequest "#{sessionId}/user_values", callback

# Used to create a new Session instance, pre-initialized with values from
# ETengine. Use this in preference over `new Session` since creating a session
# explicitly will not actually create a session on ETengine.
#
# See `initSession`.
#
createSession = (queries, callback) ->
  fetchSession 'new', null, (err, sessionData) ->
    return callback(err) if err?

    sessionData = sessionData.api_scenario

    # The ETengine API does not presently support requesting query results
    # when creating a session. We need to start the session, and _then_
    # fetch the values.
    return restoreSession sessionData.id, queries, callback if queries?

    # No query results requires, so it suffices to proceed to getting the
    # initial user values.
    fetchUserValues sessionData.id, (err, userValues) ->
      if err? then callback(err) else
        callback null, new Session(
          _.extend(sessionData, user_values: userValues))

# Restores the session state by retrieving it from ETengine.
#
# See `initSession`.
#
# sessionId - The ID of the ETengine session to be restored.
# queries   - Queries whose results should be fetched with the session.
# callback  - Is called with the restored Session.
#
restoreSession = (sessionId, queries, callback) ->
  # Currently we have to fetch both the session information and user values
  # separately; it would be just marvellous if we could do both in a single
  # request. ;-)
  #
  async.parallel
    # Fetches information about the session.
    session: (cb) -> fetchSession sessionId, queries, cb
    # Fetches user_values.json
    values:  (cb) -> fetchUserValues sessionId, cb

  , (err, result) ->
    if err? then callback(err) else
      callback null, new Session _.extend result.session.settings,
        id:          sessionId
        user_values: result.values
