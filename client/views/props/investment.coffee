{ DashboardProp } = require 'views/props/dashboard'

class exports.InvestmentView extends DashboardProp

  className: 'investment'

  queries: [ 'etflex_households_investment_per_household' ]

  name: I18n.t 'scenes.etlite.investment'

  constructor: (options) ->
    super options

  render: ->
    super =>
      @$el.prepend """
        <div class='icon-prop'>
        </div>"""
