# A full-page view which confirms to the user that Backbone, CoffeeScript and
# Eco templates are working correctly.
#
class ETF.Views.Sanity extends Backbone.View
  id: 'sanity-view'

  events:
    'click a': 'navigateToETLite'

  navigateToETLite: (event) ->
    $etf.router.navigate 'etlite', true
    false

  # Renders the view which adds text to the page indicating that Backbone is
  # correctly configured.
  #
  render: ->
    $(@el).html JST["templates/hello"]
      name: 'from an Eco template and a Backbone view!'

    @delegateEvents()

    this
