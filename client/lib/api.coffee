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
