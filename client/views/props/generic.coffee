propTemplate     = require 'templates/prop'
{ hurdleState }  = require 'views/props'

# A generic, placeholder prop which has an empty space for some sort of icon
# or illustration, and a formatted value.
#
# In your subclasses, you may customise the "className" attribute to add
# extra CSS classes to the prop. You must, however, always include "prop" as
# one of the classes. For example, you may add "lower-better" to indicate
# that the difference arrows be reversed so that a lower value is considered
# good (shown in green) and a higher value is considered bad:
#
#   class MyProp extends GenericProp
#     className: 'prop lower-better'
#
class exports.GenericProp extends Backbone.View
  className: 'prop'

  render: (value, unit) ->
    @$el.html propTemplate value: value, unit: unit

    @delegateEvents()
    this

  # TODO: move this function to a generic class of Application wide helpers
  #       It now also lives in generic.coffee
  #
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

  # Given a query value, returns which "state" that value corresponds to based
  # on the array of "hurdles" which the instance was initialized with. If the
  # instance does not have a "states" attribute, or @options does not have a
  # "hurdles" attribute, then "null" will be returned.
  #
  # value - The query value.
  #
  hurdleState: (value) ->
    hurdleState this, value

  # Shows the user the difference between the previous value of a prop, and
  # the new value. Formats the number appropriately for the user locale.
  #
  # difference - The difference between the old and new values.
  # options    - Options which are passed to the I18n formatted.
  #
  setDifference: (difference, options = { precision: 1 }) ->
    element = @$el.find '.difference'

    # Clear out other classes by default
    element.attr class: 'difference'

    # The locale-formatted difference.
    formatted = I18n.toNumber difference, options

    if difference > 0
      element.addClass('up').html "#{formatted}"
    else if difference < 0
      element.addClass('down').html "#{formatted}"
    else
      element.html ""
