app          = require 'app'
rootTemplate = require 'templates/root'
{ SceneNav } = require 'views/scene_nav'

# Shows the landing page.
class exports.RootView extends Backbone.View
  id:        'root-view'
  className: 'static-message'

  events: { 'click a': 'clientNavigate' }

  render: ->
    @$el.html rootTemplate(scenes: @options.scenes.models)
    @$('#header').append (new SceneNav).render().el
    this

  # Intercepts clicks on links to local pages and loads them in the client,
  # instead of reloading the applicaion.
  clientNavigate: (event) ->
    href = $(event.target).attr 'href'

    if href[0..7] isnt 'http://'
      app.navigate href
      event.preventDefault()
