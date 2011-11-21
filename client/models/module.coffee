app = require 'app'

{ getSession }       = require 'lib/session_manager'
{ getVisualisation } = require 'views/vis'

# Modules are pages such as the ETlite recreation, which have one or more
# inputs, fetch results from ETengine, and display these to the user.
#
# Each module is linked to an ETengine session which performs calculations.
#
class exports.Module extends Backbone.Model
  # Stores an Inputs collection used by the module.
  inputs: null

  # Stores a Query collection used by the module.
  queries: null

  # The ETengine session. null if the module has not yet been started.
  session: null

  # Starts the module by fetching the ETengine session (if one already exists;
  # creates a new session otherwise).

  # callback - A function which will be run after the module has been set up.
  #            The callback will be provided with the Module instance and the
  #            session instance.
  #
  start: (callback) ->
    if @session? then callback(null, @, @session) else

      @queries = app.stencils.queries @dependantQueries()
      @inputs  = app.stencils.inputs  @dependantInputs()

      getSession @id, @queries, (err, session) =>
        if err? then callback(err) else

          # Required so that changes to inputs can be sent back to ETengine.
          @inputs.setSession session

          # Watch for changes to the inputs, and send them back to ETengine.
          @inputs.bind 'change:value', (ipt) => ipt.save {}, queries: @queries

          callback(null, @, @session = session)

  # Returns an array of query IDs used by the module.
  #
  # TODO At some point, figuring out what queries are used by a module will
  #      become dependant on those defined in the database, instead of being
  #      an attribute on the View class. We can remove this when that happens,
  #      since the server JSON will tell us exactly which queries are needed.
  #
  dependantQueries: ->
    ids = _.clone( getVisualisation( @get('centerVis') ).queries or [] )

    for visualisation in @get('mainVis')
      ids.push ( getVisualisation(visualisation).queries or [] )...

    _.uniq ids

  # Returns an array of inputs IDs used by the module.
  #
  dependantInputs: ->
    _.uniq @get('leftInputs').concat @get('rightInputs')
