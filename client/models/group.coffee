{ Inputs } = require 'collections/inputs'

class exports.Group extends Backbone.Model
  constructor: (attributes) ->
    super attributes

    @set 'inputs', new Inputs if !@get 'inputs'

  inputs: ->
    @get 'inputs'
