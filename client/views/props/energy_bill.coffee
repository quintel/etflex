{ DashboardProp } = require 'views/props/dashboard'

class exports.EnergyBillView extends DashboardProp

  className: 'energy_bill'

  queries: [ 'etflex_households_monthly_energy_bill' ]

  name: I18n.t 'scenes.etlite.energy_bill'

  constructor: (options) ->
    super options

  render: ->
    super =>
      @$el.prepend """
        <div class='icon-prop'>
        </div>"""

