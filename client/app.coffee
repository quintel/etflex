# app.coffee contains the instance of the main application router, as
# well as any other objects which are considered "singletons", such as
# full-page views.

{ Inputs } = require 'collections/inputs'

# Holds the router singleton. For the moment the application has only
# one; in time we may add more.
exports.router = null

# Holds each of the main model collections (Sliders, Widgets, etc).
exports.collections = {}

# Holds the Session singleton containing the user session information.
exports.session = null

# Called _once_ when the application is first loaded in the browser.
exports.bootstrap = (window) ->
  installConsolePolyfill window

  exports.router = new (require('router').Router)

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

    # Set up the collections.
    (exports.collections.inputs = new Inputs).fetch()

    # Create some sample inputs for new visitors.
    createDefaultInputs exports.collections.inputs

    # Also temporary...
    exports.collections.inputs.bind 'change:value', (input) ->
      session.updateInputs [ input ], (err) -> console.log 'Update!', err

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

installConsolePolyfill = (window) ->
  unless 'console' of window
    window.console = { log: (->), info: (->), warn: (->), error: (->) }
