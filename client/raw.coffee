# Contains "raw" inputs, queries, etc.
#
# I consider this /totally/ temporary; these will be served up by ETflex
# shortly, but I wanted somewhere to put them that wasn't app.coffee.

exports.inputs = [
  { id:  43, key: 'lighting',   start_value: 5, max_value:   100, unit: '%', disabled: true }
  { id: 146, key: 'cars',       start_value: 0, max_value:   100, unit: '%', disabled: true }
  { id: 336, key: 'insulation', start_value: 1, max_value:   100, unit: '%', disabled: true }
  { id: 348, key: 'heating',    start_value: 0, max_value:    80, unit: '%'   }
  { id: 366, key: 'appliances', start_value: 0, max_value:    20, unit: '%'   }
  { id: 338, key: 'heatPump',   start_value: 0, max_value:    80, unit: '%'   }
  { id: 315, key: 'coal',       start_value: 0, max_value:     7, unit: ''    }
  { id: 256, key: 'gas',        start_value: 0, max_value:     7, unit: ''    }
  { id: 259, key: 'nuclear',    start_value: 0, max_value:     4, unit: ''    }
  { id: 263, key: 'wind',       start_value: 0, max_value: 10000, unit: ''    }
  { id: 313, key: 'solar',      start_value: 0, max_value: 10000, unit: ''    }
  { id: 196, key: 'biomass',    start_value: 0, max_value:  1606, unit: ' km<sup>2</sup>' } ]

exports.queries = [
  { id: 'co2_emission_total' }
  { id: 'costs_total' }
  { id: 'share_of_renewable_electricity' }
  { id: 'electricity_production' }
  { id: 'final_demand_electricity' } ]
