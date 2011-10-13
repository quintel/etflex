# app.coffee contains the instance of the main application router, as
# well as any other objects which are considered "singletons", such as
# full-page views.

{ Inputs }  = require 'collections/inputs'
{ Queries } = require 'collections/queries'
{ Query }   = require 'models/query'

# Holds the router singleton. For the moment the application has only
# one; in time we may add more.
exports.router = null

# Holds each of the main model collections (Sliders, Widgets, etc).
exports.collections = {}

# Holds the Session singleton containing the user session information.
exports.session = null

# The singleton views/Master instance.
exports.masterView = null

# Called _once_ when the application is first loaded in the browser.
exports.bootstrap = (window) ->
  installConsolePolyfill window

  # TODO Eventually we will need to fetch Input and Query definitions from
  #      somewhere using XHR, so placing this above new Router won't be
  #      effective. Perhaps we can fetch these values _and_ create/resume the
  #      user session simultaneously, the finish the bootstrap after those
  #      have completed; using the async library:
  #
  #      https://github.com/caolan/async

  # Set up the collections.
  exports.collections.inputs  = new Inputs
  exports.collections.queries = new Queries

  # Create some sample inputs for new visitors.
  createDefaultInputs  exports.collections.inputs
  createDefaultQueries exports.collections.queries

  exports.router     = new (require('router').Router)
  exports.masterView = new (require('views/master').Master)

  # Create the user session.
  #
  # TODO We probably ought to set a short-term cookie containing the session
  #      ID so that we can easily resume a session if the user hits refresh.
  #
  require('models/session').createSession (err, session) =>
    if err?
      console.error 'Could not create user session'
    else
      exports.session = session

    # Fire up Backbone routing...
    Backbone.history.start pushState: true

# If the Inputs collection has no entries, this is the first time the user has
# visited the application. Create twelve sample inputs for the ETLite
# recreation page.
#
# This can be removed once ETEngine is integrated.
#
createDefaultInputs = (collection) ->
  head.destroy() while head = collection.first()

  fixtures = [
    { id:  43, name: 'Low-energy lighting',     start_value: 0, max_value:   100, unit: '%'   }
    { id: 146, name: 'Electric cars',           start_value: 0, max_value:   100, unit: '%'   }
    { id: 336, name: 'Better insulation',       start_value: 0, max_value:   100, unit: '%'   }
    { id: 348, name: 'Solar water heater',      start_value: 0, max_value:    80, unit: '%'   }
    { id: 366, name: 'Switch off appliances',   start_value: 0, max_value:    20, unit: '%'   }
    { id: 338, name: 'Heat pump for the home',  start_value: 0, max_value:    80, unit: '%'   }
    { id: 256, name: 'Coal-fired power plants', start_value: 0, max_value:     7, unit: ''    }
    { id: 315, name: 'Gas-fired power plants',  start_value: 0, max_value:     7, unit: ''    }
    { id: 259, name: 'Nuclear power plants',    start_value: 0, max_value:     4, unit: ''    }
    { id: 263, name: 'Wind turbines',           start_value: 0, max_value: 10000, unit: ''    }
    { id: 313, name: 'Solar panels',            start_value: 0, max_value: 10000, unit: ''    }
    { id: 272, name: 'Biomass',                 start_value: 0, max_value:  1606, unit: ' km<sup>2</sup>' }
  ]

  collection.create fixture for fixture in fixtures

# Creates the default Query instances.
#
# This can be removed once there's a better infrastructure in place for
# storing and retrieving Query instances.
#
createDefaultQueries = (collection) ->
  collection.add id:   8 # co2_emission_total
  collection.add id:  23 # costs_total
  collection.add id:  31 # share_of_renewable_electricity
  collection.add id:  49 # electricity_production
  collection.add id: 518 # final_demand_electricity

installConsolePolyfill = (window) ->
  unless 'console' of window
    window.console = { log: (->), info: (->), warn: (->), error: (->) }
