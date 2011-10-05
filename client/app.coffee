# app.coffee contains the instance of the main application router, as
# well as any other objects which are considered "singletons", such as
# full-page views.

{ Inputs } = require 'collections/inputs'

# Holds the router singleton. For the moment the application has only
# one; in time we may add more.
exports.router = null

# Holds each of the main model collections (Sliders, Widgets, etc).
exports.collections = {}

# Called _once_ when the application is first loaded in the browser.
exports.bootstrap = (window) ->
  exports.router = new (require('router').Router)

  # Set up the collections.
  (exports.collections.inputs = new Inputs).fetch()

  # Create some sample inputs for new visitors.
  createDefaultInputs exports.collections.inputs

  # Fire up Backbone routing...
  Backbone.history.start pushState: true

# If the Inputs collection has no entries, this is the first time the user has
# visited the application. Create twelve sample inputs for the ETLite
# recreation page.
#
# This can be removed once ETEngine is integrated.
#
createDefaultInputs = (collection) ->
  collection.each (input) -> input.destroy()

  if collection.length isnt 12
    collection.add [
      { name: 'Energy-saving bulbs', start:  0, max:   100, key: '%'   }
      { name: 'Electric cars',       start: 30, max:   100, key: '%'   }
      { name: 'Better insulation',   start: 12, max:   100, key: '%'   }
      { name: 'Solar power',         start: 24, max:   100, key: '%'   }
      { name: 'Devices',             start: 56, max:   100, key: '%'   }
      { name: 'Home heating',        start: 53, max:   100, key: '%'   }
      { name: 'Coal power plants',   start:  0, max:     7, key: ''    }
      { name: 'Gas power plants',    start:  0, max:     7, key: ''    }
      { name: 'Nuclear power plants',start:  0, max:     4, key: ''    }
      { name: 'Wind turbines',       start:  0, max: 10000, key: ''    }
      { name: 'Solar panels',        start:  0, max: 10000, key: ''    }
      { name: 'Biomass',             start:  0, max:  1606, key: 'km2' }
    ]

    collection.each (input) -> input.save()
