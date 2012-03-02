class exports.ScenarioSummaries extends Backbone.Collection
  model: require('models/scenario_summary').ScenarioSummary

  # Sorts summaries by score in descending order.
  comparator: (summary) -> - summary.get('score')
