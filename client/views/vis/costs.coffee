{ GenericVisualisation } = require 'views/vis/generic'

class exports.CostsView extends GenericVisualisation
  @queries: [ 23 ]

  # Creates a new Costs visualisation. Calculates the cost of the choices the
  # user makes in the ETLite module.
  #
  constructor: (options) ->
    super options

    @query = options.queries.get 23
    @query.bind 'change:future', @render

  # Renders the UI; calculates the C02 emissions. Can be safely called
  # repeatedly to update the UI.
  #
  render: =>
    value = @precision @query.get('future') / 1000000000, 3
    super("€#{value} #{I18n.t 'etlite.billion'}", I18n.t 'etlite.costs')
