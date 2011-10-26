# Each Scenario uses a separate ETEngine session so that the inputs from one
# scenario don't affect the outcome of another. SessionManager keeps track of
# each scenario ID and the ETEngine session it uses.

{ Session } = require 'models/session'

# Holds all of the scenario ID -> session ID pairs. Retrieved on page load
# from the cookie, or defaults to an empty object if this is the users first
# visit.
ID_MAP = if cookie = jQuery.cookie('eteSessions')
  JSON.parse cookie
else {}

# The base URL used for all session requests.
BASE_URL = 'http://et-engine.com/api/v2/api_scenarios'

# Send with the request as X-Api-Agent so that ETengine devs know where
# requests are coming from.
X_API_AGENT = 'ETflex Client'

# Exports --------------------------------------------------------------------

# Returns the ETEngine session which corresponds with a Scenario ID.
#
# If the user has visited the scenario since the application loaded, the
# session instance is cached and will be immediately given to the callback.
#
# If the user has a previous session for the scenario it will be fetched from
# ETengine so that the scenario may be initialized with the values previously
# chosen by the user.
#
# If this is the users first time using a scenario, a new ETEngine session
# will be created.
#
# In all cases, the session will be returned to the callback as the second
# argument. The first argument will be null unless an error occurred.
#
# scenarioId - A number which uniquely identifies the session.
# callback   - A function which is run after the session is retrieved.
#
exports.getSession = (scenario, callback) ->
  if scenario.session
    callback null, scenario.session
  else
    wrappedCallback = (err, session) ->
      if err? then callback(err) else
        ID_MAP[ scenarioId ] = session.id

        jQuery.cookie 'eteSessions', JSON.stringify(ID_MAP),
          expires: 1, path: '/'

        callback null, session

    if ID_MAP[ scenarioId ]
      restoreSession ID_MAP[ scenarioId ], wrappedCallback
    else
      createSession wrappedCallback

# Session Helpers ------------------------------------------------------------

# Sends a request to ETengine.
#
# path     - The path to which the request should be sent. This is suffixed to
#            BASE_URL, and then has ".json" added to the end.
# callback - Run after the request completes with either the jQuery error
#            returned, or the parsed JSON data.
#
sendRequest = (path, callback) ->
  jQuery.ajax
    url:         "#{BASE_URL}/#{path}.json?callback=?&"
    type:        'GET'
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
# callback  - Is run with the error or retrieved session data.
#
fetchSession = (sessionId, callback) ->
  sendRequest "#{sessionId}", (err, result) ->
    if err? then callback(err) else
      # New sessions return the API information in "api_scenario" while
      # existing sessions return it in "settings".
      callback null, result.api_scenario or result.settings

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
createSession = (callback) ->
  async.waterfall [
    # Create a new session.
    (cb) -> fetchSession 'new', cb

    # Fetch user_values.json to initialize sliders.
    (sessionValues, cb) ->
      fetchUserValues sessionValues.id, (err, userValues) ->
        cb null, sessionValues, userValues

  ], (err, sessionValues, userValues) ->
    # Store the session ID as a cookie so that we can restore on refresh.
    jQuery.cookie 'eteSid', "#{sessionValues.id}",
      expires: 1, path: '/'

    callback null, new Session _.extend sessionValues, user_values: userValues

# Restores the session state by retrieving it from ETengine.
#
# See `initSession`.
#
# sessionId - The ID of the ETengine session to be restored.
# callback  - Is called with the restored Session.
#
restoreSession = (sessionId, callback) ->
  # Currently we have to fetch both the session information and user values
  # separately; it would be just marvellous if we could do both in a single
  # request. ;-)
  #
  async.parallel
    # Fetches information about the session.
    session: (cb) -> fetchSession sessionId, cb
    # Fetches user_values.json
    values:  (cb) -> fetchUserValues sessionId, cb

  , (err, result) ->
    if err? then callback(err) else
      callback null, new Session _.extend result.session,
        id:          sessionId
        user_values: result.values
