class @Router extends Backbone.Router
  routes:
    '':       'root'
    'sanity': 'sanity'
    'etlite': 'etlite'

  # The root page; currently redirects to the sanity test page.
  #
  # GET #/
  #
  root: ->
    window.location = "#{window.location}#sanity"

  # A test page which shows the all of the application dependencies are
  # correctly installed and work as intended.
  #
  # GET #/sanity
  #
  sanity: ->
    console.log 'Welcome to the test page.'

  # A recreation of the ETLite UI which serves as the starting point for
  # development of the full ETFlex application.
  #
  # GET #/etflex
  #
  etlite: ->
    console.log 'Welcome to the ETLite recreation.'
