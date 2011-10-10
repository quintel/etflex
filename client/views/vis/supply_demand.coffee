supplyDemandTpl = require 'templates/vis/supply_demand'

# The maximum values which may be represented on the graph. In petajoules.
EXTENT = 850

# A placeholder visualisation which projects energy supply and demand into a
# histogram based on the selections made by the user on the ETlite recreation.
#
class exports.SupplyDemand extends Backbone.View
  id:        'energy-generation'
  className: 'energy-graph'

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

    input.bind 'change:value', @redrawBars for input in inputs

  recalculate: ->
    # Demand.
    demand = 637

    demand -= 0.1  * @lightingInput.get 'value'
    demand -= 2.0  * @carsInput.get 'value'
    demand -= 1.0  * @insulationInput.get 'value'
    demand -= 0.12 * @heatingInput.get 'value'
    demand -= 0.6  * @appliancesInput.get 'value'
    demand -= 1.7  * @heatPumpInput.get 'value'

    # Supply.
    supply = 0

    supply += 18.0  * @coalInput.get 'value'
    supply += 15.1  * @gasInput.get 'value'
    supply += 45.5  * @nuclearInput.get 'value'
    supply += 0.02  * @windInput.get 'value'
    supply += 0.004 * @solarInput.get 'value'
    supply += 0.034 * @biomassInput.get 'value'

    { demand: Math.round(demand), supply: Math.round(supply) }

  render: =>
    values = @recalculate()

    $(@el).html supplyDemandTpl values
    @redrawBars false

  # Sets the height of the graph bars, and the marker positions without
  # rerendering the whole view. Returns self.
  #
  # animate - If false, will immediately set the new bar height, and marker
  #           positions. Any other value will animate them to their new
  #           values.
  #
  redrawBars: (animate = true) =>
    values = @recalculate()
    action = if animate then 'animate' else 'css'

    supplyPos = values.supply / EXTENT * 100
    demandPos = values.demand / EXTENT * 100

    @$('.demand .bar')[action]    height: "#{demandPos}%"
    @$('.supply .bar')[action]    height: "#{supplyPos}%"

    @$('.demand .marker')[action] top: "#{100 - demandPos}%"
    @$('.demand .marker').text    "#{values.demand}PJ"

    @$('.supply .marker')[action] top: "#{100 - supplyPos}%"
    @$('.supply .marker').text    "#{values.supply}PJ"

    this
