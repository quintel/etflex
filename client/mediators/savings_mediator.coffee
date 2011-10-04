{ Mediator, quinnFetcher } = require 'mediators/mediator'

# Takes the six "Savings" sliders and keep track of changes in their values.
# Also emits a "sum" value for drawing a simple bar graph.
#
class exports.SavingsMediator extends Mediator
  inputs:
    bulbs:      { event: 'change', with: quinnFetcher }
    cars:       { event: 'change', with: quinnFetcher }
    insulation: { event: 'change', with: quinnFetcher }
    solar:      { event: 'change', with: quinnFetcher }
    devices:    { event: 'change', with: quinnFetcher }
    heating:    { event: 'change', with: quinnFetcher }

  # Overrides the default notify so that we can also sum up the value of
  # each of the input ranges.
  #
  notify: (key, newValue, input) ->
    super key, newValue, input

    sum  = 0
    sum += @values[key] for own key, ignore of @inputs

    @set 'sum', sum if _.isNumber sum
