app          = require 'app'
{ BaseView } = require 'views/backstage/base'

# A simpler way to render a view and replace the <body> element.
render = (view) -> $('body').html(view.render().el)

# A router which controls the actions and pages which are displayed in the
# /backstage section of the application.
#
class exports.Backstage extends Backbone.Router
  routes:
    'backstage':        'redirectToScenesIndex'
    'backstage/scenes': 'scenesIndex'

  # The default landing page for the Backstage section; redirects the user to
  # /backstage/scenes.
  #
  # GET /backstage
  #
  redirectToScenesIndex: ->
    app.navigate 'backstage/scenes'

  # Displays a list of scenes which the user may edit, and allows the user to
  # show the form for adding a new scene.
  #
  # GET /backstage/scenes
  #
  scenesIndex: ->
    render new BaseView
