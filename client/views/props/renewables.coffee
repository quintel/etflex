{ GenericProp } = require 'views/props/generic'
{ IconProp }    = require 'views/props/icon'

class exports.RenewablesView extends GenericProp
  @queries: [ 'renewability' ]
  states:   [ 'low', 'medium', 'high', 'extreme' ]

  className: 'prop renewables'

  # Creates a new Renewables prop. Calculates the percentage of total energy
  # generated which is derived from solar and window energy.
  #
  constructor: (options) ->
    super options

    @icon = new IconProp

    @query = options.queries.get 'renewability'
    @query.on 'change:future', @updateValues

  # Renders the UI; calculates the CO2 emissions. Can be safely called
  # repeatedly to update the UI.
  #
  render: ->
    super '', I18n.t 'scenes.etlite.renewables'

    @$el.find('.icon').replaceWith @icon.render().el
    @updateValues()

    this

  # Updates the value shown to the user, and swaps the icon if necessary,
  # without re-rendering the whole view.
  #
  updateValues: =>
    # Multiply the query value by 100 to get a percentage.
    value = @query.get('future') * 100

    # Reduce the value to three decimal places when shown.
    @$el.find('.output').html "#{@precision value, 3}%"

    @icon.setState @hurdleState value

    this
