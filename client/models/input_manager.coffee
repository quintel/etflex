{ OneToOneInput }   = require 'models/inputs/one_to_one'
{ OneToManyInput }  = require 'models/inputs/one_to_many'
{ ManyToOneInput }  = require 'models/inputs/many_to_one'

{ Location }        = require 'models/location'
{ Group }           = require 'models/group'

class InputManager extends Backbone.Model
  constructor: (scene_inputs) ->
    @locations  = new Locations
    @inputs     = {}

    for location_definition in scene_inputs
      location = new Location position: location_definition.position
      @locations.add location

      for group_definition in location_definition.groups

        group = new Group key: group_definition.key
        location.get('groups').add group

        for input_definition in group_definition.inputs

          input_definition.position = location_definition.position
          input_definition.group    = group_definition.key

          switch input_definition.type
            when 'one_to_one'   then input = new OneToOneInput input_definition
            when 'one_to_many'  then input = new OneToManyInput input_definition

          group.get('inputs').add input

          @inputs[input_definition.key] = input

          # Instanciate the ManyToOne input in case it exists. It doesn't need
          # to go into the collection as it doesn't show on the UI. This is
          # just for reference purposes.
          if input_definition.parent
            @inputs[input_definition.parent.key] = new ManyToOneInput input_definition.parent, @

  location: (position) ->
    _.find @locations.models, (location) ->
      location.get('position') == position

  values: ->
    values = {}

    for key, input of @inputs
      _.extend values, input.values() 
    values

