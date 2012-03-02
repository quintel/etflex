class exports.ScenarioSummaries extends Backbone.Collection
  model: require('models/scenario_summary').ScenarioSummary

  # Sorts summaries by score in descending order.
  comparator: (summary) -> - summary.get('score')

  # Returns whether the given score summary places it within the top N of
  # summaries in the collection.
  isTopN: (summary, n) ->
    return true if @length < n

    atN = @at n - 1
    atN.id is summary.id or atN.get('score') < summary.get('score')
