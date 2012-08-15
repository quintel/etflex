# An InputDefinition is a 1-to-1 mapping with an ETengine input. It contains
# static, unchanging information about the input such as it's minimum and
# maximum values.
#
# The user-entered value is stored in an Input model.
#
class exports.InputDefinition

  constructor: (attributes) ->
    @id    = attributes.key
    @key   = attributes.key
    @min   = attributes.min   or 0
    @max   = attributes.max   or 100
    @step  = attributes.step  or 1
    @start = attributes.start or attributes.min
    @unit  = attributes.unit  or ''
    @info  = attributes.info  or null
    @group = attributes.group or null
