{ IconDashboardProp } = require 'views/props/dashboard'

class exports.InvestmentView extends IconDashboardProp

  className: 'investment'
  lowerBetter: true

  queries: [ 'etflex_households_investment_per_household' ]

  name: I18n.t 'scenes.etlite.investment'
