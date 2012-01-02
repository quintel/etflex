rangeTemplate   = require 'templates/range'
{ showMessage } = require 'lib/messages'

# A view used for rendering a single range. The ETlite recreation has twelve
# of these split into two groups.
#
class exports.RangeView extends Backbone.View
  className: 'range'

  # Events; the "help" icon clicker.
  events:
    'click .help': 'showHelp'

  # Becomes the Quinn instance once render() is called.
  quinn: null

  constructor: ->
    super

    @precision = @model.def.step.toString().split('.')
    @precision = @precision[1]?.length or 0

  # Renders the range, and sets up events.
  #
  # @return {Range} Returns self.
  #
  render: (mediator) ->
    # TODO Add a "unitHtml helper somewhere.
    unit = switch @model.def.unit
      when 'km2' then " km<sup>2</sup>"
      else            @model.def.unit

    $(@el).html rangeTemplate
      name:    I18n.t "inputs.#{@model.def.key}.name"
      unit:    unit
      hasInfo: @model.def.info?

    new $.Quinn @$('.control'),
      value:       @model.get('value')
      range:     [ @model.def.min, @model.def.max ]
      step:        @model.def.step
      handleWidth: 28
      width:       300

      disable:     @model.get('disabled')

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
    @$('.output').text value.toFixed @precision

  # Saves the model with the new value. Used as an onCommit callback for the
  # Quinn instance.
  #
  # value - The new input value.
  # quinn - The Quinn instance which changed.
  #
  updateModel: (value, quinn) =>
    @model.set value: value

  # Shows a modal help message, providing the user with more information about
  # the input and how it affects the outcome.
  #
  showHelp: ->
    showMessage(
      I18n.t("inputs.#{@model.def.key}.name"),
      I18n.t("inputs.#{@model.def.key}.description"))
