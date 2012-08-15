{ InputDefinition } = require 'models/input_definition'

class exports.Input extends Backbone.Model

  # Creates a new Input. Contains the values set by the user and a
  # "definition" which contains static data from ETengine about the Input,
  # such as its key, min value, max value, unit, etc.
  #
  constructor: (attributes, options) ->
    @def = new InputDefinition attributes

    super
      id:       attributes.key
      value:    attributes.start or attributes.min or 0
      location: attributes.location
      position: attributes.position
      disabled: attributes.disabled
    , options

    @quinn = new $.Quinn $('<div/>'),
      value:   @get 'value'
      min:     @def.min
      max:     @def.max
      step:    @def.step
      disable: @get 'disabled'
      renderer: ->

    @on 'change:value', @updateQuinnFromModel

  # Returns if this is an internal input, not to be shown to the user.
  #
  isInternal: ->
    @get('location') is '$internal'

  # Triggered when the value is updated so that the Quinn value may be kept in
  # sync with the model vlaue.
  #
  updateQuinnFromModel: (model, value) =>
    @quinn.setValue value

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
