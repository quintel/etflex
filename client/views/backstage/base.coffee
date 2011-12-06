template           = require 'templates/backstage/base'
formTemplate       = require 'templates/backstage/input_form'
{ Navigation }     = require 'views/backstage/navigation'
{ CollectionView } = require 'views/backstage/collection'

# A base view for the Backstage section; sets up the main navigation element.
#
class exports.BaseView extends Backbone.View
  id: 'backstage'
  events: { 'click a': 'cancelClick' }
  pageTitle: 'Backstage'

  # Creates a new BaseView; instantiates the main navigation element.
  #
  constructor: ({ @collection }) ->
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
    @$('#header .navigation li.inputs').addClass 'selected'

    # Add the list of items to the sidebar.
    collView = new CollectionView collection: @collection
    @$('.sidebar').append collView.render().el

    # Clicking on sidebar items should activate the input form.
    collView.bind 'selected', (documentId) =>
      input = @collection.get(documentId)

      # ow, ow, ow: so hacky. extracting this to a separate view is a
      # priority, but this will have to do to deploy today...

      @$('#content').html formTemplate
        id:    input.get('id')
        key:   input.def.key
        min:   input.def.min
        max:   input.def.max
        start: input.get('value')

      @$('#content .commit button').click (event) =>
        event.preventDefault()

        # TODO Use ajaxStart to show/hide the loading icon.
        loading = $('#header .loading .icon').fadeIn('fast')
        values  = {}

        @$('.document-form input').each ->
          element = $ this
          values[ element.attr('name') ] = element.val()

        jQuery.post("#{ @collection.url }/#{ input.get('id') }.json", values)
          .success(-> loading.hide('fast'))
          .error(-> loading.hide('fast'))

    this

  # Run the the router after the DOM element is added to the display.
  #
  postRender: ->
    # The "search" box is a slightly different height depending on the
    # browser, we we need to re-adjus the top of the collection view.
    searchHeight = @$('.sidebar .search').outerHeight()
    @$('.sidebar .collection-view').css 'top', "#{searchHeight}px"

  # Events -------------------------------------------------------------------

  # Intercepts clicks on anchors and prevents the default user action. Used
  # while mocking up the Backstage UI.
  #
  cancelClick: (event) ->
    event.preventDefault()
