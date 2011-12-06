collectionTemplate = require 'templates/backstage/collection'
itemTemplate       = require 'templates/backstage/collection_item'

# Given a Backbone.Collection, creates a view placed into the sidebar element
# which lists each item in the collection.
#
class exports.CollectionView extends Backbone.View
  className: 'collection-view'

  events:
    'click li.item': 'selectItem'

  # Creates a new CollectionView. Expects the options object to contain a
  # "collection" with the Backbone.Collection instance whose members are to be
  # shown in the list.
  #
  constructor: ({ @collection }) ->
    @currentItem = null
    super

  # Creates the HTML for the list and returns self.
  #
  render: ->
    $(@el).html collectionTemplate()
    ulElement = @$('ul.items')

    for document in _.sortBy(@collection.models, (el) -> el.def.key)
      ulElement.append itemTemplate
        id:  document.get('id')
        key: document.def.key

    this

  # Event triggered when an item is selected. Adds the blue "selected"
  # background to the item, and removes "selected" status from any other item
  # in the list.
  #
  selectItem: (event) ->
    element = $(event.target)

    # The event target may be a child event, so we have to traverse upwards to
    # find the <li> element.
    element = element.parent() until element.is 'li.item'

    # Make extra sure we found the list element.
    return false unless element.is 'li.item'

    # Immediately return if the user clicked the already-selected item.
    return false if @currentItem? and @currentItem is element

    @currentItem.removeClass 'selected' if @currentItem?

    @currentItem = element
    @currentItem.addClass 'selected'

    @trigger "selected:#{ @currentItem.data 'list-item' }"
