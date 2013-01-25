optionsTempl = require 'templates/options'

class exports.OptionsView extends Backbone.View
  canChange: true

  constructor: ({ @canChange }) ->
    super

  renderInto: (destination) ->
    @el = optionsTempl(key: @model.get('key'), options: @model.get('options'))
    destination.append @el

    $("input[name='#{@model.get('key')}']").change _.bind(@updateModel, @)

    @updateOutput @model.get('value')

  updateOutput: (value) ->
    $("##{value}_option").attr('checked', true)

  updateModel: (ev) ->
    value = $(ev.target).val()

    if @canChange then @model.set(value: value) else
      @trigger 'notAuthorizedToChange'
      false
