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
      id:       attributes.remoteId
      value:    attributes.start or attributes.min or 0
      location: attributes.location
      position: attributes.position
      disabled: attributes.disabled
    , options

    @def = new InputDefinition
      id:   attributes.remoteId
      min:  attributes.min
      max:  attributes.max
      unit: attributes.unit
      step: attributes.step
      key:  attributes.key
      info: attributes.info

  # Handles persistance of the Input back to ETengine; delegates to the main
  # collection instance of InputManager.
  #
  # See Backbone.sync.
  #
  sync: (method, model, options) ->
    unless @collection?
      throw 'Cannot persist an input without a collection'

    switch method
      when 'create' then false
      when 'read'   then @collection.manager.read   model, options
      when 'update' then @collection.manager.update model, options
      when 'delete' then false

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
