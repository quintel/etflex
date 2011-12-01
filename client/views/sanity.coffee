application    = require 'app'
sanityTemplate = require 'templates/sanity'

# A full-page view which confirms to the user that Backbone, CoffeeScript and
# Eco templates are working correctly.
#
class exports.SanityView extends Backbone.View
  id: 'sanity-view'

  events:
    'click a': 'navigateToETLite'

  navigateToETLite: (event) ->
    application.navigate 'scenes/1', true
    event.preventDefault()

  # Renders the view which adds text to the page indicating that Backbone is
  # correctly configured.
  #
  render: ->
    link = "<a href='/scenes/1'>#{ I18n.t('etlite.link') }</a>"

    $(@el).html sanityTemplate
      header:  I18n.t('etlite.header')
      hello:   I18n.t('etlite.hello')
      message: I18n.t('etlite.message', link: link)

    @delegateEvents()

    this
