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
  if collection.length isnt 12
    head.destroy() while head = collection.first()

    fixtures = [
      { name: 'Energy-saving bulbs',  value:  0, max:   100, unit: '%'   }
      { name: 'Electric cars',        value: 30, max:   100, unit: '%'   }
      { name: 'Better insulation',    value: 12, max:   100, unit: '%'   }
      { name: 'Solar power',          value: 24, max:   100, unit: '%'   }
      { name: 'Devices',              value: 56, max:   100, unit: '%'   }
      { name: 'Home heating',         value: 53, max:   100, unit: '%'   }
      { name: 'Coal power plants',    value:  0, max:     7, unit: ''    }
      { name: 'Gas power plants',     value:  0, max:     7, unit: ''    }
      { name: 'Nuclear power plants', value:  0, max:     4, unit: ''    }
      { name: 'Wind turbines',        value:  0, max: 10000, unit: ''    }
      { name: 'Solar panels',         value:  0, max: 10000, unit: ''    }
      { name: 'Biomass',              value:  0, max:  1606, unit: ' km<sup>2</sup>' }
    ]

    collection.create fixture for fixture in fixtures
