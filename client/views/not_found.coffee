app = require 'app'

class exports.NotFound extends Backbone.View
  id:        'not-found-view'
  className: 'error-view'

  events:
    'click a': 'goToRoot'

  render: ->
    $(@el)
      .append($('<h1>Oops!</h1>'))
      .append($('<p>You appear to have arrived at a page which does ' +
                'not exist. Perhaps you might like to return to the ' +
                '<a href="/">front page</a>?</p>'))

    this

  goToRoot: (event) ->
    app.router.navigate '/', true
    event.preventDefault()
