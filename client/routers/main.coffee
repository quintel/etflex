app              = require 'app'
render           = require 'lib/render'
{ SceneView }    = require 'views/scene'
{ NotFoundView } = require 'views/not_found'

# Router watches the URL and, as it changes, re-renders the main view
# mimicking the user navigating from one page to another.
#
class exports.Main extends Backbone.Router
  routes:
    '':                     'root'

    'scenes':               'redirectToDefaultScene'
    'scenes/:id':           'showScene'

    'scenes/:sid/with/:id': 'showSceneWithScenario'

    'en':                   'languageRedirect'
    'nl':                   'languageRedirect'
    'en/*actions':          'languageRedirect'
    'nl/*actions':          'languageRedirect'

    '*undefined':           'notFound'

  # A 404 Not Found page. Presents the user with a localised message guiding
  # them back to the front page.
  #
  # GET /*undefined
  #
  notFound: ->
    $('body').html (new NotFoundView).render().el

  # The root page; simply shows the default scene with the "modern" theme for
  # the moment.
  #
  # GET /
  #
  root: ->
    @redirectToDefaultScene()

  # Fetches the list of all Scenes, and redirects to the ETlite recreation.
  #
  # TODO Use the scenes collection, adding any scenes which were fetched from
  #      the server but weren't present in the collection. Need to know which
  #      scenes are partial definitions (from views/embeds) and which are
  #      complete...
  #
  redirectToDefaultScene: ->
    jQuery.getJSON('/scenes')
      .done (data) ->
        etlite = _.find data['scenes'], (scene) ->
          scene.name is 'ETlite Recreation'

        if etlite?
          app.navigate etlite.href
        else
          console.error "No scene has the name 'ETlite Recreation'"

      .error ->
        console.error "Couldn't fetch a scene list from /scenes"

  # Loads a scene using JSON delivered from ETflex to set up which inputs and
  # orios are used.
  #
  # GET /scenes/:id
  #
  showScene: (id) ->
    app.collections.scenes.getOrFetch id, (err, scene) =>
      # Backbone doesn't return a useful error, but it was almost certainly a
      # 404, so just render the Not Found page...
      if err? then @notFound() else

        # Otherwise, let's start the scene by starting the ETengine session.
        scene.start (err, scene, session) ->
          if err? then console.error err else
            render new SceneView model: scene

  # Given JSON for a scenario (and embedded Scene), renders the scene fetching
  # the scenario from ET-Engine.
  #
  # GET /scenes/:scene_id/scenarios/:id
  #
  showSceneWithScenario: (sceneId, id) ->
    app.collections.scenarios.getOrFetch sceneId, id, (err, scenario) ->
      if err? then @notFound() else
        scenario.start (err, scenario, scene, session) ->
          if err then console.log(err) else
            render new SceneView model: scene, scenario: scenario


  # Used when changing language; a two-character language code is appended to
  # the URL.
  #
  # GET /en/*actions
  # GET /nl/*actions
  #
  languageRedirect: (action) ->
    @navigate action or 'sanity', true
