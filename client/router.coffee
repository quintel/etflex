class ETF.Router extends Backbone.Router
  routes:
    'sanity': 'sanity'
    'etlite': 'etlite'

  # A test page which shows the all of the application dependencies are
  # correctly installed and work as intended.
  #
  # GET #/sanity
  #
  sanity: ->
    console.log 'Welcome to the test page.'

    $('#chrome').
      html($etf.views.sanity.render().el).
      find('h1').css 'color', '#4b7b3d'

  # A recreation of the ETLite UI which serves as the starting point for
  # development of the full ETFlex application.
  #
  # GET #/etflex
  #
  etlite: ->
    console.log 'Welcome to the ETLite recreation.'

    $('#chrome').
      html($etf.views.etlite.render().el).
      find('h1').css 'color', '#4b7b3d'
