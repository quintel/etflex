template = require 'templates/high_score'

# Shows the top five scoring scenario summaries in a list.
class exports.HighScores extends Backbone.View
  className: 'high-scoring-scenarios'
  tagName:   'ol'

  # Provide HighScores with a ScenarioSummaries collection in the options
  # hash.
  constructor: ({ @collection, @show }) ->
    super

    # Show, by default, the five highest scores.
    @show or= 5

    # Keep track of the summaries which are shown in the UI.
    @visible = []

    # We need the collection to re-sort whenever a summary score changes.
    @collection.on 'change:score', @collection.sort

    @collection.on 'add',    @summaryUpdated
    @collection.on 'change', @summaryUpdated

  # Renders a list containing the top five scoring scenarios. Presently render
  # is called each time the collection is changed regardless of whether the
  # top five have changed.
  render: =>
    @$el.empty()

    if @collection.length isnt 0
      $('li.none').remove()

    for scenario in @collection.models
      @summaryUpdated scenario, false

    this

  # Given a ScenarioSummary, adds it to the UI. If the scenario is already
  # visible, the existing UI will be updated.
  #
  summaryUpdated: (summary) =>
    isVisible = _.include @visible, summary.id
    isTopN    = @collection.isTopN  summary, @show
    position  = @collection.indexOf summary if isTopN

    if isVisible and not isTopN

      # Was previously a top-five summary but now is not. Remove it, and
      # promote the the new #5 to be displayed.

      @demote  summary
      @promote @collection.at @show - 1

    else if isVisible and isTopN

      # Was previously a top-five scenario, and still is.
      @summaryEl(summary.get 'session_id').
        find('.score').text Math.round summary.get 'score'

      # TODO We need to re-sort the DOM elements to keep the scenarios sorted
      #      in score order.

    else if isTopN

      # Is a newly promoted score. Remove the previous #5 element if one was
      # present (there may not be a #5 if scenarioUpdated is being called from
      # within the render method, or if it was triggered after the demotion of
      # another scenario.
      if (demoteEl = @$ "li:nth-child(#{ @show })").length
        dId = parseInt demoteEl.attr('id').replace(/^high-score-/, ''), 10
        @demote @collection.find (model) -> model.get('session_id') is dId

      @promote summary

      # TODO We need to re-sort the DOM elements to keep the scenarios sorted
      #      in score order.

  # Private ------------------------------------------------------------------

  # Returns the DOM element for a summary which corresponds with a given
  # sessionId.
  summaryEl: (sessionId) ->
    @$ "#high-score-#{ sessionId }"

  # Given a scenario summary, adds a DOM element to show the summary. Does not
  # re-sort the elements in the DOM, nor demotes the previous #5 scenario.
  promote: (summary) ->
    @visible.push summary.id

    @$el.append template
      sessionId: summary.get 'session_id'
      score:     Math.round summary.get 'score'

  # Given a scenario summary, removes the DOM element which shows the summary.
  # Does not re-sort the elements in the DOM, nor does it promote the #6
  # element to #5.
  demote: (summary) ->
    @visible = _(@visible).without summary.id
    @summaryEl(summary.get 'session_id').remove()
