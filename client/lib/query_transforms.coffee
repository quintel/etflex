# When a query does not define a formatting function, this is used instead.
FORMAT_DEFAULT = (value, precision = 0) ->
  withPrecision(I18n.toNumber, value,
    precision: precision, strip_insignificant_zeros: true)

# Formatter which displays a value in euros
FORMAT_EUROS = (value) ->
  withPrecision(I18n.toCurrency, value, unit: '€')

# Formatter which displays a percentage.
FORMAT_PERCENT = (value, precision = 0) ->
  withPrecision(I18n.toPercentage, value,
    precision: precision, strip_insignificant_zeros: true)

FORMAT_PERCENT_WITH_PRECISION = (precision) ->
  (value) ->
    withPrecision(I18n.toCurrency, value, precision: precision, unit: '€')

# Calls a number formatter, testing that the precision - if present - is set
# to a sensible value.
#
# If the "value" is zero, and "precision" is zero, then the I18n library
# outputs a blank string. withPrecision will force the precision to 1 so that
# a zero is returned.
withPrecision = (func, value, options = {}) ->
  if options?.hasOwnProperty('precision') and options.precision is 0
    if value is 0
      options.precision = 1
    else
      # Prevents a bug in I18n from truncating "100" to "1".
      options.strip_insignificant_zeros = false

  func.call(I18n, value, options)

# Returns a function which divides a value by divisor.
divide = (divisor) -> ((value) -> value / divisor)

# Returns a function which multiplies a value by multiplier.
multiply = (multiplier) -> ((value) -> value * multiplier)

# Formats a value with the given unit.
as = (unit, precision = 0) ->
  (value) -> "#{FORMAT_DEFAULT(value, precision)} #{unit}"

# Retrieves the mutate/format definitions for a given query.
exports.forQuery = (query) ->
  exports.forQueryKey(query.id)

# Retrieves the mutate/format definitions for a given query by its key.
exports.forQueryKey = (queryKey) ->
  if found = TRANSFORMS[ queryKey ]
    found.mutate = _.identity unless found.mutate
    found.format = FORMAT_DEFAULT unless found.format
    found
  else
    TRANSFORMS[ queryKey ] = { format: FORMAT_DEFAULT, mutate: _.identity }

# Transforms -----------------------------------------------------------------

TRANSFORMS =
  # ETFlex score must be rounded to a whole number, and restricted to no less
  # than 0 and no more than 999.
  score:
    mutate: (value) ->
      if (rounded = Math.round value) < 0
        0
      else if rounded > 999
        999
      else
        rounded

  # CO2 emissions arrive in kg so we convert to megatons.
  total_co2_emissions:
    mutate: divide 1000000000
    format: as 'Mtonnes'

  # Total costs come in Euros; convert to billions.
  total_costs:
    mutate: divide 1000000000
    format: (value) ->
      I18n.t 'magnitudes.billion', amount: "€#{ Math.round(value) }"

  security_of_supply_reliability:
    mutate: (value) -> value * 100
    format: FORMAT_PERCENT

  # Renewables arrives as a factor and should be displayed as a percentage.
  renewability:
    mutate: (value) -> value * 100
    format: FORMAT_PERCENT

  etflex_households_co2_emissions_per_household:
    format: as 'tonnes', 1

  etflex_households_investment_per_household:
    format: FORMAT_PERCENT_WITH_PRECISION(0)

  etflex_households_monthly_energy_bill:
    format: FORMAT_PERCENT_WITH_PRECISION(0)

  etflex_households_final_demand_electricity_per_household:
    format: as "kWh"

  etflex_households_final_demand_network_gas_per_household:
    format: as "m<sup>3</sup>"

  etflex_households_percentage_renewable_energy_per_household:
    format: as '%'
