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

    # Used while rendering so that elements immediately appear instead of
    # animating into place.
    @animate = true

    # We need the collection to re-sort whenever a summary score changes.
    @collection.on 'change:score', @collection.sort

    @collection.on 'add',    @summaryUpdated
    @collection.on 'change', @summaryUpdated

  # Renders a list containing the top five scoring scenarios. Presently render
  # is called each time the collection is changed regardless of whether the
  # top five have changed.
  render: =>
    @$el.empty()
    @animate = false

    for scenario in @collection.models
      @summaryUpdated scenario, null, false

    @animate = true
    this

  # Given a ScenarioSummary, adds it to the UI. If the scenario is already
  # visible, the existing UI will be updated.
  #
  summaryUpdated: (summary, ignore) =>
    isVisible = _.include @visible, summary.id
    isTopN    = @collection.isTopN  summary, @show

    if isVisible and not isTopN

      # Was previously a top-five summary but now is not. Remove it, and
      # promote the the new #5 to be displayed.

      @demote  summary
      @promote @collection.at @show - 1

    else if isVisible and isTopN

      # Was previously a top-five scenario, and still is.
      element = @summaryEl summary.get 'session_id'
      element.find('.score').text Math.round summary.get 'score'

      @sortSummaryEl summary, element

    else if isTopN

      # Is a newly promoted score. Remove the previous #5 element if one was
      # present (there may not be a #5 if scenarioUpdated is being called from
      # within the render method, or if it was triggered after the demotion of
      # another scenario.
      if (demoteEl = @$ "li:nth-child(#{ @show })").length
        dId = parseInt demoteEl.attr('id').replace(/^high-score-/, ''), 10
        @demote @collection.find (model) -> model.get('session_id') is dId

      @promote summary

  # Private ------------------------------------------------------------------

  # Returns the DOM element for a summary which corresponds with a given
  # sessionId.
  summaryEl: (sessionId) ->
    @$ "#high-score-#{ sessionId }"

  # Given a scenario summary, adds a DOM element to show the summary. Does not
  # re-sort the elements in the DOM, nor demotes the previous #5 scenario.
  promote: (summary) ->
    @visible.push summary.id

    @sortSummaryEl summary, $ template
      sessionId: summary.get 'session_id'
      score:     Math.round summary.get 'score'

  # Given a scenario summary, removes the DOM element which shows the summary.
  # Does not re-sort the elements in the DOM, nor does it promote the #6
  # element to #5.
  demote: (summary) ->
    @visible = _(@visible).without summary.id
    @summaryEl(summary.get 'session_id').remove()

  # Sorts the DOM elements so that they appear in descending order by score.
  #
  # It is assumed that all of the elements are already sorted, except for the
  # given scenario / element, whose score having changes, needs to be moved
  # to the correct position.
  #
  # summary - The ScenarioSummary.
  # element - The existing DOM element which represents the summary.
  #
  sortSummaryEl: (summary, element) ->
    elementId = element.attr 'id'
    position  = @collection.indexOf(summary) + 1
    currentAt = @$ "li:nth-child(#{ position })"

    # Don't mess about with the DOM if the element is already in the correct
    # place.
    unless currentAt.attr('id') is elementId
      element.detach()

      if currentAt.length and position isnt 5
        element.insertBefore currentAt
      else
        @$el.append element

    if @animate
      element.css('margin-left', '20px').
        animate({ 'margin-left': '0px' },
          duration: 750, easing: 'easeOutBounce')
