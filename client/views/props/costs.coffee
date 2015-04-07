{ IconDashboardProp } = require 'views/props/dashboard'

class exports.CostsView extends IconDashboardProp

  className:   'costs'
  lowerBetter: true

  # Queries and hurdle values.

  queries: [ 'total_costs' ]

  hurdles: [ 35, 37, 39, 41, 43, 45, 47, 49 ]

  states:  [ 'nine', 'eight', 'seven', 'six', 'five',
             'four', 'three', 'two', 'one' ]

  # Display settings.

  name: I18n.t 'scenes.etlite.costs'

  # Help Texts
  helpHeader: -> "props.costs.header"
  helpBody:   -> "props.costs.body"

