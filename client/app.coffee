# app.coffee contains the instance of the main application router, as
# well as any other objects which are considered "singletons", such as
# full-page views.

{ Inputs }        = require 'collections/inputs'
{ Scenes }        = require 'collections/scenes'
{ Queries }       = require 'collections/queries'
{ createStencil } = require 'collections/stencil'

{ InputManager }  = require 'lib/input_manager'

# Holds the instantiated routers so that we can refer to them later.
exports.routers = {}

# Holds each of the main model collections (Sliders, Widgets, etc).
exports.collections = {}

# Holds Stencil instances which can be used to create collections for
# each scene.
exports.stencils = {}

# Called _once_ when the application is first loaded in the browser.
exports.boot = (window, locale) ->
  installConsolePolyfill window

  I18n.locale    = locale
  I18n.fallbacks = no

  # Set up the collections.
  raw = require 'raw'

  exports.stencils.inputs    = createStencil Inputs, raw.inputs
  exports.stencils.queries   = createStencil Queries, raw.queries
  exports.collections.scenes = new Scenes

  async.parallel data: fetchInitialData, postBoot

# A wrapper around Backbone.Router::navigate which selects the correct router
# (main or backstage) depending on the URL, and by default will run the action
# in the router (Backbone by default does not do this).
#
exports.navigate = (url, trigger = true) ->
  router =
    if url.match(/^backstage\//)
      exports.routers.backstage
    else
      exports.routers.main

  router.navigate url, trigger

# Bootstrap Functions, execute in parallel -----------------------------------

# Retrieves static data such as input and query definitions. Ideally it should
# be possible for the remote API to deliver this all in a single response.
#
fetchInitialData = (callback) ->
  callback null, true

# Called after all the other boot functions have completed.
#
# Issues a warning if one of the functions failed, otherwise finishes set-up
# of the application. Any part of the app set-up which depends must occur
# _after_ the asynchronous boostrap function should go here.
#
postBoot = (err, result) ->
  exports.boot = (->)

  if err?
    console.error "Could not initialize application.", err
  else
    exports.routers.main      = new (require('routers/main').Main)
    exports.routers.backstage = new (require('routers/backstage').Backstage)

    # Fire up Backbone routing...
    Backbone.history.start pushState: true

# Helper Functions -----------------------------------------------------------

installConsolePolyfill = (window) ->
  unless 'console' of window
    window.console = { log: (->), info: (->), warn: (->), error: (->) }
