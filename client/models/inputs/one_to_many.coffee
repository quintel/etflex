{ Input } = require 'models/input'

class exports.OneToManyInput extends Input
  values: ->
    option = @option_for_key @get('value')
    option.effects


