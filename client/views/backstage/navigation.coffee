navTemplate = require 'templates/backstage/navigation'

# A single item in the Navigation element; handles translation, uses the
# correct tag, etc.
#
class Item
  constructor: ({ @key, @href }) ->
    @name = I18n.t "navigation.#{@key}"

    if @href?
      @openingTag = "a href=\"#{@href}\""
      @closingTag = 'a'
    else
      @openingTag = 'span class="pseudo"'
      @closingTag = 'span'

# Represents a generic horizontal navigation element, such as the main
# navigation at the top of the Backstage page, or tabbed navigation on the
# sidebar.
#
class exports.Navigation extends Backbone.View
  className: 'navigation'
  tagName:   'ul'

  events:  { 'click a': 'itemClicked' }

  # Contains all the Item instances used by the navigation.
  items: []

  # Creates a new Navigation view.
  #
  # options - An object containing options for customising the view.
  #           Navigation expects this to contain -- at a minimum -- an "items"
  #           array containing the items to be added to the navigation view.
  #
  #           A "name" should also be provided which acts both as an
  #           additional class added to the DOM element, and as a namespace
  #           for fetching I18n values for each item.
  #
  #           Optionally add icons: true if each icon name is to be wrapped in
  #           a <span.icon> element.
  #
  # Example:
  #
  #   new Navigation
  #     name:  'main'
  #     icons: true
  #     items: [ { href: '...', name: 'scenes' }, ... ]
  #
  constructor: (options, args...) ->
    super

  # Creates the HTML representation of the navigation element.
  #
  render: ->
    $(@el).html navTemplate
      items:  ( new Item(item) for item in @options.items )
      name:     @options.name
      useIcons: @options.icons

    this

  # Event triggered when an item in the navigation is clicked.
  #
  itemClicked: (event) ->
    console.log event
    event.preventDefault()
