class exports.LockedScenarioView extends Backbone.View
  render: ->
    template    = require('templates/locked_scenario')
    callbackUrl = require('app').user.surveyCallbackUrl

    @$el.html(template(callbackUrl: callbackUrl))

    this

  postRender: ->
    $('body').addClass('message')
