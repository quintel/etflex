template        = require 'templates/props/dashboard'
newTemplate     = require 'templates/props/dashboard_new'
{ GenericProp } = require 'views/props/generic'
{ IconProp }    = require 'views/props/icon'

# Helpers --------------------------------------------------------------------

exports.DISPLAY_PERCENTAGE = (v) -> I18n.toPercentage v, precision: 1
exports.DISPLAY_EUROS      = (v) -> I18n.toCurrency   v, unit: '€'

# View Classes ---------------------------------------------------------------

# A base class used by props which appear in the dashboard section. Shows an
# icon visualisation, and a nicely formatted version of the query value, and
# the change from the previous value.
#
class exports.DashboardProp extends GenericProp

  # Creates a new DashboardProp.
  #
  # Since props on the dashboard use only a single query to change the state
  # of the icon, the first query key in the @queries array will be assumed to
  # be the correct one.
  #
  # The query instance will be set to @query, and @updateValues will be run
  # every time the query value changes.
  #
  constructor: (options) ->
    super

    @query = options?.queries.get @constructor.queries?[0]
    @query.on 'change:future', @updateValues if @query

    @icon = new IconProp

  # Public Attributes --------------------------------------------------------
  #
  # You may override these in subclasses to customise behaviour.

  # Returns the query value *as a number* divided or multiplied as necessary
  # in order to arrive at a final value which is suitable for display.
  #
  # For example, if the query result arrives in tons, but you want to show a
  # value which is in kilotons, you might override transformValue to do so:
  #
  #   mutateValue: (value) -> value / 1000
  #
  # By default, formatQuery = x -> x
  #
  mutateValue: _.identity

  # Returns the query value formatted for display to the user. By default this
  # formats the value in the user's locale with a precision of one decimal
  # place. You may optionally decide to add extra information. For example:
  #
  #   displayValue: (value) -> "#{ super value } tribbles"
  #   # => "1,337 tribbles"
  #
  # The optional second parameter customises the number of decimal places
  # shown:
  #
  #   displayValue: (value) -> super value, 2
  #   # => "42.42"
  #
  # Of course, you need not call super if you want to display something other
  # than a number:
  #
  #   displayValue: (value) -> if value is 42 then "Success" else "Failure"
  #   # => "Success"
  #
  #   displayValue: (value) -> I18n.toCurrency value, unit: "ISK"
  #   # => "42,000,000 ISK"
  #
  #   displayValue: I18n.toPercentage
  #   # => "42%"
  #
  displayValue: (value, precision = 1) ->
    I18n.toNumber value, precision: precision, strip_insignificant_zeros: true

  # Internal Methods ---------------------------------------------------------

  # Renders a simple template, and assigns values and events.
  #
  # execute - An optional function which is run after the template has been
  #           rendererd, but prior to calling updateValues and super.
  #
  render: (execute) ->
    @$el.html newTemplate { @name, @unit, @lowerBetter }
    execute?()
    @updateValues()

    super

  # Updates the query value which is shown to the user, adjusts the icon as
  # necessary, and calculates the change from the old value.
  #
  updateValues: =>
    value     = @mutateValue @query.get 'future'
    previous  = @mutateValue @query.previous 'future'

    @$('.output').html @displayValue value
    @setDifference value - previous

    value

  # Shows the user the difference between the previous value of a prop, and
  # the new value. Formats the number appropriately for the user locale.
  #
  # difference - The difference between the old and new values.
  # options    - Options which are passed to the I18n formatted.
  #
  setDifference: (difference, options = { precision: 1 }) ->
    element = @$el.find '.difference'

    # Clear out other classes by default
    element.attr class: 'difference'

    # The locale-formatted difference.
    formatted  = I18n.toNumber difference, options

    # Don't display the difference if, when rounded to the precision, it would
    # equal 0 (e.g. score increases by 0.1, but we only care when it increases
    # in whole numbers).
    difference = parseFloat @precision(difference,
      if options.precision? then options.precision else 1)

    if difference > 0
      element.addClass('up').html "#{formatted}"
    else if difference < 0
      element.addClass('down').html "#{formatted}"
    else
      element.html ""

# A common version of the dashboard prop which swaps between two or more icons
# which represent the state of a single query.
#
class exports.IconDashboardProp extends exports.DashboardProp

  # Creates the IconProp used to display the query state.
  #
  constructor: -> super ; @icon = new IconProp

  # Renders the icon template.
  render: -> super => @$('.icon').replaceWith @icon.render().el

  # Updates the icon when the query changes.
  updateValues: => _.tap super, (value) => @icon.setState @hurdleState value
