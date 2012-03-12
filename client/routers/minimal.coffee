app          = require 'app'
notification = require 'templates/scenario_notification'

render       = require 'lib/render'

{ ScenarioSummaries } = require 'collections/scenario_summaries'
{ HighScores }        = require 'views/high_scores'
{ StaticHeader }      = require 'views/static_header'

# MINIMAL ROUTER -------------------------------------------------------------

# A Router which is used to progressively enhance otherwise static pages, such
# as setting up Pusher subscriptions for scenario updates, etc.
#
class exports.Minimal extends Backbone.Router
  routes:
    '':       'root'
    'root':   'root'
    'pusher': 'pusher'

  # The main landing page for ETFlex.
  #
  # Contains information about the application, and the top n scores list
  # using Pusher.
  #
  # GET /root
  #
  root: ->
    summaries  = new ScenarioSummaries(window.bootstrap or [])
    highScores = new HighScores collection: summaries

    $('#scores').html highScores.render().el

    new StaticHeader( el: $('#theme-header') ).render()

    render.enhance()
