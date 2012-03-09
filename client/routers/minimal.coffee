app          = require 'app'
notification = require 'templates/scenario_notification'

render       = require 'lib/render'

{ ScenarioSummary }   = require 'models/scenario_summary'
{ ScenarioSummaries } = require 'collections/scenario_summaries'
{ HighScores }        = require 'views/high_scores'
{ StaticHeader }      = require 'views/static_header'

# Callback triggered whenever Pusher notifies us of a new or updates scenario.
# We update the given ScenarioSummaries collection, creating or updating the
# summary as necessary.
#
scenarioNotification = (collection) ->
  (data) ->
    if summary = collection.get data.session_id
      event = 'scenario.updated'
      summary.set data
    else
      event = 'scenario.created'
      summary = new ScenarioSummary data
      collection.add summary

    $('#scenarios .none').remove()
    $('#scenarios').prepend $('<li/>').html notification { event, data }

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
    highScores = new HighScores collection: summaries, show: 10

    pusher     = new Pusher '415cc8feb622f665d49a'
    channel    = pusher.subscribe "etflex-#{ app.env }"

    channel.bind 'scenario.created', scenarioNotification(summaries)
    channel.bind 'scenario.updated', scenarioNotification(summaries)

    $('#scores').html highScores.render().el

    new StaticHeader( el: $('#theme-header') ).render()

    render.enhance()
