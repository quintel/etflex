# Represents the user's session with ETengine; keeps track of their unique
# session ID, scenario country, end date, etc.
#
# Create a new session by calling `createSession()` instead of `new Session`
# since `createSession` will fetch the session ID from the server.
#

# Used to create a new Session instance, pre-initialized with values from
# ETengine. Use this in preference over `new Session` since creating a session
# explicitly will not actually create a session on ETengine. The created
# session is provided to your `callback`.
#
# callback - A function which is run once the new Session has been created and
#            initialized. It will be provided with two arguments - the first
#            is an error object, and will be null if the API request was
#            successful. The second argument will be the Session object.
#
exports.createSession = (callback) ->
  $.ajax
    url:         'http://api.et-model.com/api/v2/api_scenarios/new.json?callback=?&'
    type:        'GET'
    dataType:    'json'
    accepts:     'json'
    contentType: 'json'
    headers:   { 'X-Api-Agent':  'ETflex/HEAD' }

  .done (data, textStatus, jqXHR) ->
    callback null, new Session data.api_scenario

  .fail (jqXHR, textStatus, error) ->
    callback error

# The main session model; not exported because you should use `createSession`
# instead.
#
class Session extends Backbone.Model
  constructor: (attributes) ->
    super
      id:         attributes.id
      country:    attributes.country
      endYear:    attributes.end_year
      region:     attributes.region
      useFCE:     attributes.use_fce
      userValues: {}
