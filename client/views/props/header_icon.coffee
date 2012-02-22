{ IconProp }    = require 'views/props/icon'
{ hurdleState } = require 'views/props'
{ showMessage } = require 'lib/messages'

class exports.HeaderIcon extends IconProp
  fadeType: 'parallel'

  constructor: (options) ->
    super

    # Trigger doRefresh when any of the queries used by the prop are updated.
    for key in @constructor.queries
      options.queries.get(key).on 'change:future', @doRefresh

    # Since all the queries are (normally) updated at the same time, wait
    # until we have results for them all before updating the prop.
    @refresh = _.debounce @refresh, 25 if @constructor.queries.length > 1

  render: ->
    super

    keyClass = @options.key?.replace('_', '-')

    @$el.addClass('icon-prop') unless @$el.hasClass('icon-prop')
    @$el.addClass(keyClass)    unless @$el.hasClass(keyClass)

    @doRefresh()

    this

  # Updates the icon without re-rendering the whole view. Only accounts for
  # value from the first query; props which use more than one value must
  # override this method in a subclass.
  #
  # NOTE! Props with more than one query result in the refresh function being
  # debounced by Underscore; it will be executed after a 25ms delay to ensure
  # that Backbone has time to update all the queries before refreshing the
  # prop.
  #
  # value - The new query value.
  #
  refresh: (value) ->
    @setState hurdleState(this, value)

  # Returns the query future value whose key is "key"
  q: (key) ->
    @options.queries.get(key).get('future')

  # Internally used to call refresh with the value of each query.
  doRefresh: =>
    @refresh ( @q(key) for key in @constructor.queries )...
