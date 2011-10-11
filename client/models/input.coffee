{ InputDefinition } = require 'models/input_definition'

# Represents an externally-controlled variable, such as those used in
# ETEngine. Users can change the selected value of the Input to alter
# the scenario to meet their goals.
#
class exports.Input extends Backbone.Model

  # Creates a new Input. Contains the values set by the user and a
  # "definition" which contains static data from ETengine about the Input,
  # such as its key, min value, max value, unit, etc.
  #
  constructor: (attributes, options) ->
    super
      id:    attributes.id
      value: attributes.start_value or attributes.min_value or 0
    , options

    @def = new InputDefinition
      id:   attributes.id
      min:  attributes.min_value
      max:  attributes.max_value
      unit: attributes.unit
      name: attributes.name

  # A simple validator which ensures that the value is within the range
  # defined by the input definition.
  #
  validate: (attributes) ->
    # If a name attribute is present, then validate has been called by the
    # collection when adding an Input; just skip it since validation will be
    # performed on the correct attributes in the constructor.
    return if attributes.hasOwnProperty 'name'

    [ min, max ] = [ @def.min, @def.max ]

    if _.isNumber(attributes.value) and not (min <= attributes.value <= max)
      return "value must be between #{min} and #{max}"
