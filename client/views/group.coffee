groupTempl = require 'templates/group'

class exports.GroupView extends Backbone.View
  renderInto: (destination) ->
    @el = groupTempl(group: @model)
    destination.append @el
