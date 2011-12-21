{ IconProp }    = require 'views/props/icon'
{ hurdleState } = require 'views/props'

class exports.HeaderIcon extends IconProp
  fadeType: 'parallel'

  constructor: (options) ->
    super

    # HeaderIcon currently assumes that the prop uses a single query only,
    # which is defined on the subclass as "@queries: [ query_key ]".
    @query = options.queries.get @constructor.queries[0]
    @query.bind 'change:future', => @refresh @query.get('future')

  # Updates the icon without re-rendering the whole view.
  refresh: (value) ->
    @setState hurdleState(this, value)

  render: ->
    super

    # Subclasses may omit the "icon-prop" class.
    element = $ @el
    element.addClass('icon-prop') unless element.hasClass('icon-prop')

    @refresh @query.get('future')

    this
