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
