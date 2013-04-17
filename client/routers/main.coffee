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

# ROUTER ---------------------------------------------------------------------

# Router watches the URL and, as it changes, re-renders the main view
# mimicking the user navigating from one page to another.
class exports.Main extends Backbone.Router
  routes:
    '':                     'root'

    'scenes':               'redirectToDefaultScene'
    'scenes/:id':           'showScene'
    'scenes/:sid/with/:id': 'showSceneWithScenario'

    'supported_browsers':   'doNothing'

    '*undefined':           'notFound'

  # The main landing page for ETflex.
  #
  # Contains information about the application, and the top n scores list
  # using Pusher.
  #
  # GET /
  #
  root: ->
    { ScenarioSummaries } = require 'collections/scenario_summaries'
    { HighScores }        = require 'views/high_scores'
    { StaticHeader }      = require 'views/static_header'
    { clientNavigate }    = require 'lib/client_navigate'

    highScoreList = (window.bootstrap or [])
    for sceneId, scores of highScoreList
      summaries  = new ScenarioSummaries(scores)
      highScores = new HighScores(
        collection: summaries, sceneId: sceneId, style: 'compact')

      $(".scores[data-scene=#{sceneId}]").html highScores.render().el

    $('.go .start-over a, .go .conference-continue a, .level a.poster').
      on('click', clientNavigate)

    bigButton = $ '.go .buttons a'

    # When in conference mode, *and* the user is a guest, "Create your own
    # future" creates a totally new session, so a full refresh is preferable
    # to ensure settings are correct.
    if app.conference and app.user.isGuest
      bigButton.on 'click', -> localStorage?.removeItem 'seen-prelaunch'
    else
      bigButton.on 'click', clientNavigate

    new StaticHeader( el: $('#theme-header') ).render()

    render.enhance()

  # Keep silence when a static page needs to be rendered
  doNothing: ->

  # A 404 Not Found page. Presents the user with a localised message guiding
  # them back to the front page.
  #
  # GET /*undefined
  #
  notFound: notFound

  # Fetches the list of all Scenes, and redirects to the ETlite recreation.
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
  # the scenario from ETengine.
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
