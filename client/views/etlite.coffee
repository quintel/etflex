app                 = require 'app'
etliteTemplate      = require 'templates/etlite'

{ Inputs }          = require 'collections/inputs'
{ Queries }         = require 'collections/queries'

{ Range }           = require 'views/range'
{ SavingsMediator } = require 'mediators/savings_mediator'
{ CO2Emissions }    = require 'views/vis/co2_emissions'
{ Renewables }      = require 'views/vis/renewables'
{ Costs }           = require 'views/vis/costs'
{ SupplyDemand }    = require 'views/vis/supply_demand'

INPUT_MAP =
  lighting:    43
  cars:       146
  insulation: 336
  heating:    348
  appliances: 366
  heatPump:   338 # or 339?

  coal:       315
  gas:        256
  nuclear:    259 # or 413?
  wind:       263 # or 265, 265?
  solar:      313
  biomass:    196

# A full-page view which recreates the ETLite interface. Six sliders are on
# the left of the UI allowing the user to control how savings can be made in
# energy use, and six on the right controlling how energy will be produced.
#
# A graph in the middle, and three image-based visualisations at the bottom
# provide feedback to the user based on the choices they make.
#
class exports.ETLite extends Backbone.View
  id: 'etlite-view'

  events:
    'click a.clear': 'clearSession'

  # Creates a new instance of the ETLite view.
  #
  # Creates a subset of the main Queries collection containing only those
  # queries required by this view.
  #
  constructor: ->
    super

    @queries = app.collections.queries.subset [ 8, 23, 32, 49, 518 ]
    @inputs  = app.collections.inputs.subset  ( k for own v, k of INPUT_MAP )

    # Immediately save changed inputs, and request that the Queries used on
    # the ETlite page be updated.
    @inputs.bind 'change:value', (input) => input.save {}, queries: @queries

    # Immediately initialize query values. As if this word isn't getting
    # enough of a workout... this is temporary! I plan to add a way to do this
    # automatically whenever the view is rendered (see Master::setSubView and
    # the dependant-resolution branch).
    app.session.updateInputs [], @queries, (->)

  # Creates the HTML elements for the view, and binds events. Returns self.
  #
  # Example:
  #
  #   view = new ETLite()
  #   $('body').html view.render().el
  #
  render: ->
    $(@el).html etliteTemplate()

    leftRangesEl  = @$ '#savings'
    rightRangesEl = @$ '#energy-production'

    # Render each of the ranges...

    leftRanges = [
      new Range model: @inputs.get INPUT_MAP.lighting
      new Range model: @inputs.get INPUT_MAP.cars
      new Range model: @inputs.get INPUT_MAP.insulation
      new Range model: @inputs.get INPUT_MAP.heating
      new Range model: @inputs.get INPUT_MAP.appliances
      new Range model: @inputs.get INPUT_MAP.heatPump ]

    rightRanges = [
      new Range model: @inputs.get INPUT_MAP.coal
      new Range model: @inputs.get INPUT_MAP.gas
      new Range model: @inputs.get INPUT_MAP.nuclear
      new Range model: @inputs.get INPUT_MAP.wind
      new Range model: @inputs.get INPUT_MAP.solar
      new Range model: @inputs.get INPUT_MAP.biomass ]

    _.each leftRanges,  (range) -> leftRangesEl.append  range.render().el
    _.each rightRanges, (range) -> rightRangesEl.append range.render().el

    # Add three visualisations to the bottom of the page.

    @$('#visualisations')
      .append(@createRenewablesVis().render().el)
      .append(@createCarbonVis().render().el)
      .append(@createCostsVis().render().el)

    # And add the supply / demand graph.

    @$('#energy-generation').replaceWith @createSupplyDemandVis().render().el

    @delegateEvents()
    this

  # Callback for the "Clear Session" button. Wipes out all of the inputs which
  # should be followed by a browser refresh.
  #
  clearSession: (event) =>
    app.session.destroy()
    event.preventDefault()

  # Creates and returns the visualisation which shows the total amount of
  # carbon emissions based on the user's choices.
  #
  createCarbonVis: ->
    new CO2Emissions query: @queries.get(8)

  # Creates and returns the visualisation which shows the proportion of energy
  # generated from renewable, but unreliable, sources.
  #
  createRenewablesVis: ->
    new Renewables query: @queries.get(32)

  # Creates and returns the visualisation which shows the total cost, in
  # Euros, of the choices the user makes.
  #
  createCostsVis: ->
    new Costs query: @queries.get(23)

  # Creates the energy demand / energy supply graph which sits between the two
  # range groups.
  #
  createSupplyDemandVis: ->
    new SupplyDemand demand: @queries.get(518), supply: @queries.get(49)
