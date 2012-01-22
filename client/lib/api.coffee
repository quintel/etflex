PATH = null

# Sets the path used when sending API requests to ETEngine. Self-destructs
# after the first time it is called.
#
exports.setPath = (path) ->
  PATH = if jQuery.support.cors then path else '/ete'

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
# path     - The path to which the request should be sent. This is suffixed to
#            BASE_URL, and then has ".json" added to the end.
# callback - Run after the request completes with either the jQuery error
#            returned, or the parsed JSON data.
#
exports.send = (path, data, callback) ->
  [ callback, data ] = [ data, null ] unless callback?

  jQuery.ajax
    url:          exports.path "api_scenarios/#{path}.json"
    data:         data
    type:        'GET'
    dataType:    'json'
    accepts:     'json'
    contentType: 'json'
    headers:   { 'X-Api-Agent': 'ETflex Client' }

  .done (data, textStatus, jqXHR) ->
    callback null, data

  .fail (jqXHR, textStatus, error) ->
    callback error

# Registers the changes in the Client with the Server
# PUT /backstage/scenes/:scene_id/props/:id
#
exports.updateServer = (inputs, co2, costs, renewability) ->
  
  

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
  params = { input: {}, sanitize_groups: true }

  # Queries and inputs may be a Backbone collection.
  inputs  = inputs?.models  or inputs or []
  queries = queries?.models or queries

  # Map the input IDs and their values.
  params.input[ input.get('id') ] = input.get('value') for input in inputs

  # If there are any queries, tell ETEngine to give us those results.
  params.result = ( query.get('id') for query in queries ) if queries?

  exports.send sessionId, params, (err, data) ->
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
