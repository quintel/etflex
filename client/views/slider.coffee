sliderTemplate = require 'templates/slider'

# A view used for rendering a single slider. The ETlite recreation has twelve
# of these split into two groups.
#
class exports.Slider extends Backbone.View
  className: 'slider'

  # Creates a new Slider.
  #
  # options - An object containing additional options used to customise the
  #           way the view is rendered. At a minimum it must contain a `model`
  #           property.
  #
  # The `model` property requires a `name` (String) which should be the i18n
  # translated name for the slider. It may optionally include:
  #
  #   `value` - The initial value of the slider.
  #   `unit`  - A string appended to the value to indicate what is being
  #             quantified (km, litres, etc).
  #   `max`   - The maximum permitted value for the slider. It is currently
  #             assumed (incorrectly) that all sliders start at 0.
  #
  # Examples
  #
  #   new Slider(model: { name: "Hello", max: 50 })
  #
  constructor: (options) ->
    super options

    @model.value or= 0
    @model.max   or= 100
    @model.unit  or= ''

  # Renders the slider, and sets up events.
  #
  # @return {Slider} Returns self.
  #
  render: ->
    $(@el).html sliderTemplate name: @model.name, unit: @model.unit

    @$('.control').quinn
      value:       @model.value
      range:       [ 0, @model.max ]
      handleWidth: 31
      width:       271

      onChange:    @onChange
      onSetup:     @onChange

    @delegateEvents()
    this

  # Event triggered when the Quinn onChange event is fired. Updates the
  # value displayed to the user.
  #
  onChange: (newValue, quinn) =>
    @$('.output').text newValue
