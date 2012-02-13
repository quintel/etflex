scoreTpl = require 'templates/props/score'
{ GenericProp } = require 'views/props/generic'
{ IconProp }    = require 'views/props/icon'

class exports.ScoreView extends GenericProp
  @queries: [ 'etflex_score' ]

  className: 'prop score'

  # Creates a new Score prop
  #
  constructor: (options) ->
    super options

    @icon = new IconProp

    @query = options.queries.get 'etflex_score'
    @query.on 'change:future', @updateValues

  # Renders the UI; calculates score. Can be safely called
  # repeatedly to update the UI.
  #
  render: ->
    @$el.html scoreTpl()

    super '', I18n.t 'scenes.etlite.score'

    @$el.prepend """
      <div class='icon-prop'>
        <span class='icon'>
          <span class='numbers hundreds'><span class='number-8'></span></span>
          <span class='numbers tens'></span>
          <span class='numbers ones'></span>
        </span>
      </div>"""

    @updateValues()

    this

  # Updates the value shown to the user, and swaps the icon if necessary,
  # without re-rendering the whole view.
  #
  updateValues: =>
    score = @query.get('future')
    previous = @query.previous('future')
    
    rounded_score = @precision score, 0
    string_score = rounded_score.toString()
    
    string_score = "0" + string_score until string_score.length == 3
    
    # Reduce the shown value to whole value.
    @$el.find('.output').html @precision score, 0

    # Show the separate numbers in the image
    @$el.find('.numbers').removeClass('number-0 number-1 number-2 number-3 number-4 number-5 number-6 number-7 number-8 number-9')

    @$el.find('.hundreds').addClass("number-#{string_score[0]}")
    @$el.find('.tens').addClass("number-#{string_score[1]}")
    @$el.find('.ones').addClass("number-#{string_score[2]}")

    @setDifference @precision score-previous, 0
    
    this
