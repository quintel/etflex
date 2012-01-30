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
    @inputs    = []
    @precision = 0
    @max       = 100

  # Adds an input whose value should be balanced.
  #
  add: (input) ->
    @inputs.push input
    input.change 'value', @onChange

    @precision = _.max([ @precision,
      getPrecision(input.get('value')),
      getPrecision(input.def.step) ])

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
    subordinates   = getSubordinates @inputs, master
    balancedInputs = ( new BalancedInput input for input in subordinates )

    # Return quickly if none of the subordinates can be changed.
    return [] unless subordinates.length

    sumValues = _.invoke @inputs, 'get', 'value'
    sumValues = _.inject sumValues, ((m, v) -> m + v), 0

    # Flex is the amount of "value" which needs to be adjusted for, e.g. if an
    # input in a group is increased from 0 to 20, the sum of all the inputs
    # will come to 120; the flex will be -20 indicating that other inputs in
    # the group need to be reduced by 20 to compensate.
    flex = @max - sumValues

    # Try a max of 20 times to balance.
    iterations      = 20
    iterationInputs = _.clone balancedInputs

    while iterations--
      nextIterationInputs = []
      iterStartFlex       = flex
      iterDelta           = cumulativeDelta(iterationInputs)

      for input in iterationInputs
        # The amount of flex given to each input. Calculated each time we
        # balance an input since the previous one may have used up all the
        # available flex (due to rounding).
        flexPerSlider = iterStartFlex * (input.delta / iterDelta)

        prevValue = input.value
        newValue  = input.setValue prevValue + flexPerSlider

        flex -= newValue - prevValue

        # Finally, if this input can still be changed further, it may be used
        # again in the next iteration.
        nextIterationInputs.push input if input.canChangeDirection flex

      # These inputs will be used next time around...
      iterationInputs = nextIterationInputs

      # If the flex is all used up, or wasn't changed, don't waste time doing
      # more iterations.
      break if flex is 0 or flex is iterStartFlex

    if flex >= 0.1 or flex <= -0.1 then [] else
      _.invoke balancedInputs, 'commit'
      subordinates

# Misc Helpers ---------------------------------------------------------------

# Given a number, returns the precision (number of decimal places).
#
getPrecision = (number) ->
  number.toString().split('.')?[1]?.length or 0

# Given a collection of inputs, returns the collection minus the "master" and
# and members which cannot be changed any further.
#
getSubordinates = (inputs, master) ->
  ( input for input in inputs when input.id isnt master.id )

# Sums the delta of all the given inputs.
cumulativeDelta = (inputs) ->
  delta = 0
  delta += input.delta for input in inputs
  delta

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
  constructor: (@input, @precicion) ->
    @id    = @input.id
    @value = @input.get 'value'
    @delta = @input.def.max - @input.def.min

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
    newValue = @input.def.min if newValue < @input.def.min
    newValue = @input.def.max if newValue > @input.def.max

    return @value = newValue

  # Asserts if the input can be changed in the direction of the flex.
  canChangeDirection: (flex) ->
    (flex < 0 and @value isnt @input.def.min) or
       (flex > 0 and @value isnt @input.def.max)

  # Sets the input value to the one calculated in setValue.
  commit: ->
    @input.set { value: @value }, silent: true
