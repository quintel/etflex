jQuery ->
  # The jQuery instance for the input form.
  inputForm  = $ 'form.input, form.scene_input'
  startQuinn = null

  # Do nothing if we're not on a page with an input editor.
  return unless inputForm.length

  # Draw the wrapper for the form element.
  $('.slider').append $ '<div class="widget"></div>'

  # The input fields.
  stepField  = $ '[name*="[step]"]',  inputForm
  minField   = $ '[name*="[min]"]',   inputForm
  maxField   = $ '[name*="[max]"]',   inputForm
  startField = $ '[name*="[start]"]', inputForm

  num = _.isNumber

  # Update the start field when the slider is moved.
  updateStartField = (value, quinn) ->
    # How many decimal places do we step to?
    precision = stepField.val().split('.')
    precision = precision?[1]?.length or 0

    startField.val value.toFixed precision

  # Recreate the Quinn instance whenever one of the value fields is changed.
  redrawQuinn = (event) ->
    start = parseFloat startField.val()
    step  = parseFloat stepField.val()
    min   = parseFloat minField.val()
    max   = parseFloat maxField.val()

    unless num(start) and num(step) and num(min) and num(max)
      startQuinn?.disable()
    else
      $('.slider .widget div', inputForm).remove()
      $('.slider .widget').append $ '<div></div>'

      startQuinn = new $.Quinn $('.widget div', inputForm),
        value:   parseFloat( startField.val() )
        step:    parseFloat( stepField.val() )

        range: [ parseFloat( minField.val() )
                 parseFloat( maxField.val() ) ]

        onChange: updateStartField
        onCommit: updateStartField

  # Events.
  stepField.bind  'change', redrawQuinn
  minField.bind   'change', redrawQuinn
  maxField.bind   'change', redrawQuinn
  startField.bind 'change', redrawQuinn

  redrawQuinn()
