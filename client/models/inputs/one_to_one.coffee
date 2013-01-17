{ Input } = require 'models/input'

class exports.OneToOneInput extends Input
  values: ->
    # Returns blank as the parent will calculate its value
    return {} if @get('parent')

    values      = {}
    key         = @get('key')
    engine_key  = @get('engine_key')
    value       = @get('value')

    switch @get('display')
      when 'slider'
        if formula = @get('formula')
          variables = {}
          variables[key] = value

          # Execute formula
          values[engine_key] = @formula_function(formula).evaluate(variables)

        else
          values[engine_key] = value

      when 'radio'
        option = @option_for_key @get('value')
        values = option.effects

    values


