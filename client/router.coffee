app            = require 'app'
{ ModuleView } = require 'views/module'

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

    @views  = { sanity: new (require('views/sanity').SanityView)
              , etlite: new (require('views/etlite').ETLiteView) }

    super()

  # The root page; simply redirects to /sanity for now.
  #
  # GET /
  #
  root: ->
    app.router.navigate '/scenarios/1', true

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
    console.log @views
    render @views.etlite

  # Loads a module using JSON delivered from ETflex to set up which inputs and
  # visualiations are used.
  #
  # GET /scenario/:id
  #
  scenario: (id) ->
    if module = app.collections.modules.get id
      module.start (err, module, session) ->
        if err? then console.error err else
          render new ModuleView model: module
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
