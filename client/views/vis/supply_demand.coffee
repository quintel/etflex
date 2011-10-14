supplyDemandTpl = require 'templates/vis/supply_demand'

# The maximum values which may be represented on the graph. In petajoules.
EXTENT = 1000

# A placeholder visualisation which projects energy supply and demand into a
# histogram based on the selections made by the user on the ETlite recreation.
#
class exports.SupplyDemand extends Backbone.View
  id:        'energy-generation'
  className: 'energy-graph'

  constructor: (options) ->
    super options

    @demandQuery = options.queries.get 518
    @supplyQuery = options.queries.get  49

    @demandQuery.bind 'change:future', @redrawBars
    @supplyQuery.bind 'change:future', @redrawBars

  recalculate: ->
    { demand: Math.round(@demandQuery.get('future') / 1000000000)
    , supply: Math.round(@supplyQuery.get('future') / 1000000000) }

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

    @$('.demand .bar')[action]    height: "#{demandPos}%", 'fast'
    @$('.supply .bar')[action]    height: "#{supplyPos}%", 'fast'

    @$('.demand .marker')[action] top: "#{100 - demandPos}%", 'fast'
    @$('.demand .marker').text    "#{values.demand}PJ"

    @$('.supply .marker')[action] top: "#{100 - supplyPos}%", 'fast'
    @$('.supply .marker').text    "#{values.supply}PJ"

    this
