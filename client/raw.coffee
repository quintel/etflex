# Contains "raw" inputs, queries, etc.
#
# I consider this /totally/ temporary; these will be served up by ETflex
# shortly, but I wanted somewhere to put them that wasn't app.coffee.

exports.inputs = [
  { id:  43, remoteId:  43, key: 'lighting',   start: 5, max:   100, unit: '%', disabled: true }
  { id: 146, remoteId: 146, key: 'cars',       start: 0, max:   100, unit: '%', disabled: true }
  { id: 336, remoteId: 336, key: 'insulation', start: 1, max:   100, unit: '%', disabled: true }
  { id: 348, remoteId: 348, key: 'heating',    start: 0, max:    80, unit: '%'   }
  { id: 366, remoteId: 366, key: 'appliances', start: 0, max:    20, unit: '%'   }
  { id: 338, remoteId: 338, key: 'heatPump',   start: 0, max:    80, unit: '%'   }
  { id: 315, remoteId: 315, key: 'coal',       start: 0, max:     7, unit: ''    }
  { id: 256, remoteId: 256, key: 'gas',        start: 0, max:     7, unit: ''    }
  { id: 259, remoteId: 259, key: 'nuclear',    start: 0, max:     4, unit: ''    }
  { id: 263, remoteId: 263, key: 'wind',       start: 0, max: 10000, unit: ''    }
  { id: 313, remoteId: 313, key: 'solar',      start: 0, max: 10000, unit: ''    }
  { id: 196, remoteId: 196, key: 'biomass',    start: 0, max:  1606, unit: ' km<sup>2</sup>' } ]

exports.queries = [
  { id: 'co2_emission_total' }
  { id: 'costs_total' }
  { id: 'share_of_renewable_electricity' }
  { id: 'electricity_production' }
  { id: 'final_demand_electricity' } ]
