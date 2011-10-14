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

  gas:        256
  coal:       315
  nuclear:    259 # or 413?
  wind:       263 # or 265, 265?
  solar:      313
  biomass:    272

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
    'click a.clear': 'clearInputStorage'

  # Creates a new instance of the ETLite view.
  #
  # Creates a subset of the main Queries collection containing only those
  # queries required by this view.
  #
  constructor: (args...) ->
    super args...

    qColl    = app.collections.queries
    @queries = new Queries ( qColl.get key for key in [ 32, 49, 518 ] )

    iColl    = app.collections.inputs
    @inputs  = new Inputs ( iColl.get key for own v, key of INPUT_MAP )

    # Also temporary...
    @inputs.bind 'change:value', (input) =>
      app.session.updateInputs [ input ], @queries, (err, queries) ->
        console.log err, queries

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
    @fetchInputs()

    $(@el).html etliteTemplate()

    leftRangesEl  = @$ '#savings'
    rightRangesEl = @$ '#energy-production'

    # Render each of the ranges...

    _.each @savingsInputs, (range) ->
      leftRangesEl.append new Range(model: range).render().el

    _.each @productionInputs, (range) ->
      rightRangesEl.append new Range(model: range).render().el

    # Add three visualisations to the bottom of the page.

    @$('#visualisations')
      .append(@createRenewablesVis().render().el)
      .append(@createCarbonVis().render().el)
      .append(@createCostsVis().render().el)

    # And add the supply / demand graph.

    @$('#energy-generation').replaceWith @createSupplyDemandVis().render().el

    @delegateEvents()
    this

  # Retrieves the inputs needed to render the view, and memoizes them for
  # future reference. Sliders can be found on @savingsInputs and
  # @productionInputs.
  #
  fetchInputs: ->
    inputs = app.collections.inputs

    # Fetch inputs which we need and aren't already present in the collection.
    needed = ( id for own lKey, id of INPUT_MAP when not inputs.get(id) )

    @savingsInputs or= [
      inputs.getByName 'Low-energy lighting'
      inputs.getByName 'Electric cars'
      inputs.getByName 'Better insulation'
      inputs.getByName 'Solar water heater'
      inputs.getByName 'Switch off appliances'
      inputs.getByName 'Heat pump for the home'
    ]

    @productionInputs or= [
      inputs.getByName 'Coal-fired power plants'
      inputs.getByName 'Gas-fired power plants'
      inputs.getByName 'Nuclear power plants'
      inputs.getByName 'Wind turbines'
      inputs.getByName 'Solar panels'
      inputs.getByName 'Biomass'
    ]

  # Callback for the "Clear Input Storage" button. Wipes out all of the inputs
  # which should be followed by a browser refresh.
  #
  clearInputStorage: (event) =>
    head.destroy() while head = app.collections.inputs.first()
    event.preventDefault()

  # Creates and returns the visualisation which shows the total amount of
  # carbon emissions based on the user's choices.
  #
  createCarbonVis: ->
    new CO2Emissions
      gas:  @productionInputs[0]
      coal: @productionInputs[1]

  # Creates and returns the visualisation which shows the proportion of energy
  # generated from renewable, but unreliable, sources.
  #
  createRenewablesVis: ->
    new Renewables queries: @queries

  # Creates and returns the visualisation which shows the total cost, in
  # Euros, of the choices the user makes.
  #
  createCostsVis: ->
    new Costs
      lighting:   @savingsInputs[0]
      cars:       @savingsInputs[1]
      insulation: @savingsInputs[2]
      heating:    @savingsInputs[3]
      appliances: @savingsInputs[4]
      heatPump:   @savingsInputs[5]

      gas:        @productionInputs[0]
      coal:       @productionInputs[1]
      nuclear:    @productionInputs[2]
      wind:       @productionInputs[3]
      solar:      @productionInputs[4]
      biomass:    @productionInputs[5]

  # Creates the energy demand / energy supply graph which sits between the two
  # range groups.
  #
  createSupplyDemandVis: ->
    new SupplyDemand queries: @queries
