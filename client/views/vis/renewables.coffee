{ GenericVisualisation } = require 'views/vis/generic'
{ IconVisualisation }    = require 'views/vis/icon'

class exports.RenewablesView extends GenericVisualisation
  @queries: [ 'share_of_renewable_electricity' ]
  states:   [ 'low', 'medium', 'high' ]

  className: 'visualisation renewables'

  # Creates a new Renewables visualisation. Calculates the percentage of total
  # energy generated which is derived from solar and window energy.
  #
  constructor: (options) ->
    super options

    @icon = new IconVisualisation

    @query = options.queries.get 'share_of_renewable_electricity'
    @query.bind 'change:future', @updateValues

  # Renders the UI; calculates the C02 emissions. Can be safely called
  # repeatedly to update the UI.
  #
  render: ->
    super '', I18n.t 'scenes.etlite.renewables'

    $(@el).find('.icon').replaceWith @icon.render().el
    @updateValues()

    this

  # Updates the value shown to the user, and swaps the icon if necessary,
  # without re-rendering the whole view.
  #
  updateValues: =>
    # Multiply the query value by 100 to get a percentage.
    value = @query.get('future') * 100

    # Reduce the value to three decimal places when shown.
    $(@el).find('.output').html "#{@precision value, 3}%"

    @icon.setState @hurdleState value

    this
