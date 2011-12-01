template       = require 'templates/backstage/base'
{ Navigation } = require 'views/backstage/navigation'

# A base view for the Backstage section; sets up the main navigation element.
#
class exports.BaseView extends Backbone.View
  id: 'backstage'
  events: { 'click a': 'cancelClick' }

  # Creates a new BaseView; instantiates the main navigation element.
  #
  constructor: ->
    super

    @navigation = new Navigation
      name: 'main',
      icons: true,
      items: [
        { key: 'scenes',   href: '#' }
        { key: 'inputs',   href: '#' }
        { key: 'queries',  href: '#' }
        { key: 'props',    href: '#' }
        { key: 'sign_out', href: '#' }
        { key: 'loading'             } ]

  # Creates the HTML elements for the view, and binds events. Returns self.
  #
  # Example:
  #
  #   view = new BaseView
  #   $('body').html view.render().el
  #
  render: ->
    $(@el).html template()
    @$('#header').append @navigation.render().el

    # The loading icon defaults to display: block (otherwise the "Loading"
    # label isn't removed by text-offset). Hide it now...
    @$('#header .loading .icon').css 'display', 'none'

    # Set the first menu item to selected'
    @$('#header .navigation li:first').addClass 'selected'

    this

  # Events -------------------------------------------------------------------

  # Intercepts clicks on anchors and prevents the default user action. Used
  # while mocking up the Backstage UI.
  #
  cancelClick: (event) ->
    event.preventDefault()
