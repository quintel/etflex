{ IconProp } = require 'views/props/icon'

class exports.EnergySourcesProp extends IconProp
  @queries: [ 'total_electricity_produced',
              'electricity_produced_from_uranium'
              'electricity_produced_from_solar'
              'electricity_produced_from_oil' ]

  className:  'energy-sources icon-prop'
  fadeType:   'parallel'

  constructor: (options) ->
    super

    @queries = ( options.queries.get(key) for key in @constructor.queries )

    # Since all the queries are (normally) updated at the same time, wait
    # until we have results for them all before updating the prop.
    @refresh = _.debounce @refresh, 50

    for query in @queries then query.bind 'change:future', =>
      @refresh (query.get('future') for query in @queries)...

  refresh: (total, nuclear, solar, oil) ->
    if nuclear / total > 0.08
      @setState 'nuclear'
    else if solar / total > 0.00034
      @setState 'solar'
    else
      @setState 'oil'

  render: ->
    super

    @refresh (query.get('future') for query in @queries)...
    this
