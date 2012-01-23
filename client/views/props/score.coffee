scoreTpl = require 'templates/props/score'
{ GenericProp } = require 'views/props/generic'
{ IconProp }    = require 'views/props/icon'

class exports.ScoreView extends GenericProp
  @queries: [ 'score' ]

  className: 'prop score'

  # Creates a new Score prop
  #
  constructor: (options) ->
    super options

    @icon = new IconProp

    @query = options.queries.get 'score'
    @query.bind 'change:future', @updateValues

  # Renders the UI; calculates score. Can be safely called
  # repeatedly to update the UI.
  #
  render: ->
    $(@el).html scoreTpl()

    super '', I18n.t 'scenes.etlite.score'

    $(@el).find('.icon').replaceWith @icon.render().el
    @updateValues()

    this

  # Updates the value shown to the user, and swaps the icon if necessary,
  # without re-rendering the whole view.
  #
  updateValues: =>
    score = @query.get('future') 

    # Reduce the shown value to three decimal places.
    $(@el).find('.output').html(
      "Score: #{@precision score, 0}")

    this
