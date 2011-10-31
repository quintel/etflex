supplyDemandTpl = require 'templates/vis/supply_demand'

# The maximum values which may be represented on the graph. In petajoules.
EXTENT = 1000

# A placeholder visualisation which projects energy supply and demand into a
# histogram based on the selections made by the user on the ETlite recreation.
#
class exports.SupplyDemandView extends Backbone.View
  @queries:  [ 49, 518 ]

  id:        'energy-generation'
  className: 'energy-graph'

  constructor: (options) ->
    super options

    @demandQuery = options.queries.get 518
    @supplyQuery = options.queries.get  49

    @demandQuery.bind 'change:future', @redrawDemand
    @supplyQuery.bind 'change:future', @redrawSupply

  render: =>
    $(@el).html supplyDemandTpl()

    @redrawSupply false
    @redrawDemand false

    this

  redrawSupply: (animate = true) =>
    @redraw '.supply', @supplyQuery, animate

  redrawDemand: (animate = true) =>
    @redraw '.demand', @demandQuery, animate

  # Sets the height of the graph bars, and the marker positions without
  # rerendering the whole view. Returns self.
  #
  # animate - If false, will immediately set the new bar height, and marker
  #           positions. Any other value will animate them to their new
  #           values.
  #
  redraw: (selector, query, animate) ->
    action   = if animate then 'animate' else 'css'
    value    = Math.round(query.get('future') / 1000000000)
    position = value / EXTENT * 100

    @$("#{selector} .bar")[action]    height: "#{position}%", 'fast'
    @$("#{selector} .marker")[action] top: "#{100 - position}%", 'fast'
    @$("#{selector} .marker").text    "#{value}PJ"
