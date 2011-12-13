{ GenericVisualisation } = require 'views/vis/generic'
{ IconVisualisation }    = require 'views/vis/icon'

class exports.RenewablesView extends GenericVisualisation
  @queries: [ 'share_of_renewable_electricity' ]

  className: 'visualisation renewables'

  # Creates a new Renewables visualisation. Calculates the percentage of total
  # energy generated which is derived from solar and window energy.
  #
  constructor: (options) ->
    super options

    @icon = new IconVisualisation

    @query = options.queries.get 'share_of_renewable_electricity'
    @query.bind 'change:future', @updateValues

  # Calculates the total CO2 emissions based on the value of the coal and
  # gas inputs.
  #
  recalculate: ->
    total = @query.get('future') * 100
    if total is 0 then '0' else @precision total, 3

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
    value   = @recalculate()
    element = $ @el

    element.find('.output').html "#{value}%"

    if value < 6
      @icon.setState 'low'
    else if value < 10
      @icon.setState 'medium'
    else
      @icon.setState 'high'

    this
