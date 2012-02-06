rootTemplate = require 'templates/root'
{ SceneNav } = require 'views/scene_nav'

# Shows the landing page.
class exports.RootView extends Backbone.View
  id:        'root-view'
  className: 'static-message'

  render: ->
    @$el.html rootTemplate(scenes: @options.scenes.models)
    @$('#header').append (new SceneNav).render().el
    this