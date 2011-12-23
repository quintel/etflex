app = require 'app'

{ getSession } = require 'lib/session_manager'
{ getProp }    = require 'views/props'

{ Inputs }     = require 'collections/inputs'
{ Queries }    = require 'collections/queries'

# Scenes are pages such as the ETlite recreation, which have one or more
# inputs, fetch results from ETengine, and display these to the user.
#
# Each scene is linked to an ETengine session which performs calculations.
#
class exports.Scene extends Backbone.Model
  # Stores an Inputs collection used by the scene.
  inputs: null

  # Stores a Query collection used by the scene.
  queries: null

  # The ETengine session. null if the scene has not yet been started.
  session: null

  # Starts the scene by fetching the ETengine session (if one already exists;
  # creates a new session otherwise).
  #
  # callback - A function which will be run after the scene has been set up.
  #            The callback will be provided with the Scene instance and the
  #            session instance.
  #
  start: (callback) ->
    if @session? then callback(null, @, @session) else

      @queries = new Queries({ id: id } for id in @dependantQueries())
      @inputs  = new Inputs @get('inputs')

      getSession @id, @queries, (err, session) =>
        if err? then callback(err) else

          # Required so that changes to inputs can be sent back to ETengine.
          @inputs.setSession session

          # Watch for changes to the inputs, and send them back to ETengine.
          @inputs.bind 'change:value', (ipt) => ipt.save {}, queries: @queries

          callback(null, @, @session = session)

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
