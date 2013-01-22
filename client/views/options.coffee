optionsTempl = require 'templates/options'

class exports.OptionsView extends Backbone.View
  canChange: true

  constructor: ({ @canChange }) ->
    super

  renderInto: (destination) ->
    # @updateOutput @model.get('value')

    @el = optionsTempl(key: @model.get('key'), options: @model.get('options'))
    destination.append @el

    @updateOutput @model.get('value')

  updateOutput: (value) ->
    $("##{value}_option").attr('checked', true)
