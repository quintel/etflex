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

  # Given a number, rounds to to a certain number of decimal places. Returns
  # a string.
  #
  # number    - The number to be rounded.
  # precision - The number of decimal places to be shown.
  #
  precision: (number, precision) ->
    if precision is 0
      "#{Math.round number}"
    else
      # When precision is >= 1, we first round the number using the desired
      # precision and then, since floating-point arithmetic means that we may
      # still end up with a number with too many decimal places, forcefully
      # truncate the number.

      multiplier = Math.pow 10, precision

      rounded = Math.round(number * multiplier) / multiplier
      rounded = rounded.toString().split '.'

      if rounded.length is 1 then rounded else
        "#{rounded[0]}.#{rounded[1][0...precision]}"
