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
          values[engine_key] = @formulaFunction(formula).evaluate(variables)

        else
          values[engine_key] = value

      when 'radio'
        option = @optionForKey @get('value')
        values = option.effects

    values
    
  rawValues: ->
    values = {}
    values[@get('key')] = @get('value')

    values


