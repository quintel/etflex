app = require 'app'

{ Sanity } = require 'views/sanity'
{ ETLite } = require 'views/etlite'

# A simpler way to call `app.masterView.setSubView`.
render = (view) -> app.masterView.setSubView view

# Router watches the URL and, as it changes, re-renders the main view
# mimicking the user navigating from one page to another.
#
class exports.Router extends Backbone.Router
  routes:
    '':              'root'
    'sanity':        'sanity'
    'etlite':        'etlite'

    'scenarios/:id': 'scenario'

    'en':            'languageRedirect'
    'nl':            'languageRedirect'
    'en/*actions':   'languageRedirect'
    'nl/*actions':   'languageRedirect'

  constructor: ->
    # This should always be the first router since it catches any unmatched
    # routes from other routers -- Backbone appears to check routes in the
    # reverse order in which they are defined.
    @errors = new (require('routers/errors').Errors)

    super()
    @views = { sanity: new Sanity, etlite: new ETLite }

  # The root page; simply redirects to /sanity for now.
  #
  # GET /
  #
  root: ->
    app.router.navigate 'sanity', true

  # A test page which shows the all of the application dependencies are
  # correctly installed and work as intended.
  #
  # GET /sanity
  #
  sanity: ->
    render @views.sanity

  # A recreation of the ETLite UI which serves as the starting point for
  # development of the full ETFlex application.
  #
  # GET /etflex
  #
  etlite: ->
    render @views.etlite

  # Loads a scenario using JSON delivered from ETflex to set up which inputs
  # and visualiations are used.
  #
  # GET /scenario/:id
  #
  scenario: (id) ->
    if scenario = app.collections.scenarios.get id
      # Start the scenario.
      console.log 'Found scenario:', scenario
    else
      @errors.notFound()

  # Used when changing language; a two-character language code is appended to
  # the URL.
  #
  # GET /en/*actions
  # GET /nl/*actions
  #
  languageRedirect: (action) ->
    @navigate action or 'sanity', true
