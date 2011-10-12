# Represents the user's session with ETengine; keeps track of their unique
# session ID, scenario country, end date, etc.
#
# Create a new session by calling `createSession()` instead of `new Session`
# since `createSession` will fetch the session ID from the server.
#

# The base URL used for all session requests.
BASE_URL = 'http://api.et-model.com/api/v2/api_scenarios'

# A function which returns a fully-qualified session API URL.
scenarioUrl = (path) -> "#{BASE_URL}/#{path}.json?callback=?&"

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
  jQuery.ajax
    url:         scenarioUrl 'new'
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

  # Sends an API request updating the given `inputs` with their values.
  #
  # `updateInputs` doesn't check that the Inputs are dirty; it is assumed that
  # you already know that their values need to be pushed to the server.
  #
  # inputs   - An array of inputs whose values are to be sent to ETengine.
  #
  # gqueries - An array of GQuery instances whose values should be refreshed
  #            when the inputs values are sent to the server. This argument
  #            may be omitted. Note that GQuery `change` events will fire
  #            before the `callback`.
  #
  # callback - A callback to the run after the XHR request has completed. The
  #            first parameter will be null unless an error occurred (in which
  #            case it will be an exception object). The updated GQuery
  #            instances will be provided to the callback.
  #
  # Example (with a GQuery collection)
  #
  #   session.updateInputs inputs, gQueries, (err) ->
  #     console.log err if err?
  #
  # Example (without a GQuery collection)
  #
  #   session.updateInputs inputs, (err) ->
  #     console.log err if err?
  #
  updateInputs: (inputs, gQueries, callback) ->
    params = input: {}

    # Simple update without wanting any new gQuery results.
    callback = gQueries if not callback? and _.isFunction gQueries

    # Map the inputs IDs and values.
    params.input[input.get('id')] = input.get('value') for input in inputs

    # if gQueries
    #   params.r = ( gQuery.get('key') for gQuery in gQueries ).join ';'

    jQuery.ajax
      url:         scenarioUrl this.get('id')
      data:        params
      type:        'GET'
      dataType:    'json'
      accepts:     'json'
      contentType: 'json'
      headers:   { 'X-Api-Agent': 'ETflex/HEAD' }

    .done (data, textStatus, jqXHR) ->
      # TODO Update the given GQuerys.
      #
      # TODO Perhaps also update the Inputs with the values returned by
      #      ETengine in case it wasn't happy with something?
      #
      callback null, gQueries if callback

    .fail (jqXHR, textStatus, error) ->
      callback error if callback

