# Given a number, converts it to a form which can be more easily read by a
# visitor. For example (assuming US/UK locale):
#
#   humanize.number 5              # => "5"
#   humanize.number 100            # => "100"
#   humanize.number 1_000          # => "1,000"
#   humanize.number 100_000        # => "100,000"
#   humanize.number 1_123_523      # => "1.12 million"
#   humanize.number 11_421_000     # => "11.4 million"
#   humanize.number 111_421_000    # => "111 million"
#   humanize.number 1_123_523_000  # => "1.12 billion"
#
exports.number = (number) ->
  if not _.isNumber number
    '???'
  else if number >= 1000000000
    # Billions.
    I18n.t 'magnitudes.billion', amount: formatNumber(number / 1000000000)
  else if number >= 1000000
    # Millions.
    I18n.t 'magnitudes.million', amount: formatNumber(number / 1000000)
  else
    formatNumber number

# Helpers --------------------------------------------------------------------

# Formats a number which is being truncated to a given precision, with a word
# suffix used to indicate a power of ten. For example, in the NL locale:
#
#   formatNumber 1.1234  # => "1.12"
#   formatNumber 11.234  # => "12.1"
#   formatNumber 123.34  # => "123"
#
formatNumber = (number, key) ->
  precision =
    if      number >= 100 then 0
    else if number >=  10 then 1
    else                       2

  console.log precision

  I18n.toNumber number, precision: precision
