# A full-page view which recreates the ETLite interface.
#
class ETF.Views.ETLite extends Backbone.View
  id: 'etlite-view'

  events:
    'click a': 'navigateToSanity'

  navigateToSanity: (event) ->
    $etf.router.navigate 'sanity', true
    event.stopPropagation()
    false

  # Renders the view which for the moment simply confirms that the user is now
  # on the ETLite page.
  #
  render: ->
    $(@el).html JST["templates/etlite"]
    @delegateEvents()
    this
