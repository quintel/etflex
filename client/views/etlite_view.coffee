# A full-page view which recreates the ETLite interface.
#
class ETF.ETLiteView extends Backbone.View
  id: 'etlite-view'

  # Renders the view which for the moment simply confirms that the user is now
  # on the ETLite page.
  #
  render: ->
    $(@el).append JST["templates/etlite"]
    this
