app                   = require 'app'
queryTransforms       = require 'lib/query_transforms'

listTemplate          = require 'templates/high_scores'
rowTemplate           = require 'templates/high_score'

{ relativeTime }      = require 'lib/time_helpers'
{ ScenarioSummary }   = require 'models/scenario_summary'
{ ScenarioSummaries } = require 'collections/scenario_summaries'

# Shows the top five scoring scenario summaries in a list.
class exports.HighScores extends Backbone.View
  className: 'high-scoring-scenarios'

  events:
    'click h2 a':          'changeDateLimit'

  # Provide HighScores with a ScenarioSummaries collection in the options
  # hash.
  constructor: ({ @collection, @show, @style, @scenario, @sceneId }) ->
    super

    # Show, by default, the five highest scores.
    @show  or= 10
    @style or= 'full'

    # Temporary, until we decide what details to include on the house scene.
    @style = 'wide' if @scenario?.get('scene').id isnt 1

    # Keep track of the summaries which are shown in the UI. Actual values are
    # set in setCollection.
    @visible = null
    @rows    = null

    # Used while rendering so that elements immediately appear instead of
    # animating into place.
    @animate = true

  # Unbinds listeners from Pusher.
  destructor: ->
    # There is nothing to destruct if the view has not been rendered.
    return true unless @listElement

    if app.pusher_key
      app.pusher.unbind 'scenario.created', @scenarioNotification
      app.pusher.unbind 'scenario.updated', @scenarioNotification

    if @scenario
      @scenario.off 'change:guestName', @updateGuestName

  # Renders a list containing the top five scoring scenarios. Presently render
  # is called each time the collection is changed regardless of whether the
  # top five have changed.
  render: =>
    @$el.html listTemplate(style: @style)
    @$el.addClass @style

    @listElement = @$ 'ol'

    # Render the list.
    if @collection
      @setCollection @collection
    else
      @loadSince 30

    if app.pusher_key
      app.pusher.bind 'scenario.created', @scenarioNotification
      app.pusher.bind 'scenario.updated', @scenarioNotification

    # Update the high scores list when the user enters their name.
    @scenario.on 'change:guestName', @updateGuestName if @scenario

    this

  # Given a ScenarioSummaries collection, tells the HighScores to change the
  # current collection, and re-render the high scores list.
  #
  setCollection: (newCollection) ->
    if @collection
      # Unbind events from the old collection.
      @collection.off 'change:score', @collection.sort
      @collection.off 'add',          @summaryUpdated
      @collection.off 'change',       @summaryUpdated

    @visible = []
    @rows    = {}

    @collection = newCollection

    # We need the collection to re-sort whenever a summary score changes.
    @collection.on 'change:score', @collection.sort

    @collection.on 'add',    @summaryUpdated
    @collection.on 'change', @summaryUpdated

    # Stop here if the scores haven't been rendered yet.
    return unless @listElement?

    # Re-render the list.
    @listElement.empty()
    @animate = false

    for scenario in @collection.identified()[ 0...@show ]
      @summaryUpdated scenario, null, false

    @animate = true

  # Given a ScenarioSummary, adds it to the UI. If the scenario is already
  # visible, the existing UI will be updated.
  #
  summaryUpdated: (summary, ignore) =>
    isVisible     = _.include @visible, summary.id
    shouldDisplay = @collection.shouldDisplay summary, @show

    if isVisible and not shouldDisplay

      # Was previously a top-five summary but now is not. Remove it, and
      # promote the the new #5 to be displayed.

      @demote  summary
      @promote @collection.identified()[ @show - 1 ]

    else if isVisible and shouldDisplay

      # Was previously a top-five scenario, and still is. Move the element to
      # the new position; the SummaryRow will update the values shown.
      @sortSummaryEl @rows[summary.id]

    else if shouldDisplay

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

  # Gets the scene ID from any available source
  getSceneId: ->
    sceneId   = @sceneId
    sceneId or= @scenario.get('scene').id

    sceneId

  # Sets how far back we should go when retrieving high scores.
  #
  # Days may be 1, 7. Note that setSince is asynchronous and only applies the
  # change after successful completion of an XHR request.
  #
  loadSince: (days, callback) ->
    jQuery.getJSON("/scenes/#{ @getSceneId() }/scenarios/since/#{ days }.json")
      .fail(        -> console.log 'Failed to fetch high scores')
      .done( (data) => @setCollection new ScenarioSummaries data)

  # Callback triggered by Pusher whenever a scenario is added or updated by
  # another visitor to the website.
  #
  scenarioNotification: (data) =>
    # Collection may not yet be loaded when no data is bootstrapped.
    return true unless @collection
    return true unless data.scene_id is @getSceneId()

    if summary = @collection.get data.session_id
      summary.set data
    else
      summary = new ScenarioSummary data
      @collection.add summary

    @trigger 'update', summary, @collection

  # When the scenario guest name changes, we look for the row which
  # corresponds with the scenario, and change the users name.
  updateGuestName: =>
    username   = @scenario.get('user')?.name or @scenario.get('guestName')
    username or= I18n.t 'words.anonymous'

    currentEl = @summaryEl @scenario.id
    currentEl.find('.name, .actual-name').text username

    # Display the scenario if a name has been set.
    @summaryUpdated @collection.get(@scenario.id)

  # Private ------------------------------------------------------------------

  # Returns the DOM element for a summary which corresponds with a given
  # sessionId.
  summaryEl: (sessionId) ->
    @$ "#high-score-#{ sessionId }"

  # Given a scenario summary, adds a DOM element to show the summary. Does not
  # re-sort the elements in the DOM, nor demotes the previous #5 scenario.
  promote: (summary) ->
    @visible.push summary.id
    @rows[summary.id] = new SummaryRow(model: summary, style: @style).render()

    if @scenario?.id and @scenario.id is summary.id
      @rows[summary.id].$el.addClass 'current'

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
    position  = _.indexOf(@collection.identified(), row.model) + 1
    currentAt = @$ "li:nth-child(#{ position })"

    # Don't mess about with the DOM if the element is already in the correct
    # place.
    unless currentAt.attr('id') is row.id
      row.$el.detach()

      if currentAt.length and position isnt @show
        # Note that we get the nth-child again, as getting the correct element
        # when moving the row down requires first detaching the current row.
        nextRow = @rows[ @collection.identified()[ position ]?.id ]

      if nextRow
        row.$el.insertBefore nextRow.$el
      else
        @listElement.append row.$el

      # Update the #1, #2, etc.
      @$('li').each (index, element) ->
        $('.position', element).text index + 1

      if @animate
        row.$el.css('margin-left', '20px').
          animate({ 'margin-left': '0px' },
            duration: 750, easing: 'easeOutBounce')

