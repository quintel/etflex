app          = require 'app'

{ Scene }    = require 'models/scene'
{ Scenario } = require 'models/scenario'

# A collection which holds all of the Scenario instances which the client
# knows about. Note that this collection does not contain _every_ scenario
# which is on the server; a scenario must first be fetched from the server and
# is then added to the collection.
#
class exports.Scenarios extends Backbone.Collection
  model: Scenarios
  url:   ''

  # Returns the Scene whose ID matches "id". if the scenario already exists in
  # the collection, the supplied "callback" will be run immediately. Otherwise
  # an XHR request will retrieve theh scene from the server, and the callback
  # will then be run.
  #
  # sceneId  - The ID of the scene for which the scenario has values.
  # id       - The ID of the scenario.
  # callback - Function to be run after the scene is retrieved.
  #
  getOrFetch: (sceneId, id, callback) ->
    if scenario = @get(id) then callback(scene) else
      @add scenario = new Scenario(sessionId: id, scene: { id: sceneId })

      scenario.fetch
        error:   (scenario) -> callback true
        success: (scenario) ->
          scenes    = app.collections.scenes
          sceneData = scenario.get('scene')

          # If the scene does not already exist in the collection, we need to
          # add it before Scenario::start may be called.
          #
          # TODO The collection may contain only a partial scene (such as is
          #      fetched when retrieving the list of available scenes). We
          #      need to check for this and update the existing scene.
          #
          scenes.add(new Scene(sceneData)) unless scenes.get(sceneData.id)

          callback null, scenario
