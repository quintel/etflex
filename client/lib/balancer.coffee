class exports.Balancer
  # Creates a new balancer, used to ensure that a group of inputs have a
  # cumulative value of 100.
  #
  # Terminology
  #
  #   master:
  #
  #     When the user begins to alter a slider, this slider is designated the
  #     master. A slider is only a master while the user is making a change.
  #
  #   subordinates:
  #
  #     When the user is altering a slider value, all of the other sliders,
  #     minus those which are disabled, are considered subordinates. The
  #     subordinates are the sliders whose values are changes to ensure that
  #     the group remains balanced.
  #
  constructor: (options = {}) ->
    @inputs       = []
    @subordinates = null
    @precision    = 0
    @max          = 100

  # Adds an input whose value should be balanced.
  #
  add: (input) ->
    @inputs.push input
    input.change 'value', @onChange

    inputPrecision = getPrecision input.def.step
    @precision = inputPrecision if inputPrecision > @precision

  # Triggered when the user alters a slider; performs balancing of the
  # subordinates.
  #
  # Returns an array of inputs whose values were changed in order to balance
  # the collection. An empty array will be returned if the balancing could not
  # be completed; it is assumed that ETEngine will reject the change.
  #
  # master - The input which has been changed by the user and should not
  #          be altered during balancing.
  #
  performBalancing: (master) ->
    iterations   = 20
    previousFlex = null

    subordinates = getSubordinates @inputs, master

    # Return quickly if none of the subordinates can be changed.
    return [] unless subordinates.length

    balancedInputs  = ( new BalancedInput input for input in subordinates )
    iterationInputs = _.clone balancedInputs

    sumValues = _.invoke @inputs, 'get', 'value'
    sumValues = _.inject sumValues, ((m, v) -> m + v), 0

    # Return quickly if the collection is already balanced.
    return [] if sumValues is @max

    # Flex is the amount of "value" which needs to be adjusted for. e.g.,
    #
    #   max: 100
    #   input 1: 0
    #   input 2: 100
    #
    # If slider 1 is moved to 25, the flex is -25 since, in order to balance
    # the inputs, we need to subtract 25 from the subordinates.
    #
    flex = roundToPrecision @max - sumValues, @precision

    while iterations--
      nextIterationInputs = []

      for input, i in iterationInputs
        # The amount of flex given to each input. Calculated each time we
        # balance a slider since the previous one may have used up all the
        # available flex (due to rounding).
        flexPerSlider = roundToPrecision flex / (balancedInputs.length - i)

        prevValue = input.value
        newValue  = input.setValue prevValue + flexPerSlider

        # Reduce the flex by the amount by which the input was changed, ready
        # for subsequent iterations.
        flex -= newValue - prevValue

        # Finally, if this input can still be changed futher, it may be used
        # again in the next iteration.
        if (flex < 0 and input.value isnt input.input.def.min) or
           (flex > 0 and input.value isnt input.input.def.max)
          nextIterationInputs.push input

      iterationInputs = nextIterationInputs

      # If the flex is all used, or the iteration failed to assign any more
      # of the flex, don't iterate again.
      break if flex is 0 or previousFlex is flex

      previousFlex = flex

    # If we still have flex left over, we probably couldn't divide what
    # remains between the inputs, so we try to "brute-force" by giving all
    # that remains to each input.
    #
    if flex isnt 0 then for input in iterationInputs
      prevValue = input.value
      newValue  = input.setValue prevValue + flex

      # Round here otherwise floating point errors start to pile up.
      flex = roundToPrecision flex - (newValue - prevValue), @precision

      break if flex is 0

    # if flex is 0 then _.invoke(balancedInputs, 'commit') else false
    if flex isnt 0 then [] else
      _.invoke balancedInputs, 'commit'
      subordinates

# Misc Helpers ---------------------------------------------------------------

# Given a value and precision, "snaps" it to match the precision. For example,
# if the precision is 1 it will round the value to the nearest 0.1.
#
roundToPrecision = (number, precision) ->
  parseFloat number.toFixed precision

# Given a number, returns the precision (number of decimal places).
#
getPrecision = (number) ->
  number.toString().split('.')?[1]?.length or 0

# Given a collection of inputs, returns the collection minus the "master" and
# and members which cannot be changed any further.
#
getSubordinates = (inputs, master) ->
  ( input for input in inputs when input.id isnt master.id )

# BalancedInput --------------------------------------------------------------

# BalancedInput holds a copy of the Input min, max and step values and is used
# by the balancer so that it can split the "flex" between each input.
#
# antw: Ideally I want to get rid of this by splitting Quinn into two separate
#       parts - one for handling the logic (value, min, max, snapping values,
#       etc), and another for the (HTML) rendering. With a two-part  Quinn
#       each Input could use a Quinn instance with no renderer to handle
#       sanitizing values instead of duplicating a lot of what Quinn already
#       does here.
#
#       But until I have the time to do this, BalancedInput will have to
#       suffice.
#
class BalancedInput
  constructor: (@input) ->
    @id        = @input.id
    @value     = @input.get 'value'
    @precision = getPrecision @input.def.step

  # Given a new value, will seek to set the (internal) value for the input.
  # The value will be checked to ensure that it is within the min-max range,
  # and will be "snapped" to the step value.
  #
  # If the value is not valid, setValue will try to set the closes valid value
  # instead. setValue will always return the new value of the input.
  #
  # IMPORTANT NOTE: The input value is not actually changed until you call
  #                 commit().
  #
  setValue: (newValue) ->
    # Snap the new value to the @precision.
    newValue = roundToPrecision newValue, @precision
    given = newValue

    # Round it to the step value.
    multiplier = 1 / @input.def.step
    newValue   = Math.round(newValue * multiplier) / multiplier

    newValue = @input.def.min if newValue < @input.def.min
    newValue = @input.def.max if newValue > @input.def.max

    return @value = newValue

  # Sets the input value to the one calculated in setValue.
  commit: ->
    @input.set { value: @value }, silent: true
