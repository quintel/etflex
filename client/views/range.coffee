rangeTemplate   = require 'templates/range'
{ showMessage } = require 'lib/messages'

# A view used for rendering a single range. The ETlite recreation has twelve
# of these split into two groups.
#
class exports.Range extends Backbone.View
  className: 'range'

  # Events; the "help" icon clicker.
  events:
    'click .help': 'showHelp'

  # Becomes the Quinn instance once render() is called.
  quinn: null

  # Renders the range, and sets up events.
  #
  # @return {Range} Returns self.
  #
  render: (mediator) ->
    $(@el).html rangeTemplate
      name: @model.def.name,
      unit: @model.def.unit

    new $.Quinn @$('.control'),
      value:       @model.get('value')
      range:       [ 0, @model.def.max ]
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

  # Shows a modal help message, providing the user with more information about
  # the input and how it affects the outcome.
  #
  showHelp: ->
    showMessage 'Low-energy-lighting', """
      Incandescent light bulbs waste a lot of energy. The power they consume is
      mostly turned into heat instead of light. That is why, in Europe, we will
      all shift to low-energy lighting in the coming years. These new light
      bulbs emit the same amount of light and do not become so warm. They even
      last much longer than traditional light bulbs!
    """
