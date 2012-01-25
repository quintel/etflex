# app.coffee contains the instance of the main application router, as
# well as any other objects which are considered "singletons", such as
# full-page views.

# Indicates if the visitor is currently signed in to a registered account.
exports.isSignedIn = false

# Holds the instantiated routers so that we can refer to them later.
exports.routers = {}

# Holds each of the main model collections (Sliders, Widgets, etc).
exports.collections = {}

# Called _once_ when the application is first loaded in the browser.
exports.boot = (window, { locale, api, user }) ->
  installConsolePolyfill window

  exports.user       = new (require('models/user').User) user
  exports.isSignedIn = exports.user.isSignedIn

  I18n.locale        = locale
  I18n.fallbacks     = no

  require('lib/api').setPath api

  exports.collections.scenes =
    new (require('collections/scenes').Scenes)

  exports.collections.scenarios =
    new (require('collections/scenarios').Scenarios)

  # Ensure that boot cannot be called again.
  exports.boot = (->)

  # Additional setup can be added here; tasks which can be executed in
  # parallel (API requests) should use async.parallel:
  #
  #   async.parallel one: something, two: somethingElse, postBoot
  #
  # ... for now we just call postBoot straight away.

  postBoot undefined, {}

# A wrapper around Backbone.Router::navigate which selects the correct router
# depending on the URL, and by default will run the action defined the router
# (Backbone by default does not do this).
#
exports.navigate = (url, trigger = true) ->
  # Remove leading slash, if present.
  url = url.slice(1, url.length) if url.slice(0, 1) is '/'

  exports.routers.main.navigate url, trigger

# Bootstrap Functions, execute in parallel -----------------------------------

# Called after all the other boot functions have completed.
#
# Issues a warning if one of the functions failed, otherwise finishes set-up
# of the application. Any part of the app set-up which depends must occur
# _after_ the asynchronous boostrap function should go here.
#
postBoot = (err, result) ->
  if err?
    console.error "Could not initialize application.", err
  else
    exports.routers.main = new (require('routers/main').Main)

    # Fire up Backbone routing...
    Backbone.history.start pushState: true

# Helper Functions -----------------------------------------------------------

installConsolePolyfill = (window) ->
  unless 'console' of window
    window.console = { log: (->), info: (->), warn: (->), error: (->) }
