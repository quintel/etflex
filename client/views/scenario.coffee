scenarioTemplate   = require 'templates/scenario'

class exports.ScenarioView extends Backbone.View

  render: () ->
    @$el.html scenarioTemplate
      userName:    @model.user_id

    this
