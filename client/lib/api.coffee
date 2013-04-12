PATH = null

# Sets the path used when sending API requests to ETEngine. Self-destructs
# after the first time it is called.
#
exports.setPath = (path, offline = false) ->
  ios4 = navigator.userAgent?.match(/CPU (iPhone )?OS 4_/)
  PATH = if jQuery.support.cors and not ios4 and not offline
    path
  else
    '/ete'

  exports.isBeta  = path.match(/^https?:\/\/beta\./)?
  exports.setPath = (->)

# Creates a path for an API request. Prevents malicious users messing with the
# API variable.
#
# path - The URL path; appended to the API path.
#
exports.path = (suffix) -> "#{ PATH }/#{ suffix }"

# Using the beta API?
exports.isBeta = false

# Sends a request to ETengine.
#
# path     - The path to which the request should be sent. Do not include the
#            host, "api_scenarios" path, or a file extension.
# callback - Run after the request completes with either the jQuery error
#            returned, or the parsed JSON data.
#
exports.send = (method, path, data, callback) ->
  [ callback, data ] = [ data, null ] unless callback?

  path = "/#{ path }" if path?

  jQuery.ajax
    url:          exports.path "api/v3/scenarios#{ path }"
    data:         data
    type:         method.toUpperCase()
    dataType:    'json'
    headers:   { 'X-Api-Agent': 'ETflex Client' }

  .done (data, textStatus, jqXHR) ->
    callback null, data

  .fail (jqXHR, textStatus, error) ->
    callback error

# Given inputs, sends their values to ETengine. Will also fetch the values
# of any queries provided.
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
#             first parameter will be null unless an error occurred, in which
#             case it will be an exception object. The updated Query instances
#             will be provided to the callback in an array.
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
  params = { scenario: { user_values: {} }, autobalance: true }

  # Queries is a backbone collection
  queries = queries?.models or queries

  # Map the input IDs and their values.
  params.scenario.user_values = inputs?.values() or {}

  # If there are any queries, tell ETEngine to give us those results.
  params.gqueries = ( query.get('id') for query in queries ) if queries?

  # Send any custom scenario settings (end year, country, etc).
  params.settings = options.settings

  exports.send 'put', sessionId, params, (err, data) ->
    if err? then callback(err) else
      # Update the queries with the new values returned by the engine.
      if data.gqueries?
        for query in queries when result = data.gqueries[ query.id ]
          # Had to hack this up, as backbone tries to be really smart about
          # the way it sets attributes. We rely on previous attributes being
          # set, even if they're the same, so that we calculate the difference.
          query._previousAttributes = _.clone(query.attributes)
          query.set { present: result.present, future: result.future } , { silent: true }
          query.trigger('change:future')

      callback null, data if callback
