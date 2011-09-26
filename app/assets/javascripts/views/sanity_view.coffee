class @SanityView extends Backbone.View
  events:
    'click a': 'navigateToETLite'

  # Renders the view which adds text to the page indicating that Backbone is
  # correctly configured.
  #
  render: ->
    $(@el).append JST["templates/hello"]
      name: 'from an Eco template and a Backbone view!'

    this

  # When the user clicks any anchor element (there should only be one), change
  # to the ETLite mock-up page.
  #
  navigateToETLite: ->
    window.etfRouter.navigate 'etlite'
