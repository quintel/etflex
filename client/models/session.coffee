# Represents the user's session with ETengine; keeps track of their unique
# session ID. It may do other stuff in the future...
#
# Create a new session by calling `engine::getSession()` instead of
# `new Session` since `getSession` will handle other important setup details
# (like keeping track of session IDs).
#
class exports.Session extends Backbone.Model
  constructor: ({ id }, options) ->
    super { id }, options
