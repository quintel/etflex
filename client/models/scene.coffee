app          = require 'app'

{ getProp }  = require 'views/props'
{ Scenario } = require 'models/scenario'

# Scenes are pages such as "Balancing Supply and Demand", which have
# one or more inputs, fetch results from ETengine, and display these to the
# user.
#
# Each scene is linked to an ETengine session which performs calculations.
#
class exports.Scene extends Backbone.Model
  # Returns the URL to the scene.
  url: -> "/scenes/#{ @id }.json"

  # Starts the scene by fetching the ETengine session if one already exists;
  # creates a new session otherwise.
  #
  # scenario - By default, start will create a new ETengine scenario but you
  #            may instead provide a scenario of your own which will be used
  #            instead.
  #
  # callback - A function run after the scene has been set up. The callback
  #            will be provided with the Scene instance and the session
  #            instance.
  #
  start: ([ scenario ]..., callback) ->
    if scenario
      if scenario.get('scene').id isnt @id
        return callback """
          Cannot start scene. The scenario scene ID does not match the scene
          ID of the Scenario.
        """

      # If scenario is passed in, the scenario has already been started.
      callback null, this
    else
      scenario = new Scenario scene: _.clone(@attributes), user: app.user
      app.collections.scenarios.add scenario

      scenario.start callback

  # Returns an array of query IDs used by the scene.
  dependantQueries: ->
    ids = []

    for prop in @get('props')
      ids.push ( getProp(prop.behaviour)::queries or [] )...

    _.uniq ids

