optionsTempl = require 'templates/options'

class exports.OptionsView extends Backbone.View
  canChange: true

  constructor: ({ @canChange }) ->
    super

  renderInto: (destination) ->
    @el = optionsTempl(key: @model.get('key'), options: @model.get('options'))
    destination.append @el

    @updateOutput @model.get('value')
    $("input[name='#{@model.get('key')}']").change _.bind(@updateModel, @)

  updateOutput: (value) ->
    $("##{value}_option").attr('checked', true)

  updateModel: (ev) ->
    value = $(ev.target).val()
    @model.set(value: value)
