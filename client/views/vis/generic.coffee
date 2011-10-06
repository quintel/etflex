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

  # Given a number, rounds to to a certain number of decimal places.
  #
  # number    - The number to be rounded.
  # precision - The number of decimal places to be shown.
  #
  precision: (number, precision) ->
    if precision is 0
      Math.round number
    else
      Math.round(number * (10 * precision)) / (10 * precision)
