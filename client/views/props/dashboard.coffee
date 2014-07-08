template        = require 'templates/props/dashboard'
{ GenericProp } = require 'views/props/generic'
{ IconProp }    = require 'views/props/icon'

cssTransitionAnimation = (element) ->
  element.addClass('zoom')
  console.log element
  setTimeout((-> element.removeClass('zoom')), 850)

jsAnimation = (element) ->
  element.find('.difference .effect')
    .hide().show('bounce', { times: 3 }, 'slow')

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

    @query = options?.queries.get @queries?[0]
    @query.on 'change:future', @updateValues if @query

    @icon = new IconProp

  # Internal Methods ---------------------------------------------------------

  # Renders a simple template, and assigns values and events.
  #
  # execute - An optional function which is run after the template has been
  #           rendererd, but prior to calling updateValues and super.
  #
  render: (execute) ->
    @$el.html template { @name, @unit, @lowerBetter }
    execute?()
    @updateValues()

    super

  # Updates the query value which is shown to the user, adjusts the icon as
  # necessary, and calculates the change from the old value.
  #
  updateValues: =>
    value     = @query.mutated 'future'
    previous  = @query.mutated 'future', 'previous'

    @$('.value .output').html @query.formatted 'future'
    @setDifference value - previous

    value

  # Shows the user the difference between the previous value of a prop, and
  # the new value. Formats the number appropriately for the user locale.
  #
  # difference - The difference between the old and new values.
  # options    - Options which are passed to the I18n formatted.
  #
  setDifference: (difference, options) ->
    options or= { precision: 1, strip_insignificant_zeros: true }

    effect  = @$('.difference .effect')
    element = @$('.difference .output')

    # Clear out other classes by default
    element.attr class: 'output'

    # The locale-formatted difference.
    formatted  = I18n.toNumber difference, options

    # Don't display the difference if, when rounded to the precision, it would
    # equal 0 (e.g. score increases by 0.1, but we only care when it increases
    # in whole numbers).
    difference = parseFloat @precision(difference,
      if options.precision? then options.precision else 1)

    if difference
      if difference > 0
        element.addClass('up').html "#{formatted}"
      else
        element.addClass('down').html "#{formatted}"

      if Modernizr.csstransforms
        cssTransitionAnimation(@$el)
      else
        jsAnimation(@$el)
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

class exports.IconDashboardWithNeedleProp extends exports.IconDashboardProp
  updateValues: =>
    val = super

    bottomValue = @hurdles[0]
    topValue    = @hurdles.slice(-1)[0]

    degrees = (val / (topValue - bottomValue)) * 166
    degrees = 166 if degrees > 166
    degrees = 0   if degrees < 0

    @$('.needle')
      .css('-moz-transform', "rotate(#{degrees}deg)")
      .css('-webkit-transform', "rotate(#{degrees}deg)")
      .css('-ms-transform', "rotate(#{degrees}deg)")
      .css('-o-transform', "rotate(#{degrees}deg)")

  render: =>
    super

    @$el.append '<span class="needle"></span>'
    @updateValues()
    this
