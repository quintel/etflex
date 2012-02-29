{ IconDashboardProp, DISPLAY_EUROS } = require 'views/props/dashboard'

class exports.CostsView extends IconDashboardProp

  className:   'costs'
  lowerBetter: true

  # Queries and hurdle values.

  @queries: [ 'total_costs' ]

  hurdles:  [ 38, 40, 42, 44, 48, 50, 52 ]

  states:   [ 'nine', 'eight', 'seven', 'six', 'five',
              'four', 'three', 'two', 'one' ]

  # Display settings.

  name: I18n.t 'scenes.etlite.costs'
  unit: I18n.t 'scenes.etlite.billion'

  # Convert euros to billions.

  mutateValue:  (value) -> value / 1000000000
  displayValue: DISPLAY_EUROS
