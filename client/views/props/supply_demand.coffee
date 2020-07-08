supplyDemandTpl = require 'templates/props/supply_demand'
{ hurdleState } = require 'views/props'

# The maximum values which may be represented on the graph. In petajoules.
EXTENT = 1000

# A placeholder prop which projects energy supply and demand into a histogram
# based on the selections made by the user on the ETlite recreation.
#
class exports.SupplyDemandView extends Backbone.View
  queries: [ 'total_electricity_produced', 'etflex_electricity_demand' ]
  hurdles: [ 0.95, 1.05 ]
  states:  [ 'supplyExcess', 'balanced', 'demandExcess' ]

  id:        'energy-generation'
  className: 'energy-graph'

  constructor: (options) ->
    super options

    # Since both queries are (normally) updated at the same time, wait until
    # we should have results for them both before updating the gauge.
    @updateGauge = _.debounce @updateGauge, 50

    @demandQuery = options.queries.get 'etflex_electricity_demand'
    @supplyQuery = options.queries.get 'total_electricity_produced'

    @demandQuery.on 'change:future', @redrawDemand
    @supplyQuery.on 'change:future', @redrawSupply

  render: =>
    @$el.html supplyDemandTpl()

    unless Modernizr.csstransforms
      @$el.addClass 'legacy'
      @$el.addClass I18n.locale

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

    # The colour change (blue / red) occurs at -45deg and +45deg. Match these
    # colours up with the hurdle values.
    perDegree = (1.0 - @hurdles[0]) / 45

    # The gauge needle extremes are -84 degrees to +84 degrees. For the
    # moment, a one percent difference between supply and demand will be
    # represented by moving the needly by 1.5 degrees.
    degrees = (1 - difference) / perDegree

    degrees =  84 if degrees >  84
    degrees = -84 if degrees < -84

    unless Modernizr.csstransforms
      @positionLegacyNeedle degrees

    @$('.gauge .needle')
      .css('-moz-transform', "rotate(#{degrees}deg)")
      .css('-webkit-transform', "rotate(#{degrees}deg)")
      .css('-ms-transform', "rotate(#{degrees}deg)")
      .css('-o-transform', "rotate(#{degrees}deg)")

    # Update the label underneath the gauge.
    @$('.gauge .info .message').text(
      I18n.t "scenes.etlite.#{ hurdleState this, difference }")

    @beep(hurdleState this, difference)

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

  # When the demand or supply falls into the "red" zone, the red area flashes
  # in order to attract the user's attention and encourage them to fix the
  # problem.
  #
  beep: (state) ->
    overlay = @$('.gauge .beeping')
    overlay.removeClass('beeping-left beeping-right')

    message = @$('.gauge .info .message')

    flashAnimation = (element) ->
      element.fadeIn('slow').fadeOut('slow').
        fadeIn('slow').fadeOut('slow').fadeIn('slow')

    switch state
      when 'demandExcess'
        overlay.addClass('beeping-left')
        flashAnimation overlay
        message.addClass 'warning'
      when 'supplyExcess'
        overlay.addClass('beeping-right')
        flashAnimation overlay
        message.addClass 'warning'
      else
        overlay.hide()
        message.removeClass 'warning'

  # Older browsers do not support CSS transforms, so we have to use a sprite
  # of the needle in different positions. We choose a sprite position based on
  # the number of degrees at which the needle should be displayed.
  #
  positionLegacyNeedle: (degrees) ->
    abs       = Math.abs degrees
    direction = if degrees >= 0 then 'pos' else 'neg'

    if abs > 74
      sprite = "#{ direction }-85"
    else if abs > 52.5
      sprite = "#{ direction }-63"
    else if abs > 31.5
      sprite = "#{ direction }-42"
    else if abs > 10.5
      sprite = "#{ direction }-21"
    else
      sprite = 'zero'

    @$('.needle').attr 'class', "needle #{ sprite }"
