app              = require 'app'
render           = require 'lib/render'

{ SceneView }    = require 'views/scene'
{ NotFoundView } = require 'views/not_found'

# HELPERS --------------------------------------------------------------------

notFound = ->
  render new NotFoundView

# Starts a scene using a collection.
#
# For example, you may start a scene by providing the Scenes collection and
# the ID of the scene to be started; or the Scenarios scene with the scene
# and scenario IDs. So long as the collection responds to "getOrFetch", and
# the returned object responds to "start", then all will be well.
#
# collection   - A Backbone collection which responds to getOrFetch
# startArgs... - Additional arguments which will be passed to getOrFetch.
#
startScene = (collection, startArgs...) ->
  collection.getOrFetch startArgs..., (err, thing) ->
    # Backbone doesn't return a useful error, but it was almost certainly a
    # 404, so just render the Not Found page...
    if err? then console.error err else
      thing.start (err, scene, scenario) ->
        if err? then console.error err else
          sessionId = scenario.get 'sessionId'

          # Now that we have fetched the session, we change the URL so that
          # the user can hit refresh without losing their changes.
          app.navigate "scenes/#{ scene.id }/with/#{ sessionId }",
            trigger: false, replace: true

          render new SceneView model: scene, scenario: scenario

          if scenario.isNew() and scenario.canChange app.user
            scene.inputs.trigger 'updateInputsDone'

# ROUTER ---------------------------------------------------------------------

# Router watches the URL and, as it changes, re-renders the main view
# mimicking the user navigating from one page to another.
#
class exports.Main extends Backbone.Router
  routes:
    '':                     'redirectToDefaultScene'
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
  notFound: notFound

  # Fetches the list of all Scenes, and redirects to the ETlite recreation.
  #
  # TODO Use the scenes collection, adding any scenes which were fetched from
  #      the server but weren't present in the collection. Need to know which
  #      scenes are partial definitions (from views/embeds) and which are
  #      complete...
  #
  redirectToDefaultScene: ->
    jQuery.getJSON('/scenes.json')
      .done (data) ->
        etlite = _.find data, (scene) ->
          scene.name is 'Balancing Supply and Demand'

        if etlite?
          app.navigate etlite.href
        else
          console.error "No scene has the name 'Balancing Supply and Demand'"

      .error ->
        console.error "Couldn't fetch a scene list from /scenes"

  # Loads a scene using JSON delivered from ETflex to set up which inputs and
  # orios are used.
  #
  # GET /scenes/:id
  #
  showScene: (id) ->
    startScene app.collections.scenes, id

  # Given JSON for a scenario (and embedded Scene), renders the scene fetching
  # the scenario from ET-Engine.
  #
  # GET /scenes/:scene_id/scenarios/:id
  #
  showSceneWithScenario: (sceneId, id) ->
    startScene app.collections.scenarios, sceneId, id

  # Used when changing language; a two-character language code is appended to
  # the URL.
  #
  # GET /en/*actions
  # GET /nl/*actions
  #
  languageRedirect: (action) ->
    @navigate action or 'sanity', true
