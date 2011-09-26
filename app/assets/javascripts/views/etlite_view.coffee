# A full-page view which recreates the ETLite interface.
#
class ETF.ETLiteView extends Backbone.View
  events:
    'click a': 'navigateToSanity'

  # Renders the view which for the moment simply confirms that the user is now
  # on the ETLite page.
  #
  render: ->
    $(@el).append JST["templates/etlite"]
    this

  # When the user clicks any anchor element (there should only be one), change
  # to the sanity page.
  #
  navigateToSanity: ->
    $etf.router.navigate 'sanity', true
