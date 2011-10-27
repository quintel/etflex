# The base URL used for all session requests.
BASE_URL = 'http://et-engine.com/api/v2/api_scenarios'

# Send with the request as X-Api-Agent so that ETengine devs know where
# requests are coming from.
X_API_AGENT = 'ETflex Client'

# Represents the user's session with ETengine; keeps track of their unique
# session ID, scenario country, end date, etc.
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

  # Sends an API request updating the given `inputs` with their values.
  #
  # `updateInputs` doesn't check that the Inputs are dirty; it is assumed that
  # you already know that their values need to be pushed to the server.
  #
  # inputs   - An array of inputs whose values are to be sent to ETengine.
  #
  # queries  - An array of Query instances whose values should be refreshed
  #            when the inputs values are sent to the server. This argument
  #            may be omitted. Note that Query `change` events will fire
  #            before the `callback`.
  #
  #            You may instead provide a Backbone.Collection containing the
  #            queries to be updated.
  #
  # callback - A callback to the run after the XHR request has completed. The
  #            first parameter will be null unless an error occurred (in which
  #            case it will be an exception object). The updated Query
  #            instances will be provided to the callback in an array.
  #
  # Example (with a Query collection)
  #
  #   session.updateInputs inputs, queries, (err) ->
  #     console.log err if err?
  #
  # Example (without a Query collection)
  #
  #   session.updateInputs inputs, (err) ->
  #     console.log err if err?
  #
  updateInputs: (inputs, queries, callback) ->
    params = input: {}

    # queries may be a Backbone.Collection...
    queries = queries.models if queries? and not _.isArray queries

    # Simple update without wanting any new Query results.
    callback = queries if not callback? and _.isFunction queries

    # Map the inputs IDs and values.
    params.input[input.get('id')] = input.get('value') for input in inputs

    # If there were any queries, tell ETengine to also give us those results.
    params.result = ( query.get('id') for query in queries ) if queries?

    jQuery.ajax
      url:         "#{BASE_URL}/#{@get('id')}.json?callback=?&"
      data:        params
      type:        'GET'
      dataType:    'json'
      accepts:     'json'
      contentType: 'json'
      headers:   { 'X-Api-Agent': X_API_AGENT }

    .done (data, textStatus, jqXHR) ->
      # ETengine currently returns a 200 OK even when an input is invalid;
      # work around this by forming our own error and running the callback
      # as a failure:
      if data.errors?.length isnt 0
        callback _.extend(new Error('API Error'), errors: data.errors)

      else
        # TODO Perhaps also update the Inputs with the values returned by
        #      ETengine in case it wasn't happy with something?

        # Update the queries with the new values returned by the engine.
        if data.result?
          for query in queries when result = data.result[ query.get 'id' ]
            query.set present: result[0][1], future: result[1][1]

        callback null, queries if callback

    .fail (jqXHR, textStatus, error) ->
      callback error if callback

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
