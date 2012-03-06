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
    @rows    = {}

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
      # element = @summaryEl summary.get 'session_id'
      # element.find('.score').text Math.round summary.get 'score'

      # Move the element to its new position; the SummaryRow will update the
      # values shown.
      @sortSummaryEl @rows[summary.id]

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
    @rows[summary.id] = new SummaryRow(model: summary).render()

    @sortSummaryEl @rows[ summary.id ]

  # Given a scenario summary, removes the DOM element which shows the summary.
  # Does not re-sort the elements in the DOM, nor does it promote the #6
  # element to #5.
  demote: (summary) ->
    @visible = _(@visible).without summary.id

    @rows[summary.id].remove()
    delete @rows[summary.id] # GC.

  # Sorts the DOM elements so that they appear in descending order by score.
  #
  # It is assumed that all of the elements are already sorted, except for the
  # given scenario / element, whose score having changes, needs to be moved
  # to the correct position.
  #
  # row - The SummaryRow view.
  #
  sortSummaryEl: (row) ->
    position  = @collection.indexOf(row.model) + 1
    currentAt = @$ "li:nth-child(#{ position })"

    # Don't mess about with the DOM if the element is already in the correct
    # place.
    unless currentAt.attr('id') is row.id
      row.$el.detach()

      if currentAt.length and position isnt @show
        nextRow = @rows[ @collection.at(position).id ]

        # Note that we get the nth-child again, as getting the correct element
        # when moving the row down requires first detaching the current row.
        row.$el.insertBefore nextRow.$el
      else
        @$el.append row.$el

      # Update the #1, #2, etc.
      for index in [ 0...@show ]
        @rows[ @collection.at(index).id ]?.updatePosition index + 1

      if @animate
        row.$el.css('margin-left', '20px').
          animate({ 'margin-left': '0px' },
            duration: 750, easing: 'easeOutBounce')

# SummaryRow -----------------------------------------------------------------

# Encapsulates a single high score row, binding events, etc.
#
# When using SummaryRow within another view (e.g. HighScores) remember to
# always call SummaryRow::remove() so that the events may be removed from the
# model. Failure to do so will result in the callbacks in SummaryRow being run
# when the model changes, even if the Row is no longer visible.
#
class SummaryRow extends Backbone.View
  tagName: 'li'

  modelEvents:
    'change:score':               'updateScore'
    'change:total_co2_emissions': 'updateEmissions'
    'change:total_costs':         'updateCost'
    'change:renewability':        'updateRenewability'
    'change:updated_at':          'updateTime'

  constructor: (options) ->
    options.id = "high-score-#{ options.model.get('session_id') }"
    super options

  render: ->
    @$el.html template
      user:      'Some User'
      time:      '2 minutes ago'
      href:      @model.get 'href'
      sessionId: @model.get 'session_id'

    for own event, func of @modelEvents
      # Bind the model events to update the view when they change.
      @model.on event, this[func]

      # Immediately run the event callbacks so that the correct values are
      # present in the view.
      @[func] @model, @model.get(event.split(':')[1])

    this

  remove: ->
    super # Remove elements from the DOM.

    # Unbind events from the model.
    @model.off event, @[func] for own event, func of @modelEvents

  updateScore: (summary, score) =>
    @$('.score').text Math.round(score)

  updateEmissions: (summary, emissions) =>
    @$('.emissions').text(
      "#{I18n.toNumber(emissions / 1000000000, precision: '1')} Mton")

  updateCost: (summary, cost) =>
    @$('.costs').text(
      "#{ I18n.toCurrency(cost / 1000000000, unit: '€', precision: 1) }b")

  updateRenewability: (summary, renewables) =>
    @$('.renewables').text I18n.toPercentage(renewables * 100, precision: 1)

  updateTime: (summary, time) =>
    @$('.when').text I18n.l('time.formats.long', time)

  updatePosition: (position) ->
    @$('.position').text "##{position}"
