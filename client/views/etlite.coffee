application    = require 'app'
etliteTemplate = require 'templates/etlite'
sliderTemplate = require 'templates/slider'

sliderFixtures =
  left:
    [ { name: 'Energy-saving bulbs',  value:  0, unit: '%' }
      { name: 'Electric cars',        value: 30, unit: '%' }
      { name: 'Better insulation',    value: 12, unit: '%' }
      { name: 'Solar power',          value: 24, unit: '%' }
      { name: 'Devices',              value: 56, unit: '%' }
      { name: 'Home heating',         value: 53, unit: '%' } ]
  right:
    [ { name: 'Coal power plants',    value: 0,    max: 7 }
      { name: 'Gas power plants',     value: 26,   max: 7 }
      { name: 'Nuclear power plants', value: 47,   max: 4 }
      { name: 'Wind turbines',        value: 1337, max: 10000 }
      { name: 'Solar panels',         value: 754,  max: 10000 }
      { name: 'Biomass',              value: 103,  max: 1606, unit: ' km<sup>2</sup>' } ]

# A full-page view which recreates the ETLite interface.
#
class exports.ETLite extends Backbone.View
  id: 'etlite-view'

  events:
    'click a': 'navigateToSanity'

  navigateToSanity: (event) ->
    application.router.navigate 'sanity', true
    false

  # Renders the view which for the moment simply confirms that the user is now
  # on the ETLite page.
  #
  render: ->
    $(@el).html etliteTemplate
      sliderTemplate: sliderTemplate
      leftSliders:    sliderFixtures.left
      rightSliders:   sliderFixtures.right

    # Temporary. A Slider view will follow...
    _.each @$('.slider'), (slider) ->
      $slider  = $ slider
      $control = $slider.find '.control'

      $control.quinn
        value:       $control.data 'value'
        range:       [ 0, parseInt($control.data('max') || 100, 10) ]
        handleWidth: 31
        width:       271

        onChange: (newValue) -> $slider.find('.output').text(newValue)
        onSetup:  (v, quinn) -> quinn.trigger 'change'



    @delegateEvents()
    this
