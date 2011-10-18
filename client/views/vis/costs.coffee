{ GenericVisualisation } = require 'views/vis/generic'

class exports.Costs extends GenericVisualisation

  # Creates a new Costs visualisation. Calculates the cost of the choices the
  # user makes in the ETLite scenario.
  #
  constructor: (options) ->
    super options

    inputs = []

    inputs.push @lightingInput     = options.lighting
    inputs.push @carsInput         = options.cars
    inputs.push @insulationInput   = options.insulation
    inputs.push @heatingInput      = options.heating
    inputs.push @appliancesInput   = options.appliances
    inputs.push @heatPumpInput     = options.heatPump

    inputs.push @gasInput          = options.gas
    inputs.push @coalInput         = options.coal
    inputs.push @nuclearInput      = options.nuclear
    inputs.push @windInput         = options.wind
    inputs.push @solarInput        = options.solar
    inputs.push @biomassInput      = options.biomass

    input.bind 'change:value', @render for input in inputs

  # Calculates the total CO2 emissions based on the value of the coal and
  # gas inputs.
  #
  recalculate: ->
    lighting   = 0.252  * @lightingInput.get   'value'
    cars       = 0
    insulation = 0.2859 * @insulationInput.get 'value'
    heating    = 0.225  * @heatingInput.get    'value'
    appliances = 0
    heatPump   = 0.514  * @heatPumpInput.get   'value'

    gas        = 3.6    * @gasInput.get        'value'
    coal       = 2.8    * @coalInput.get       'value'
    nuclear    = 14.5   * @nuclearInput.get    'value'
    wind       = 0.0125 * @windInput.get       'value'
    solar      = 0.0102 * @solarInput.get      'value'
    biomass    = 0.02   * @biomassInput.get    'value'

    total =
      lighting + cars + insulation + heating + appliances + heatPump +
      gas + coal + nuclear + wind + solar + biomass

    @precision total, 3

  # Renders the UI; calculates the C02 emissions. Can be safely called
  # repeatedly to update the UI.
  #
  render: =>
    super(
      "€#{@recalculate()} #{I18n.t 'etlite.million'}", I18n.t 'etlite.costs')
