PATH = null

# Sets the path used when sending API requests to ETEngine. Self-destructs
# after the first time it is called.
#
exports.setPath = (path) ->
  PATH = if jQuery.support.cors then path else '/ete'
  exports.beta = !! path.match(/^https?:\/\/beta\./)
  exports.setPath = (->)

# Creates a path for an API request. Prevents malicious users messing with the
# API variable.
#
# path - The URL path; appended to the API path.
#
exports.path = (suffix) -> "#{ PATH }/#{ suffix }"

# Using the beta API?
exports.beta = false

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
