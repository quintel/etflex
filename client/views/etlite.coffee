application         = require 'app'
etliteTemplate      = require 'templates/etlite'

{ Range }           = require 'views/range'
{ SavingsMediator } = require 'mediators/savings_mediator'

# A full-page view which recreates the ETLite interface. Six sliders are on
# the left of the UI allowing the user to control how savings can be made in
# energy use, and six on the right controlling how energy will be produced.
#
# A graph in the middle, and three image-based visualisations at the bottom
# provide feedback to the user based on the choices they make.
#
class exports.ETLite extends Backbone.View
  id: 'etlite-view'

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

    savingsMediator = new SavingsMediator

    # Temporary; to demonstrate that the mediator works.

    savingsMediator.bind 'change:sum', (newValue) =>
      @$('#energy-generation').text "Sum: #{newValue}"

    # Render each of the ranges...

    _.each @savingsInputs, (range) ->
      leftRangesEl.append new Range(model: range).render(savingsMediator).el

    _.each @productionInputs, (range) ->
      rightRangesEl.append new Range(model: range).render(savingsMediator).el

    @delegateEvents()
    this

  # Retrieves the inputs needed to render the view, and memoizes them for
  # future reference. Sliders can be found on @savingsInputs and
  # @productionInputs.
  #
  fetchInputs: ->
    inputs = application.collections.inputs

    @savingsInputs or= [
      inputs.getByName 'Energy-saving bulbs'
      inputs.getByName 'Electric cars'
      inputs.getByName 'Better insulation'
      inputs.getByName 'Solar power'
      inputs.getByName 'Devices'
      inputs.getByName 'Home heating'
    ]

    @productionInputs or= [
      inputs.getByName 'Coal power plants'
      inputs.getByName 'Gas power plants'
      inputs.getByName 'Nuclear power plants'
      inputs.getByName 'Wind turbines'
      inputs.getByName 'Solar panels'
      inputs.getByName 'Biomass'
    ]
