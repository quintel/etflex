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

  # False will prevent the sliders changes being committed.
  canChange: true

  constructor: ({ @canChange }) ->
    super

    @precision = @model.def.step.toString().split('.')
    @precision = @precision[1]?.length or 0

    @rangeName = I18n.t "inputs.#{ @model.def.key }"

  # Renders the range, and sets up events.
  #
  # @return {Range} Returns self.
  #
  render: () ->
    # TODO Add a "unitHtml helper somewhere.
    unit = switch @model.def.unit
      when 'km2' then " km<sup>2</sup>"
      else            @model.def.unit

    @$el.html rangeTemplate
      name:        @rangeName
      hasInfo:     @model.def.info?
      unit:        unit

    @quinn = new $.Quinn @$('.control'),
      value:       @model.get('value')
      range:     [ @model.def.min, @model.def.max ]
      step:        @model.def.step
      handleWidth: 28
      width:       300

      disable:     @model.get('disabled')

      onSetup:     @updateOutput
      onChange:    @updateOutput
      onCommit:    @updateModel

    @model.bind 'change:value', @updateQuinnFromModel

    @delegateEvents()
    this

  # Updates the .output element with the input value. Used as an onChange
  # callback when creating the Quinn instance.
  #
  # value - The input value to be inserted into the output element.
  # quinn - The Quinn instance which changed.
  #
  updateOutput: (value, quinn) =>
    @$('.output').text I18n.toNumber value, precision: @precision

  # Saves the model with the new value. Used as an onCommit callback for the
  # Quinn instance.
  #
  # value - The new input value.
  # quinn - The Quinn instance which changed.
  #
  updateModel: (value, quinn) =>
    if @canChange then @model.set(value: value) else
      console.warn """
        Cannot change scene: it belongs to someone else.

        A dialog box will soon be added which informs the user of this fact,
        and provides the option of "forking" the scenario so that they may
        customise the values, or of starting the scenario from scratch.
      """

      false

  # Triggered when the model value changes (such as when an API request
  # failed).
  #
  # model - The model instance.
  # value - The new value.
  #
  updateQuinnFromModel: (model, value) =>
    @quinn.setValue value, true

  # Shows a modal help message, providing the user with more information about
  # the input and how it affects the outcome.
  #
  showHelp: ->
    showMessage @rangeName, @model.def.info
