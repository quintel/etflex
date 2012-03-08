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

  # Subclasses should call `super` within their render method, *last*. For
  # example:
  #
  #   render: ->
  #     # code
  #     # more code...
  #     super
  #
  render: ->
    # Here we set generic CSS classes, and assign common events. These are
    # not added using the Backbone convention "className" and "events"
    # attributes so that subclasses don't need to worry about duplicating
    # them.
    @$el.addClass 'prop'
    @$el.on 'click', '.help', => @showHelp()

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
  showHelp: ->

    title   = I18n.t @helpHeader()
    message = I18n.t @helpBody()

    # Insert query data.
    title   = insertQueryData title,   @options.queries
    message = insertQueryData message, @options.queries

    showMessage title, message
