# Represents the user's session with ETengine; keeps track of their unique
# session ID, country, end date, etc.
#
# Create a new session by calling `createSession()` instead of `new Session`
# since `createSession` will fetch the session ID from the server.
#
class exports.Session extends Backbone.Model
  constructor: ({ id }, options) ->
    super { id }, options
