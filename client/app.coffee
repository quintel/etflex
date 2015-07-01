# Tells you if the application has been booted. Simple, "stand-alone" pages
# may use parts of the client code (such as a navigation menus) without
# booting the whole client.
exports.isBooted = false

# Use real-time features using Pusher?
exports.pusher_key = true

# Behave as if ETFlex is being displayed at a conference?
exports.conference = false

# Are features related to scores (the podium, high score list, etc) enabled?
exports.scores = true

# Custom version of ETFlex to show (e.g. energyfuture.nl iframe).
exports.mode = 'normal'

# Holds the instantiated routers so that we can refer to them later.
exports.routers = {}

# Holds each of the main model collections (Sliders, Widgets, etc).
exports.collections = {}

# The global Pusher connection.
exports.pusher = null

# Called _once_ when the application is first loaded in the browser.
exports.boot = (window, { locale, api, env, user, pusher_key, conference, offline, etm_url, scores }) ->
  installConsolePolyfill window

  # Current user
  exports.env        = env
  exports.user       = require('models/user').createUser user
  exports.pusher_key = pusher_key
  exports.conference = conference
  exports.scores     = scores
  exports.offline    = offline
  exports.mode       = modeFromUrl()
  exports.etm_url    = etm_url

  # Languages
  I18n.locale    = locale
  I18n.fallbacks = no

  moment.lang locale
  $('body').addClass(exports.mode)

  setGlobalCssClasses({ scores, conference, offline })

  # Pusher notifications.
  if exports.pusher_key
    exports.pusher = new Pusher(exports.pusher_key).
      # Temporarily hardcoded
      subscribe("etflex-staging")

  # Engine API.
  require('lib/api').setPath api, offline

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

  # Callbacks for when the username changes.
  exports.on 'current-user.name.request-change', currentUserNameChangeRequest
  exports.on 'current-user.name.changed',        currentUserNameChanged

# PubSub Implementation ------------------------------------------------------

exports.on      = (args...) -> Backbone.Events.on.apply      exports, args
exports.off     = (args...) -> Backbone.Events.off.apply     exports, args
exports.trigger = (args...) -> Backbone.Events.trigger.apply exports, args

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

modeFromUrl = ->
  if window.location.search.match(/\bmode=energyfuture\b/)
    'energyfuture'
  else
    'normal'

# Given an object containing keys and values which are true or false, sets
# classes on the body element so that CSS can read the settings.
#
# For example:
#
#   setBodyClasses(score: true, conference: false)
#   # body.score.no-conference
setGlobalCssClasses = (options) ->
  el = $('html')

  for own key, value of options
    if value then el.addClass(key) else el.addClass("no-#{ key }")

# Global PubSub Events -------------------------------------------------------

# Handler for when a component wants to change the name of the currently
# logged in user, or guest.
currentUserNameChangeRequest = (name) ->
  exports.user.name = name
  exports.trigger 'current-user.name.changed', name, exports.user

# Triggered after the current user name is changed. Typically occurs when a
# new user starts a scenario for the first time, or a guest changes their name
# on the high score popup.
currentUserNameChanged = (name) ->
  jQuery.ajax url: '/me', type: 'PUT', data: { user: { name: name } }
