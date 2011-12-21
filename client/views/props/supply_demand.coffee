supplyDemandTpl = require 'templates/props/supply_demand'
{ hurdleState } = require 'views/props'

# The maximum values which may be represented on the graph. In petajoules.
EXTENT = 1000

# A placeholder prop which projects energy supply and demand into a histogram
# based on the selections made by the user on the ETlite recreation.
#
class exports.SupplyDemandView extends Backbone.View
  @queries:  [ 'electricity_production', 'final_demand_electricity' ]
  states:    [ 'supplyExcess', 'balanced', 'demandExcess' ]

  id:        'energy-generation'
  className: 'energy-graph'

  constructor: (options) ->
    super options

    # Since both queries are (normally) updated at the same time, wait until
    # we should have results for them both before updating the gauge.
    @updateGauge = _.debounce @updateGauge, 50

    @demandQuery = options.queries.get 'final_demand_electricity'
    @supplyQuery = options.queries.get 'electricity_production'

    @demandQuery.bind 'change:future', @redrawDemand
    @supplyQuery.bind 'change:future', @redrawSupply

  render: =>
    $(@el).html supplyDemandTpl()

    @redrawSupply false
    @redrawDemand false

    this

  redrawSupply: (animate = true) =>
    @redraw '.supply', @supplyQuery, animate
    @updateGauge()

  redrawDemand: (animate = true) =>
    @redraw '.demand', @demandQuery, animate
    @updateGauge()

  # Moves the needle on the "supply too high / demand too high" gauge which
  # sits beneath the main supply and demand graph.
  #
  updateGauge: ->
    difference = @demandQuery.get('future') / @supplyQuery.get('future')

    # The gauge needle extremes are -84 degrees to +84 degrees. For the
    # moment, a one percent difference between supply and demand will be
    # represented by moving the needly by 1.5 degrees.
    degrees = ( 1 - difference ) * 84 * 1.5

    degrees =  84 if degrees >  84
    degrees = -84 if degrees < -84

    @$('.gauge .needle')
      .css('-moz-transform', "rotate(#{degrees}deg)")
      .css('-webkit-transform', "rotate(#{degrees}deg)")

    # Update the label underneath the gauge.
    @$('.gauge .info').text(
      I18n.t "scenes.etlite.#{ hurdleState this, difference }")

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
    position = value / EXTENT

    @$("#{selector} .bar")[action]    height: "#{position * 204}px", 'fast'
    @$("#{selector} .marker")[action] top: "#{100 - position * 100}%", 'fast'
    @$("#{selector} .marker").text    "#{value}PJ"
