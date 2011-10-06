{ GenericVisualisation } = require 'views/vis/generic'

class exports.CO2Emissions extends GenericVisualisation

  # Creates a new CO2Emissions visualisation. In addition to the usual
  # Backbone options, requires `gas` containing the gas-fired power plants
  # input, and `coal` containing the coal-fired power plans input.
  #
  constructor: (options) ->
    super options

    @gasModel  = options.gas
    @coalModel = options.coal

    @gasModel.bind  'change:value', @render
    @coalModel.bind 'change:value', @render

  # Calculates the total CO2 emissions based on the value of the coal and
  # gas inputs.
  #
  recalculate: ->
    coalOutput = 3.6 * @coalModel.get 'value'
    gasOutput  = 1.5 * @gasModel.get  'value'

    @precision coalOutput + gasOutput, 1

  # Renders the UI; calculates the C02 emissions. Can be safely called
  # repeatedly to update the UI.
  #
  render: =>
    super "#{@recalculate()} Mton CO<sup>2</sup>", 'Emissions'
