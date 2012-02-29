{ DashboardProp } = require 'views/props/dashboard'
{ IconProp }      = require 'views/props/icon'

class exports.ScoreView extends DashboardProp
  @queries: [ 'etflex_score' ]

  className: 'score'

  # Creates a new Score prop
  #
  constructor: (options) ->
    super options

    @icon   = new IconProp
    @timers = { ones: [], tens: [], hundreds: [] }

    @query = options.queries.get 'etflex_score'
    @query.on 'change:future', @updateValues

  # Renders the UI; calculates score. Can be safely called
  # repeatedly to update the UI.
  #
  render: ->
    super '', I18n.t 'scenes.etlite.score'

    @$el.prepend """
      <div class='icon-prop'>
        <span class='icon'>
          <span class='numbers hundreds'></span>
          <span class='numbers tens'></span>
          <span class='numbers ones'></span>

          <span class='number-overlay hundreds'></span>
          <span class='number-overlay flip1 tens'></span>
          <span class='number-overlay flip2 ones'></span>
        </span>
      </div>"""

    @updateValues()

    this

  # Updates the value shown to the user, and swaps the icon if necessary,
  # without re-rendering the whole view.
  #
  updateValues: =>
    score    = @brickwallScore @query.get('future')
    previous = @brickwallScore @query.previous('future')

    roundedScore = @precision score, 0
    stringScore  = roundedScore.toString()

    # Ensure the score is left-padded with zeros when < 100 and < 10.
    stringScore = "0" + stringScore until stringScore.length is 3

    # Reduce the shown value to whole value.
    @$el.find('.output').html @precision score, 0

    @updateMultiple 'ones',     stringScore[2]
    @updateMultiple 'tens',     stringScore[1]
    @updateMultiple 'hundreds', stringScore[0]

    @setDifference score - previous, precision: 0

    this

  # Given the name of a multiple -- "hundreds", "tens", or "ones" -- updates
  # the UI to show the new score. Animates the change from the old number to
  # the new number asynchronously.
  #
  # factor - The multiple name.
  # digit  - The digit to be shown for the multiple. Nothing will happen if
  #          the number is already shown.
  #
  updateMultiple: (multiple, digit) ->
    # If there are any existing animation timers running for this multiple,
    # stop them before going any further.
    clearTimeout timerId for timerId in @timers[multiple]

    element = @$ ".numbers.#{multiple}"
    overlay = @$ ".number-overlay.#{multiple}"

    # Don't do anything if the new digit is the same as the old one.
    return if element.text() is "#{digit}"

    # Make sure we're starting from scratch.
    overlay.removeClass 'flip2'
    overlay.removeClass 'flip3'

    # Set up the animations...
    overlay.addClass 'flip1'

    @timers[multiple].push(setTimeout ->
      overlay.removeClass 'flip1'
      overlay.addClass 'flip2'
    , 60)

    @timers[multiple].push(setTimeout ->
      overlay.removeClass 'flip2'
      overlay.addClass 'flip3'
      element.text "#{digit}"
    , 120)

    @timers[multiple].push(setTimeout ->
      overlay.removeClass 'flip3'
    , 180)

  # Ensures that a score for display is not lower than 0, and not higher than
  # 999 (otherwise the display cannot accommodate them).
  #
  brickwallScore: (score) ->
    if      score <   0 then 0
    else if score > 999 then 999
    else                     score
