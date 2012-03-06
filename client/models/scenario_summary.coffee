# The Summary class contains basic information about a scenario such as the
# score, session ID, etc, so that we can display basic information (such as
# high-scores) without sending the considerable amount of JSON required by
# the Scenario model.
#
class exports.ScenarioSummary extends Backbone.Model
  idAttribute: 'session_id'