# Helpers --------------------------------------------------------------------

exports.costsWidth = (value) ->
  widthOf value / 1000000000, 40, 50

exports.renewablesWidth = (value) ->
  widthOf value * 100, 0, 20

exports.emissionsWidth = (value) ->
  widthOf value / 1000000000, 105, 165

# Contains the values which represent the far left and far right of each bar
# in the "full" high scores list.
BAR_WIDTH_FUNCTIONS =
  total_co2_emissions: [105, 165]
  renewability:        [  0,  20]
  total_costs:         [ 40,  50]

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
widthOf = (value, min, max) ->
  delta    = max - min
  fromMin  = value - min
  fraction = fromMin / delta

  fraction = 0 if fraction < 0
  fraction = 1 if fraction > 1

  "#{ Math.round(fraction * 100) }%"

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
    'change:score':      'updateScore'
    'change:updated_at': 'updateTime'

  constructor: (options) ->
    options.id = "high-score-#{ options.model.get('session_id') }"
    super options

  render: ->
    @$el.html rowTemplate
      user:         @model.get('user_name') or I18n.t('words.anonymous')
      href:         @model.get 'href'
      sessionId:    @model.get 'session_id'
      imageUrl:     @model.get 'profile_image'
      style:        @options.style
      isMine:       app.user.id is @model.get 'user_id'

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
    @updateMetrics()

    score = Math.round(score)

    score = 0   if score < 0
    score = 999 if score > 999

    @$('.score').text score

  updateTime: (summary, time) =>
    @$('time').replaceWith relativeTime(time)

  updateMetrics: ->
    @$('.metric').each (index, element) =>
      $element = $ element

      if queryKey = $element.data('bind')
        @updateMetric($element, queryKey)

  updatePosition: (position) ->
    @$('.position').text "#{position}"

  # Helpers ------------------------------------------------------------------

  # Updates a displayed metric.
  #
  # element  - The ".metric" element, wrapped in a jQuery object.
  # query    - The query from which to get the value.
  #
  # Returns nothing.
  updateMetric: (element, query) ->
    transform  = queryTransforms.forQueryKey(query)
    barExtrema = BAR_WIDTH_FUNCTIONS[query]

    if transform and barExtrema and @model.get('query_results')[query]
      value = transform.mutate(@model.get('query_results')[query]['future'])

      element.find('.value').html transform.format(value)
      element.find('.bar').css 'width', widthOf(value, barExtrema...)
