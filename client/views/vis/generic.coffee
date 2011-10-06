visTemplate = require 'templates/visualisation'

# A generic, placeholder visualisation which has an empty space for some sort
# of icon or illustration, and a formatted value.
#
class exports.GenericVisualisation extends Backbone.View
  className: 'visualisation'

  render: (value, unit) ->
    $(@el).html visTemplate value: value, unit: unit

    @delegateEvents()
    this
