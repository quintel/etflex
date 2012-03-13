app                   = require 'app'

listTemplate          = require 'templates/high_scores'
rowTemplate           = require 'templates/high_score'

{ relativeTime }      = require 'lib/time_helpers'
{ ScenarioSummary }   = require 'models/scenario_summary'
{ ScenarioSummaries } = require 'collections/scenario_summaries'

# Shows the top five scoring scenario summaries in a list.
class exports.HighScores extends Backbone.View
  className: 'high-scoring-scenarios'

  events:
    'click h2 a': 'changeDateLimit'

  # Provide HighScores with a ScenarioSummaries collection in the options
  # hash.
  constructor: ({ @collection, @show }) ->
    super

    # Show, by default, the five highest scores.
    @show or= 10

    # Keep track of the summaries which are shown in the UI.
    @visible = []
    @rows    = {}

    # Used while rendering so that elements immediately appear instead of
    # animating into place.
    @animate = true

  # Renders a list containing the top five scoring scenarios. Presently render
  # is called each time the collection is changed regardless of whether the
  # top five have changed.
  render: =>
    @$el.html listTemplate()
    @listElement = @$ 'ol'

    # Render the list.
    @setCollection @collection

    channel = app.pusher.subscribe "etflex-#{ app.env }"

    channel.bind 'scenario.created', @scenarioNotification
    channel.bind 'scenario.updated', @scenarioNotification

    this

  # Given a ScenarioSummaries collection, tells the HighScores to change the
  # current collection, and re-render the high scores list.
  #
  setCollection: (newCollection) ->
    # Unbind events from the old collection.
    @collection.off 'change:score', @collection.sort
    @collection.off 'add',          @summaryUpdated
    @collection.off 'change',       @summaryUpdated

    @collection = newCollection

    # We need the collection to re-sort whenever a summary score changes.
    @collection.on 'change:score', @collection.sort

    @collection.on 'add',    @summaryUpdated
    @collection.on 'change', @summaryUpdated

    # Re-render the list.
    @listElement.empty()
    @animate = false

    for scenario in @collection.models[ 0...@show ]
      @summaryUpdated scenario, null, false

    @animate = true

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

  # Callback triggered when the user clicks on of the date links which are
  # part of the header ("today", "seven days", etc). Does nothing if the
  # clicked link is the currently active period.
  #
  changeDateLimit: (event) ->
    target = $ event.target

    unless target.hasClass 'current'
      @$('h2 a.current').removeClass('current')
      target.addClass('current')

      @loadSince target.data('since')

    return event.preventDefault()

  # Sets how far back we should go when retrieving high scores.
  #
  # Days may be 1, 7, or "alltime". Note that setSince is asynchronous and
  # only applies the change after successful completion of an XHR request.
  #
  loadSince: (days) ->
    jQuery.getJSON("/scenarios/since/#{ days }.json")
      .done( (data) => @setCollection new ScenarioSummaries data)
      .fail(        -> console.error 'Failed to fetch high scores')

  # Callback triggered by Pusher whenever a scenario is added or updated by
  # another visitor to the website.
  #
  scenarioNotification: (data) =>
    if summary = @collection.get data.session_id
      summary.set data
    else
      @collection.add new ScenarioSummary data

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
        @listElement.append row.$el

      # Update the #1, #2, etc.
      for index in [ 0...@show ]
        if model = @collection.at(index)
          @rows[ model.id ]?.updatePosition index + 1
        else
          break

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
    'change:renewability':        'updateRenewables'
    'change:updated_at':          'updateTime'

  constructor: (options) ->
    options.id = "high-score-#{ options.model.get('session_id') }"
    super options

  render: ->
    @$el.html rowTemplate
      user:         @model.get 'user_name'
      href:         @model.get 'href'
      sessionId:    @model.get 'session_id'
      imageUrl:     @model.get 'profile_image'

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

  # Model update callbacks ---------------------------------------------------

  updateScore: (summary, score) =>
    @$('.score').text Math.round(score)

  updateTime: (summary, time) =>
    @$('time').replaceWith relativeTime(time)

  updatePosition: (position) ->
    @$('.position').text "#{position}"

  updateCost: (summary, cost) =>
    @updateMetric '.costs', cost / 1000000000, 40, 50

  updateRenewables: (summary, renewables) =>
    @updateMetric '.renewables', renewables * 100, 0, 20

  updateEmissions: (summary, emissions) =>
    @updateMetric '.emissions', emissions / 1000000000, 120, 145

  # Helpers ------------------------------------------------------------------

  # Updates a displayed metric.
  #
  # selector - The CSS class corresponding with the metric ot be updated. For
  #            example, ".renewables" or ".costs".
  #
  # value    - The new value of the metric.
  #
  # min      - The minimum expected value.
  #
  # max      - The maximum expected value.
  #
  updateMetric: (selector, value, min, max) ->
    container = @$ selector

    switch selector
      when '.emissions'
        formatted = "#{ I18n.toNumber value, precision: 1 } Mton"
      when '.renewables'
        formatted = I18n.toPercentage value, precision: 1
      when '.costs'
        formatted = "#{ I18n.toCurrency value, precision: 1, unit: '€' }b"

    container.find('.value').text formatted

    # Draw the horizontal bar graph.
    container.find('.bar').css 'width', @barWidth(value, min, max)

  # Returns the width of a horizontal bar graph based on the given value, when
  # compared with the minimum and maximum extrema.
  #
  # value - The current value of a metric.
  #
  # min   - The minimum expected value. If the value matches this, the bar
  #         will be drawn at 0%.
  #
  # max   - The maximum expected value. If the value matches this, the bar
  #         will be drawn at 100%.
  #
  # Returns a string in the format "50%".
  #
  barWidth: (value, min, max) ->
    delta    = max - min
    fromMin  = value - min
    fraction = fromMin / delta

    fraction = 0 if fraction < 0
    fraction = 1 if fraction > 1

    "#{ Math.round(fraction * 100) }%"
