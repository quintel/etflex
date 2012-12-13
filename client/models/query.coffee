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

    @boundQuery = new Query({ id: gquery })
    @boundQuery.on 'change', _.bind(@onChange, this)
    @collection.add @boundQuery

  onChange: ->
    @set 'future', @boundQuery.get('future')
    @set 'present', @boundQuery.get('present')

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
