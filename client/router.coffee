app = require 'app'

{ Sanity } = require 'views/sanity'
{ ETLite } = require 'views/etlite'

# Router watches the URL and, as it changes, re-renders the main view
# mimicking the user navigating from one page to another.
#
class exports.Router extends Backbone.Router
  routes:
    '':       'root'
    'sanity': 'sanity'
    'etlite': 'etlite'

  constructor: ->
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
    app.setView @views.sanity

  # A recreation of the ETLite UI which serves as the starting point for
  # development of the full ETFlex application.
  #
  # GET /etflex
  #
  etlite: ->
    app.setView @views.etlite
