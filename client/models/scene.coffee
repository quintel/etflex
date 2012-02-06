app            = require 'app'

{ getSession } = require 'lib/engine'
{ getProp }    = require 'views/props'

{ Inputs }     = require 'collections/inputs'
{ Queries }    = require 'collections/queries'
{ Scenario }   = require 'models/scenario'

# Scenes are pages such as the ETlite recreation, which have one or more
# inputs, fetch results from ETengine, and display these to the user.
#
# Each scene is linked to an ETengine session which performs calculations.
#
class exports.Scene extends Backbone.Model

  # Returns the URL to the scene.
  url: -> "/scenes/#{ @id }.json"

  constructor: ->
    super

    @inputs  = null
    @queries = null

  # Starts the scene by fetching the ETengine session (if one already exists;
  # creates a new session otherwise).
  #
  # scenario - By default, start will create a new ET-Engine session
  #            (scenario) but you may instead provide a scenario of your own
  #            which should be used instead. Note that if the Scenario has no
  #            "sessionId" value, starting the scene will create a new
  #            ET-Engine session and set the value.
  #
  # callback - A function which will be run after the scene has been set up.
  #            The callback will be provided with the Scene instance and the
  #            session instance.
  #
  start: ([ scenario ]..., callback) ->
    if scenario
      if scenario.get('scene').id isnt @id
        throw 'Scenario scene ID does not match scene ID'
    else
      scenario = new Scenario scene: _.clone(@attributes), user:  app.user
      app.collections.scenarios.add scenario

    @queries or= new Queries({ id: id } for id in @dependantQueries())
    @inputs  or= new Inputs @get('inputs')

    getSession scenario, @queries, @inputs, (err, sessionId) =>
      if err? then callback(err) else
        @inputs.initializeBalancers()

        scenario.set { sessionId }

        # Required so that changes to inputs can be sent back to ETEngine.
        @inputs.persistTo scenario

        # Watch for changes to the inputs, and send them back to ETEngine.
        @inputs.on 'change:value', (input) => input.save {}, { @queries }

        # Returns input values and query information to ETFlex when received
        # from ETEngine.
        @inputs.on 'updateInputsDone', =>
          if scenario.canChange app.user
            scenario.updateCollections { @inputs, @queries }

        callback null, this, @scenario = scenario

  # Returns an array of query IDs used by the scene.
  #
  # TODO At some point, figuring out what queries are used by a scene will
  #      become dependant on those defined in the database, instead of being
  #      an attribute on the View class. We can remove this when that happens,
  #      since the server JSON will tell us exactly which queries are needed.
  #
  dependantQueries: ->
    ids = []

    for prop in @get('props')
      ids.push ( getProp(prop.behaviour).queries or [] )...

    _.uniq ids
