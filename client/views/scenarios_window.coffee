template       = require 'templates/scenarios_window'

{ ScenarioSummaries } = require 'collections/scenario_summaries'
{ HighScores }        = require 'views/high_scores'

class exports.ScenariosWindow extends Backbone.View
  className: 'overlay-content high-scores-overlay'

  events:
    'click .high-scores li': 'activateScenario'

  # Creates a new ScenariosWindow. Loads the high scores and stuff. :D
  constructor: (options) ->
    @scores   = new HighScores show: 8, style: 'compact', realtime: false
    @scenario = options.scenario

    super

  # Creates the HTML for the scenarios window. Does not place anything into
  # the DOM.
  #
  # Returns self.
  #
  render: ->
    @$el.html template()
    @$('.high-scores').append @scores.render().el
    @$('.since').addClass 'nav'

    this

  # Callback triggered when the user click on one of the high scoring
  # scenarios. Shows a summary of the scenarios in the right-hand pane.
  #
  activateScenario: (event) =>
    scenarioId = event.currentTarget.id.replace(/^high-score-/, '')
    scenarioId = parseInt scenarioId, 10

    if scenario = @scores.collection.get scenarioId
      @scores.$('li').removeClass 'active'
      $( event.currentTarget ).addClass 'active'

      console.log @$('.info .content').html """
        Score: #{ scenario.query('score').formatted('future') }<br />
        Renewability: #{ scenario.query('renewability').formatted('future') }<br />
        Costs: #{ scenario.query('total_costs').formatted('future') }<br />
        CO2: #{ scenario.query('total_co2_emissions').formatted('future') }<br />
        By: #{ scenario.get('user_name') }<br />
      """

      console.log "Would navigate to #{ scenario.get('href') }"

      # Navigation temporarily disabled until a view "destructor" is
      # created so that we can properly remove the old scenario before
      # starting the new one.
      # app.navigate scenario.get('href')
