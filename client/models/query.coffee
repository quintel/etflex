transforms = require 'lib/query_transforms'

# Represents a Query which is executed by ETengine (known there as a Gquery).
#
# ETflex worries only about the ID of the query, while `api::updateInputs`
# handles fetching new values for one or more Query instances when updating
# the user inputs.
#
# The usual "change:present" and "change:future" events will be fired when the
# computed Query results are updated.
#
class exports.Query extends Backbone.Model
  hookupDynamicQuery: ->
    gquery = @collection.meta("#{@id}_gquery")
    return unless gquery?

    return if @collection.get gquery

    @boundQuery = new Query({ id: gquery })
    @boundQuery.on 'all', @delegateSetEvents

    @collection.add @boundQuery

  # Whenever a `set(...)` is called on a @boundQuery, this method will set the
  # equivelant attribute on this query also. It is triggered to the "all"
  # event on @boundQuery but only acts on "change" events.
  delegateSetEvents: (eventName, query, value, options) =>
    if match = eventName.match(/^change:(.*)$/)
      @set(match[1], @boundQuery.get(match[1]), options)

  # A hack around the fact that Backbone does not fire change events for
  # attributes have not actually changed. Passing `{force: true}` as an option
  # will insist that Backbone fires the events.
  #
  # Note that the implementation IS NOT compatible with Backbone 1.0 and will
  # require some minor changes when upgrading.
  set: (key, val, options) ->
    # Handle both `"key", "value"` and `{key: value}` -style arguments
    if typeof key is 'object'
      attrs   = key
      options = val
    else
      (attrs = {})[key] = val

    if options?.force
      previous = _.clone(@attributes)

      # Call Backbone's "set" method, but without triggering any events. We'll
      # handle this ourselves.
      super(attrs, _.extend({}, options, silent: true))

      for key, value of attrs when _.isEqual(value, previous[key])
        # If the value hasn't changed from the previous value, Backbone will
        # not have marked the attribute as changed. We have to do that
        # manually to ensure the change:... event is fired.
        @_changed[key] = value

      @change(options)
    else
      super

  # Returns a nicely formatted version of the query value.
  #
  # How the value should be formatted is determined by the query_transforms
  # module in client/lib.
  #
  formatted: (attribute, accessor = 'get') ->
    transforms.forQuery(this).format @mutated(attribute, accessor)

  # Returns a mutated version of the query value.
  #
  # Mutating the value is transforming it into one which is more suitable
  # for use within ETFlex. For example, total CO2 emissions in kg is a very
  # big number, so it might instead be converted into megatons.
  #
  # TODO Mutated is a rubbish name. Any better ideas?
  #
  mutated: (attribute, accessor = 'get') ->
    transforms.forQuery(this).mutate @[ accessor ] attribute
