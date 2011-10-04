# The Mediator is designed to aggregate input, whether API responses from
# ETengine, model value change events, or direct input from the user, and
# transform those inputs into values for an Output.
#
# http://en.wikipedia.org/wiki/Mediator_pattern
#
# The Mediator also acts a little like a ModelView so that the view doesn't
# need to worry about the data coming from the Model, but only has to account
# for the already-transformed values from the Mediator.
#
# http://en.wikipedia.org/wiki/Model_View_ViewModel
#
# Mediator is currently an experiement to see how well we can decouple the
# inputs received by the application, and how those are displayed back to the
# user. Rather than views binding directly to `change` events in a model, the
# view will receive a Mediator _instead of_ a model, and bind to its change
# events instead.
#
# The mediator observes changes elsewhere in the application (such as model or
# collection change events) and then fires its own change events as necessary.
#
# Note that the mediator is a work-in-progress and will likely change as more
# visualisations (outputs) are added.
#
# Example
#
#   class GasMediator extends Mediator
#     inputs:
#       gas2020:   'change:value'
#       gas2050:   'change:value'
#       co2Target: 'change:target'
#
#   gasMediator = new GasMediator
#     gas2020:   aModel
#     gas2050:   aRange
#     co2Target: anotherThing
#
#   view = new GasView mediator: gasMediator
#
# In the above example, a GasMediator is present which watches three inputs.
# The mediator will watch for a 'change:value' event on the gas2020 and
# gas2050 inputs, and a 'change:target' event on the third input. When any of
# these events are triggered, the mediator will call @notify with the input
# key which changed ('gas2020') and the new value.
#
# Then, the mediator can perform whatever calculations it needs, and fire
# events to notify outputs of these changes.
#
class exports.Mediator extends Backbone.Events

  # Creates a new Mediator instance.
  #
  constructor: (subjects) ->
    @observe key, subject for own key, subject of subjects
    @fetchers = {}

    for own key, event of @inputs
      @fetchers[key] = createFetcher this, key

  # Observes changes in the the given `subject`, and associates that subject
  # with the `key`.
  #
  # key     - The corresponding `key` from the `inputs` object.
  # subject - The "thing" whose change events we want to observe.
  #
  # Returns self.
  #
  # Example
  #
  #   mediator.observe 'gas2020', aModel
  #
  observe: (key, subject) ->
    if @subjects[key]?
      # Another object is already being observed for the given key, so we need
      # to stop watching for changes.
      @subjects[key].unbind @inputs[key], @fetchers[key]

    @subjects[key] = subject
    @subjects[key].bind @inputs[key], @fetchers[key]

    this

  # Called whenever one of the inputs change. This should be overridden in
  # subclasses to perform whatever calculations you need, and then fire off
  # the mediator's change events.
  #
  # key      - A string which names the input whose value has changed.
  #            Corresponds with the input key in @inputs.
  # newValue - The new value of the input.
  # input    - The input itself, in case you need to fetch other values.
  #
  # Example
  #
  #   class GasMediator extends Mediator
  #     notify: (key, newValue, input) ->
  #       switch key
  #         when 'gas2020'   then doSomething     newValue
  #         when 'gas2050'   then doSomethingElse newValue
  #         when 'co2target' then doCarbonCalc    newValue
  #
  notify: (key, newValue, input) ->
    # Does nothing; override in a subclass.

# Returns a function which is used to retrieve a value from an input.
#
# We need to keep track of individual functions like this within the Mediator
# so that it is possible to unbind the events if we assign a new input.
#
createFetcher = (mediator, key) ->
  (input, newValue) -> mediator.notify key, newValue, input
