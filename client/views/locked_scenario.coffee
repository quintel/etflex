class exports.LockedScenarioView extends Backbone.View
  render: ->
    @$el.html require('templates/locked_scenario')()

    this

  postRender: ->
    $('body').addClass('message')
