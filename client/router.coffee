class ETF.Router extends Backbone.Router
  routes:
    'sanity': 'sanity'
    'etlite': 'etlite'

  initialize: ->
    @views =
      sanity: new ETF.Views.Sanity()
      etlite: new ETF.Views.ETLite()

  # A test page which shows the all of the application dependencies are
  # correctly installed and work as intended.
  #
  # GET #/sanity
  #
  sanity: ->
    console.log 'Welcome to the test page.'

    $('#chrome').
      html(@views.sanity.render().el).
      find('h1').css 'color', '#4b7b3d'

  # A recreation of the ETLite UI which serves as the starting point for
  # development of the full ETFlex application.
  #
  # GET #/etflex
  #
  etlite: ->
    console.log 'Welcome to the ETLite recreation.'

    $('#chrome').
      html(@views.etlite.render().el).
      find('h1').css 'color', '#4b7b3d'
