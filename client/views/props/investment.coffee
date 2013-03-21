{ IconDashboardProp } = require 'views/props/dashboard'

class exports.InvestmentView extends IconDashboardProp

  className: 'investment'
  lowerBetter: true

  queries: [ 'etflex_households_investment_per_household' ]
  hurdles: [ 2900, 9600, 16300, 23000 ]
  states:  [ 'very-low', 'low', 'medium', 'high', 'very-high' ]

  name: I18n.t 'scenes.etlite.investment'

  # Help Texts
  helpHeader: -> "props.investment.header"
  helpBody:   -> "props.investment.body"
