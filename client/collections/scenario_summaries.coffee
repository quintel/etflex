class exports.ScenarioSummaries extends Backbone.Collection
  model: require('models/scenario_summary').ScenarioSummary

  # Sorts summaries by score in descending order.
  comparator: (summary) -> - summary.get('score')

  # Returns whether the given score summary places it within the top N of
  # summaries in the collection.
  #
  # Note that any summaries which do not have a user name set are *excluded*
  # when determining which scenarios are in the top N.
  isTopN: (summary, n) ->
    isWithinThreshold summary, @models, n

  # Returns whether the given score summary should be displayed in the top N
  # list of summaries.
  #
  # This differs slightly from isTopN in that only summaries which have a
  # username are considered worth of display.
  shouldDisplay: (summary, n) ->
    return false unless summary.get('user_name')?.match(/\S/)

    topSummaries = @filter (summary) -> summary.get('user_name')?
    isWithinThreshold summary, topSummaries, n

# HELPERS --------------------------------------------------------------------

isWithinThreshold = (summary, collection, n) ->
  return true if collection.length < n

  # The summary which currently occupies the "last" position in the high
  # scores collection...
  atThreshold = collection[ n - 1 ]

  atThreshold.id is summary.id or
    atThreshold.get('score') <= summary.get('score')
