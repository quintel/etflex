# app.coffee contains the instance of the main application router, as
# well as any other objects which are considered "singletons", such as
# full-page views.

session          = require 'models/session'

{ Inputs }       = require 'collections/inputs'
{ Queries }      = require 'collections/queries'
{ Scenarios }    = require 'collections/scenarios'

{ InputManager } = require 'lib/input_manager'

# Holds the router singleton. For the moment the application has only
# one; in time we may add more.
exports.router = null

# Holds each of the main model collections (Sliders, Widgets, etc).
exports.collections = {}

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
  exports.collections.inputs    = new Inputs
  exports.collections.queries   = new Queries
  exports.collections.scenarios = new Scenarios

  async.parallel data: fetchInitialData, postBoot

# Bootstrap Functions, execute in parallel -----------------------------------

# Retrieves static data such as input and query definitions. Ideally it should
# be possible for the remote API to deliver this all in a single response.
#
fetchInitialData = (callback) ->
  createDefaultInputs    exports.collections.inputs
  createDefaultQueries   exports.collections.queries
  createDefaultScenarios exports.collections.scenarios

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
    exports.router       = new (require('router').Router)
    exports.masterView   = new (require('views/master').MasterView)

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
    { id:  43, key: 'lighting',   start_value: 5, max_value:   100, unit: '%', disabled: true }
    { id: 146, key: 'cars',       start_value: 0, max_value:   100, unit: '%', disabled: true }
    { id: 336, key: 'insulation', start_value: 1, max_value:   100, unit: '%', disabled: true }
    { id: 348, key: 'heating',    start_value: 0, max_value:    80, unit: '%'   }
    { id: 366, key: 'appliances', start_value: 0, max_value:    20, unit: '%'   }
    { id: 338, key: 'heatPump',   start_value: 0, max_value:    80, unit: '%'   }
    { id: 315, key: 'coal',       start_value: 0, max_value:     7, unit: ''    }
    { id: 256, key: 'gas',        start_value: 0, max_value:     7, unit: ''    }
    { id: 259, key: 'nuclear',    start_value: 0, max_value:     4, unit: ''    }
    { id: 263, key: 'wind',       start_value: 0, max_value: 10000, unit: ''    }
    { id: 313, key: 'solar',      start_value: 0, max_value: 10000, unit: ''    }
    { id: 196, key: 'biomass',    start_value: 0, max_value:  1606, unit: ' km<sup>2</sup>' }
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

# Creates a single Scenario; the ETlite scenario.
#
# This can be removed once scenarios are defined on the server and delivered
# as JSON to the client.
#
createDefaultScenarios = (collection) ->
  collection.add
    id:   1
    name: 'ETlite'

    leftInputs:  [  43, 146, 336, 348, 366, 338 ]
    rightInputs: [ 315, 256, 259, 263, 313, 196 ]

    centerVis:     require('views/vis/supply_demand').SupplyDemandView
    mainVis:     [ require('views/vis/renewables').RenewablesView,
                   require('views/vis/co2_emissions').CO2EmissionsView
                   require('views/vis/costs').CostsView ]

installConsolePolyfill = (window) ->
  unless 'console' of window
    window.console = { log: (->), info: (->), warn: (->), error: (->) }
