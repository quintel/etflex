{ Scene } = require 'models/scene'

# A collection which holds all of the Scene instances which the client knows
# about. Note that this collection does not contain _every_ scene which is
# defined on the server; a scene must first be fetched from the server and
# added to the collection.
#
# TODO: Override "get" so that we fetch automatically? Backbone isn't async.
#       in this regard, so, urgh...
#
class exports.Scenes extends Backbone.Collection
  model: Scene
  url:  '/scenes/'

  # Returns the Scene whose ID matches "id". If the scene already exists in
  # the collection, the supplied "callback" will be run immediately. Otherwise
  # an XHR request will retrieve the scene from the server, and the callback
  # will be run.
  #
  # id       - The ID of the scene to be returned.
  # callback - Function to be run after the scene is retrieved.
  #
  getOrFetch: (id, callback) ->
    if scene = @get(id) then callback null, scene else
      @add(scene = new Scene id: id)

      scene.fetch
        error:   (args...) -> callback [ args... ]
        success: (scene)   -> callback null, scene

  # Given JSON for a scene, returns the scene adding it to the collection. If
  # the scene already exists in the collection, it will be returned without
  # changes.
  #
  # attributes - Attributes for the scene.
  #
  getOrAdd: (attributes, callback) ->
    if scene = @get(attributes.id) then scene else
      @add(scene = new Scene attributes)
      scene
