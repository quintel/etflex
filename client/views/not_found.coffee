app = require 'app'

class exports.NotFoundView extends Backbone.View
  id:        'not-found-view'
  className: 'error-view'

  events:
    'click a': 'navigateToRoot'

  render: ->
    $(@el).append(
      $("<div class='message'></div>")
        .append($("<h1>#{ I18n.t 'oops' }!</h1>"))
        .append($("<p>#{ I18n.t 'fourOhFour' }</p>"))
        .append($("<p><a href='/'>#{ I18n.t 'frontPage' }.</a></p>")))

    this

  navigateToRoot: (event) ->
    app.router.navigate '', true
    event.preventDefault()
