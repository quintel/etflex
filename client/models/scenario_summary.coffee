{ Query } = require 'models/query'

# The Summary class is a lightweight Scenario used by Pusher to show basic
# information such as scenario user names and high scores.
class exports.ScenarioSummary extends Backbone.Model
  idAttribute: 'session_id'

  # Returns a Query, setting the future value to the value in the summary.
  query: (key) ->
    new Query
      id:     if key is 'score' then 'etflex_score' else key
      future: @get key
