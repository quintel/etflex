{ GenericVisualisation } = require 'views/vis/generic'

class exports.Renewables extends GenericVisualisation

  # Creates a new Renewables visualisation. Calculates the percentage of total
  # energy generated which is derived from solar and window energy.
  #
  constructor: (options) ->
    super options

    inputs = []

    inputs.push @gasInput     = options.gas
    inputs.push @coalInput    = options.coal
    inputs.push @nuclearInput = options.nuclear
    inputs.push @windInput    = options.wind
    inputs.push @solarInput   = options.solar
    inputs.push @biomassInput = options.biomass

    input.bind 'change:value', @render for input in inputs

  # Calculates the total CO2 emissions based on the value of the coal and
  # gas inputs.
  #
  recalculate: ->
    coal     = 18 * @coalInput.get      'value'
    gas      = 15 * @gasInput.get       'value'
    nuclear  = 44 * @nuclearInput.get   'value'
    wind     = 0.02 * @windInput.get    'value'
    solar    = 0.004 * @solarInput.get  'value'
    biomass  = 0.03 * @biomassInput.get 'value'

    total    = coal + gas + nuclear + wind + solar + biomass

    Math.round ((wind + solar) / total) * 100

  # Renders the UI; calculates the C02 emissions. Can be safely called
  # repeatedly to update the UI.
  #
  render: =>
    super "#{@recalculate()}%", 'Wind and solar'
