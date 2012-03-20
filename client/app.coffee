# app.coffee contains the instance of the main application router, as
# well as any other objects which are considered "singletons", such as
# full-page views.

# Tells you if the application has been booted. Simple, "stand-alone" pages
# may use parts of the client code (such as a navigation menus) without
# booting the whole client.
exports.isBooted = false

# Holds the instantiated routers so that we can refer to them later.
exports.routers = {}

# Holds each of the main model collections (Sliders, Widgets, etc).
exports.collections = {}

# The global Pusher connection.
exports.pusher = null

# Called _once_ when the application is first loaded in the browser.
exports.boot = (window, { locale, api, env, user }) ->
  installConsolePolyfill window

  # Current user
  exports.env    = env
  exports.user   = require('models/user').createUser user

  # Languages
  I18n.locale    = locale
  I18n.fallbacks = no

  moment.lang locale

  # Pusher notifications.
  exports.pusher = new Pusher('415cc8feb622f665d49a').
    subscribe("etflex-#{ exports.env }")

  # Engine API.
  require('lib/api').setPath api

  # Common collections.
  exports.collections.scenes =
    new (require('collections/scenes').Scenes)

  exports.collections.scenarios =
    new (require('collections/scenarios').Scenarios)

  # We currently have only a single router.
  exports.routers.main = new (require('routers/main').Main)

  # Ensure that boot cannot be called again.
  exports.boot = (->)
  exports.isBooted = true

  # Fire up Backbone routing...
  Backbone.history.start pushState: true

# Helper Functions -----------------------------------------------------------

# Returns if the application is being run in the staging environment.
exports.isBeta = () ->
  exports.env is 'staging'

# A wrapper around Backbone.Router::navigate which selects the correct router
# depending on the URL, and by default will run the action defined the router
# (Backbone by default does not do this).
#
exports.navigate = (url, options = {}) ->
  # Remove leading slash, if present.
  url = url.slice(1, url.length) if url.slice(0, 1) is '/'

  unless options.hasOwnProperty 'trigger'
    options.trigger = true

  exports.routers.main.navigate url, options

# Old browsers lack console support.
installConsolePolyfill = (window) ->
  unless 'console' of window
    window.console = { log: (->), info: (->), warn: (->), error: (->) }
