template = require 'templates/high_score'

# Shows the top five scoring scenario summaries in a list.
class exports.HighScores extends Backbone.View
  className: 'high-scoring-scenarios'
  tagName:   'ol'

  # Provide HighScores with a ScenarioSummaries collection in the options
  # hash.
  constructor: ({ @collection }) ->
    super

    # We need the collection to re-sort whenever a summary score changes.
    @collection.on 'change:score', @collection.sort

    @collection.on 'add',    @render
    @collection.on 'change', @render

  # Renders a list containing the top five scoring scenarios. Presently render
  # is called each time the collection is changed regardless of whether the
  # top five have changed.
  render: =>
    @$el.empty()

    if @collection.length isnt 0
      $('li.none').remove()

    for index in [ 0...5 ]
      if summary = @collection.at index
        @$el.append $('<div />').html template
          sessionId: summary.get 'session_id'
          score:     Math.round summary.get 'score'

    this
