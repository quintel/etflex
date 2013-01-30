{ Input } = require 'models/input'

class exports.OneToManyInput extends Input
  values: ->
    option = @optionForKey @get('value')
    option.effects

  rawValues: ->
    values = {}
    values[@get('key')] = @get('value')

    values
