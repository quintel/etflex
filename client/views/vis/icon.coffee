{ GenericVisualisation } = require 'views/vis/generic'

# IconVisualisation is used when displaying a visualisation which alters it
# appearance by changing from one icon to another. One such example might be
# changing from an icon showing a jar with lots of money, to an empty jar,
# based on the total cost of a scenario.
#
class exports.IconVisualisation extends Backbone.View

  className: 'icon'

  # Sets the view to the given state name. Adds the state name to the main
  # element and executes the callback given when the state was added.
  #
  # Example:
  #
  #   vis.setState 'high'
  #
  # Example:
  #
  #   vis.setState 'low'
  #
  # The second example will remove the previous "high" state and set the view
  # state to "low".
  #
  # When changing state, the following events will be triggered:
  #
  # * leaveState:oldState
  # * enterState:newState
  # * change
  #
  setState: (name) ->
    return true if name is @currentState

    element = $ @el

    if @currentState?
      @trigger "leaveState:#{@currentState}"
      element.removeClass @currentState

    @currentState = name

    @trigger "enterState:#{@currentState}"
    element.addClass @currentState
