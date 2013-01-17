{ Input } = require 'models/input'

class exports.ManyToOneInput extends Input
  values: ->
    console.log 'HERE'
    key         = @get('key')
    formula     = @get('formula')
    engine_key  = @get('engine_key')

    variables = {}
    values    = {}

    for dependant in @get('dependant')
      value = @manager.inputs[dependant].get('value')
      variables[dependant] = value

    values[engine_key] = @formula_function(formula).evaluate(variables)

    values


