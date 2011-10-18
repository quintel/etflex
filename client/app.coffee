# app.coffee contains the instance of the main application router, as
# well as any other objects which are considered "singletons", such as
# full-page views.

session          = require 'models/session'

{ Inputs }       = require 'collections/inputs'
{ Queries }      = require 'collections/queries'

{ InputManager } = require 'lib/input_manager'

# Holds the router singleton. For the moment the application has only
# one; in time we may add more.
exports.router = null

# Holds each of the main model collections (Sliders, Widgets, etc).
exports.collections = {}

# Holds the Session singleton containing the user session information.
exports.session = null

# The singleton views/Master instance.
exports.masterView = null

# Used to simplify persistance of Inputs and Queries.
exports.inputManager = null

# Called _once_ when the application is first loaded in the browser.
exports.boot = (window, locale) ->
  installConsolePolyfill window

  I18n.locale    = locale
  I18n.fallbacks = no

  # Set up the collections.
  exports.collections.inputs  = new Inputs
  exports.collections.queries = new Queries

  async.parallel data: fetchInitialData, session: initSession, postBoot

# Bootstrap Functions, execute in parallel -----------------------------------

# Sets up the user's session with ETengine. If they already have a session
# active, it will be restored; otherwise a new session is created.
#
# See `initSession` in models/session.coffee for more information.
#
initSession = (callback) ->
  session.initSession (err, session) ->
    if err? then callback err else callback null, session

# Retrieves static data such as input and query definitions. Ideally it should
# be possible for the remote API to deliver this all in a single response.
#
fetchInitialData = (callback) ->
  createDefaultInputs  exports.collections.inputs
  createDefaultQueries exports.collections.queries

  callback null, true

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
    exports.session = result.session
    exports.session.finalizeInputs exports.collections.inputs

    exports.router       = new (require('router').Router)
    exports.masterView   = new (require('views/master').Master)

    exports.inputManager = new InputManager exports.session

    # Fire up Backbone routing...
    Backbone.history.start pushState: true

# Helper Functions -----------------------------------------------------------

# If the Inputs collection has no entries, this is the first time the user has
# visited the application. Create twelve sample inputs for the ETLite
# recreation page.
#
# This can be removed once ETEngine is integrated.
#
createDefaultInputs = (collection) ->
  head.destroy() while head = collection.first()

  fixtures = [
    { id:  43, name: 'Low-energy lighting',     start_value: 5, max_value:   100, unit: '%'   }
    { id: 146, name: 'Electric cars',           start_value: 0, max_value:   100, unit: '%'   }
    { id: 336, name: 'Better insulation',       start_value: 1, max_value:   100, unit: '%'   }
    { id: 348, name: 'Solar water heater',      start_value: 0, max_value:    80, unit: '%'   }
    { id: 366, name: 'Switch off appliances',   start_value: 0, max_value:    20, unit: '%'   }
    { id: 338, name: 'Heat pump for the home',  start_value: 0, max_value:    80, unit: '%'   }
    { id: 315, name: 'Coal-fired power plants', start_value: 0, max_value:     7, unit: ''    }
    { id: 256, name: 'Gas-fired power plants',  start_value: 0, max_value:     7, unit: ''    }
    { id: 259, name: 'Nuclear power plants',    start_value: 0, max_value:     4, unit: ''    }
    { id: 263, name: 'Wind turbines',           start_value: 0, max_value: 10000, unit: ''    }
    { id: 313, name: 'Solar panels',            start_value: 0, max_value: 10000, unit: ''    }
    { id: 196, name: 'Biomass',                 start_value: 0, max_value:  1606, unit: ' km<sup>2</sup>' }
  ]

  collection.add fixture for fixture in fixtures

# Creates the default Query instances.
#
# This can be removed once there's a better infrastructure in place for
# storing and retrieving Query instances.
#
createDefaultQueries = (collection) ->
  collection.add id:   8 # co2_emission_total
  collection.add id:  23 # costs_total
  collection.add id:  32 # share_of_renewable_energy
  collection.add id:  49 # electricity_production
  collection.add id: 518 # final_demand_electricity

installConsolePolyfill = (window) ->
  unless 'console' of window
    window.console = { log: (->), info: (->), warn: (->), error: (->) }
