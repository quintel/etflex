{ GenericVisualisation } = require 'views/vis/generic'

class exports.Renewables extends GenericVisualisation

  # Creates a new Renewables visualisation. Calculates the percentage of total
  # energy generated which is derived from solar and window energy.
  #
  constructor: (options) ->
    super options

    @query = options.queries.get 32
    @query.bind 'change:future', @render

  # Calculates the total CO2 emissions based on the value of the coal and
  # gas inputs.
  #
  recalculate: ->
    total = @query.get('future') * 100
    if total is 0 then '0' else @precision total, 3

  # Renders the UI; calculates the C02 emissions. Can be safely called
  # repeatedly to update the UI.
  #
  render: =>
    super "#{@recalculate()}%", 'Wind and solar'
