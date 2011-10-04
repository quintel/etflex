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
#       gas2020:   { event: 'change:value' }
#       gas2050:   { event: 'change:value' }
#       co2target: { event: 'change:value' }
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
class Mediator
  # Holds the values calculated by the Mediator.
  values: {}

  # Holds the functions used to fetch the raw value from each input.
  fetchers: {}

  # Holds each input which is observed by the mediator.
  subjects: {}

  # Creates a new Mediator instance.
  #
  constructor: (subjects) ->
    @observe key, subject for own key, subject of subjects

    for own key, options of @inputs
      options       or=  {}
      options.with  or=  defaultFetcher
      options.event or= 'change:value'

      @fetchers[key]       = options.with(key, this)
      @fetchers[key].event = options.event

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
    # if @subjects[key]?
    #   # Another object is already being observed for the given key, so we
    #   # need to stop watching for changes.
    #   @subjects[key].unbind @inputs[key], @fetchers[key]

    @subjects[key] = subject
    @subjects[key].bind @fetchers[key].event, @fetchers[key]

    # TODO Definitely need to find a better way to set the initial value than
    #      triggering a change event on the subject.
    subject.trigger @fetchers[key].event

    this

  # Called whenever one of the inputs change. This should be overridden in
  # subclasses to perform whatever calculations you need, and then fire off
  # the mediator's change events.
  #
  # By default, this simply sets the mediator key to the new value.
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
    @set key, newValue

  # Returns a value which the mediator has calculated.
  #
  get: (key) ->
    @values[key]

  # Sets a mediator value. This should be used internally, only by your custom
  # notify method, and not by any external class.
  #
  # key     - The input key which corresponds with the value being set.
  # value   - The new value.
  # options - Add silent: true if you do not wish to fire the change
  #           callbacks.
  #
  set: (key, value, options = { silent: false }) ->
    if @get(key) isnt value
      @values[key] = value

      unless options.silent
        @trigger "change:#{key}", value, this
        @trigger "change",        this

    value

# Backbone.Events doesn't work when doing class ... extends for some reason.
_.extend Mediator::, Backbone.Events

# Fetchers -------------------------------------------------------------------

# Returns a function which is used to retrieve a value from an input.
#
# We need to keep track of individual functions like this within the Mediator
# so that it is possible to unbind the events if we assign a new input.
#
defaultFetcher = (key, mediator) ->
  # Returns a function which acts as the callback on the subject.
  (subject, newValue) -> mediator.notify key, newValue, subject

# A mediator fetcher which extracts a value from a Quinn onChange event.
#
quinnFetcher = (key, mediator) ->
  # Returns a function which acts as the callback on the subject.
  (newValue, quinn) -> mediator.notify key, newValue, quinn

# Exports --------------------------------------------------------------------

exports.Mediator       = Mediator
exports.defaultFetcher = defaultFetcher
exports.quinnFetcher   = quinnFetcher
