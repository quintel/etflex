rangeTemplate = require 'templates/range'

# A view used for rendering a single range. The ETlite recreation has twelve
# of these split into two groups.
#
class exports.Range extends Backbone.View
  className: 'range'

  # Becomes the Quinn instance once render() is called.
  quinn: null

  # Creates a new Range (aka Slider).
  #
  # options - An object containing additional options used to customise the
  #           way the view is rendered. At a minimum it must contain a `model`
  #           property.
  #
  # The `model` property is expected to be a Backbone model, or at least
  # provide `get`, `set`, and `save` methods.
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

  # Renders the range, and sets up events.
  #
  # @return {Range} Returns self.
  #
  render: (mediator) ->
    $(@el).html rangeTemplate
      name: @model.get('name'),
      unit: @model.get('unit')

    new $.Quinn @$('.control'),
      value:       @model.get('value')
      range:       [ 0, @model.get('max') ]
      handleWidth: 31
      width:       271

      onSetup:     @updateOutput
      onChange:    @updateOutput
      onCommit:    @updateModel

    @delegateEvents()
    this

  # Updates the .output element with the input value. Used as an onChange
  # callback when creating the Quinn instance.
  #
  # value - The input value to be inserted into the output element.
  # quinn - The Quinn instance which changed.
  #
  updateOutput: (value, quinn) =>
    @$('.output').text value

  # Saves the model with the new value. Used as an onCommit callback for the
  # Quinn instance.
  #
  # value - The new input value.
  # quinn - The Quinn instance which changed.
  #
  updateModel: (value, quinn) =>
    @model.set value: value
    @model.save()
