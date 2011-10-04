rangeTemplate = require 'templates/range'

# A view used for rendering a single range. The ETlite recreation has twelve
# of these split into two groups.
#
class exports.Range extends Backbone.View
  className: 'range'

  # Creates a new Range (aka Slider).
  #
  # options - An object containing additional options used to customise the
  #           way the view is rendered. At a minimum it must contain a `model`
  #           property.
  #
  # The `model` property requires a `name` (String) which should be the i18n
  # translated name for the range. It may optionally include:
  #
  #   `value` - The initial value of the range.
  #   `unit`  - A string appended to the value to indicate what is being
  #             quantified (km, litres, etc).
  #   `max`   - The maximum permitted value for the range. It is currently
  #             assumed (incorrectly) that all ranges start at 0.
  #
  # Examples
  #
  #   new Range(model: { name: "Hello", max: 50 })
  #
  constructor: (options) ->
    super options

    @model.value or= 0
    @model.max   or= 100
    @model.unit  or= ''

  # Renders the range, and sets up events.
  #
  # @return {Range} Returns self.
  #
  render: ->
    $(@el).html rangeTemplate name: @model.name, unit: @model.unit

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
