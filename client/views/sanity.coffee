application    = require 'app'
sanityTemplate = require 'templates/sanity'

# A full-page view which confirms to the user that Backbone, CoffeeScript and
# Eco templates are working correctly.
#
class exports.Sanity extends Backbone.View
  id: 'sanity-view'

  events:
    'click a': 'navigateToETLite'

  navigateToETLite: (event) ->
    application.router.navigate 'etlite', true
    event.preventDefault()

  # Renders the view which adds text to the page indicating that Backbone is
  # correctly configured.
  #
  render: ->
    $(@el).html sanityTemplate
      name: 'from Eco and Backbone'

    @delegateEvents()

    this
