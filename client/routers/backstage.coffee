app          = require 'app'
render       = require 'lib/render'
{ BaseView } = require 'views/backstage/base'

{ Inputs }   = require 'collections/inputs'

# A router which controls the actions and pages which are displayed in the
# /backstage section of the application.
#
class exports.Backstage extends Backbone.Router
  routes:
    'backstage':        'redirectToInputsIndex'
    'backstage/scenes': 'scenesIndex'
    'backstage/inputs': 'inputsIndex'

  # The default landing page for the Backstage section; redirects the user to
  # /backstage/scenes.
  #
  # GET /backstage
  #
  redirectToInputsIndex: ->
    app.navigate 'backstage/scenes'

  # SCENES -------------------------------------------------------------------

  # Displays a list of scenes which the user may edit, and allows the user to
  # show the form for adding a new scene.
  #
  # GET /backstage/scenes
  #
  scenesIndex: ->
    render new BaseView

  # INPUTS -------------------------------------------------------------------

  # Displays a list of inputs which the user may edit.
  #
  # GET /backstage/inputs
  #
  inputsIndex: ->
    # TODO new Inputs.Backstage?
    inputs = new Inputs
    inputs.url = '/backstage/inputs'

    inputs.fetch success: => render new BaseView(collection: inputs),
                 error:   -> console.error 'Could not load inputs'
