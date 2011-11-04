# The base URL used for all session requests.
BASE_URL = 'http://et-engine.com/api/v2/api_scenarios'

# Send with the request as X-Api-Agent so that ETengine devs know where
# requests are coming from.
X_API_AGENT = 'ETflex Client'

# Represents the user's session with ETengine; keeps track of their unique
# session ID, country, end date, etc.
#
# Create a new session by calling `createSession()` instead of `new Session`
# since `createSession` will fetch the session ID from the server.
#
class exports.Session extends Backbone.Model
  constructor: (attributes, options) ->
    super
      id:         attributes.id
      country:    attributes.country
      endYear:    attributes.end_year
      region:     attributes.region
      useFCE:     attributes.use_fce
      userValues: attributes.user_values or {}
    , options

  # Given an inputs collection, sets the value of each input to those given
  # when the session was first retrieved from ETengine.
  #
  # Used as part of the bootstrap process.
  #
  finalizeInputs: (collection) ->
    values = @get 'userValues'
    valueFrom = (data) -> data? and (data.user_value or data.start_value)

    collection.each (input) ->
      if value = valueFrom values[ input.get('id') ]
        input.set { value: value }, silent: true
