template = require 'templates/backstage/sidebar_search'

# A Backbone view which shows a search field in the sidebar and emits events
# as the user enters new characters in the field, or when they empty the
# field.
class exports.SidebarSearchView extends Backbone.View
  className: 'search'
  events:  { 'keyup input': 'propagateEvent' }

  # Creates a new SidebarSearchView.
  #
  # options - A hash of options used to customise the view:
  #
  # Accepted options:
  #
  #   placeholder - The placeholder text used in the input field when the user
  #                 has not entered any value.
  #   disabled    - A boolean indicating whether the input field should be
  #                 disabled.
  #   value       - An initial value which is used in the search field.
  #
  constructor: (options) ->
    @initialValue = options?.value
    @placeholder  = options?.placeholder
    @isDisabled   = options?.disabled

    super

  render: ->
    $(@el).append template
      placeholder: @placeholder
      value:       @initialValue
      disabled:    @isDisabled

    this

  # Called when the onChange event is triggered by a user changing the input
  # field; triggers a "change" or "reset" event based on the change made.
  #
  propagateEvent: (event) ->
    value = @$('input')

    if value is ''
      @trigger 'reset'
    else
      @trigger 'change', value
