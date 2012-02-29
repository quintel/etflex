propTemplate    = require 'templates/prop'
{ showMessage } = require 'lib/messages'

{ hurdleState, insertQueryData } = require 'views/props'

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

  events:
    'click .help': 'showHelp'

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

      if rounded.length is 1 then rounded[0] else
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
    formatted  = I18n.toNumber difference, options

    # Don't display the difference if, when rounded to the precision, it would
    # equal 0 (e.g. score increases by 0.1, but we only care when it increases
    # in whole numbers).
    difference = parseFloat @precision(difference,
      if options.precision? then options.precision else 1)

    if difference > 0
      element.addClass('up').html "#{formatted}"
    else if difference < 0
      element.addClass('down').html "#{formatted}"
    else
      element.html ""

  # Shows a modal help message, providing the user with more information about
  # the prop.
  #
  # You are expected to provide an I18n key so that showHelp can determine
  # what text should be shown. For example:
  #
  #   showHelp 'car'
  #
  # ... will show as the title I18n.t "props.car.name" and as the main text
  # "props.car.info". The info text will be pre-parsed to insert query data as
  # necessary.
  #
  # You may optionally pass a "state" string to further customise the I18n
  # translation used:
  #
  #   showHelp 'co2_emissions', 'extreme'
  #
  # ... will show "props.co2_emissions.info.extreme" as the message.
  #
  showHelp: (key, state) ->
    # key may be an event if showInfo is triggered without being overridden
    # in a subclass.
    return false unless _.isString key

    messageKey = "props.#{ key }.info"
    messageKey = "#{ messageKey }.#{ state }" if state

    title   = I18n.t "props.#{ key }.name"
    message = I18n.t messageKey

    # Insert query data.
    message = insertQueryData message, @options.queries

    showMessage title, message
