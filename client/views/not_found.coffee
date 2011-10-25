app = require 'app'

class exports.NotFoundView extends Backbone.View
  id:        'not-found-view'
  className: 'error-view'

  events:
    'click a': 'navigateToRoot'

  render: ->
    pText = I18n.t 'fourOhFour',
      frontPage: "<a href='/'>#{I18n.t('frontPage')}</a>"

    $(@el)
      .append($("<h1>#{I18n.t('oops')}!</h1>"))
      .append($("<p>#{pText}</p>"))

    this

  navigateToRoot: (event) ->
    app.router.navigate '', true
    event.preventDefault()
