{ Groups } = require 'collections/groups'

class exports.Location extends Backbone.Model
  constructor: (attributes) ->
    super attributes

    @set 'groups', new Groups if !@get 'groups'


  group: (key) ->
    _.find @get('groups').models, (group) ->
      group.get('key') == key


