app                = require 'app'
rootTemplate       = require 'templates/root'

{ SceneNav }       = require 'views/scene_nav'
{ clientNavigate } = require 'lib/client_navigate'

# Shows the landing page.
class exports.RootView extends Backbone.View
  id:        'root-view'
  className: 'static-message'

  events: { 'click a': clientNavigate }

  render: ->
    @$el.html rootTemplate(scenes: @options.scenes.models)
    @$('#header').append (new SceneNav).render().el
    this
