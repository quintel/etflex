{ GenericVisualisation } = require 'views/vis/generic'

# IconVisualisation is used when displaying a visualisation which alters it
# appearance by changing from one icon to another. One such example might be
# changing from an icon showing a jar with lots of money, to an empty jar,
# based on the total cost of a scenario.
#
class exports.IconVisualisation extends Backbone.View

  className: 'icon-vis'

  render: ->
    @activeIcon   = $ @make 'span', class: 'icon'
    @inactiveIcon = $ @make 'span', class: 'icon'

    $(@el).append @activeIcon, @inactiveIcon

    this

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
  # * leavestate:oldState
  # * enterstate:newState
  # * change
  #
  setState: (name) ->
    return true if name is @currentState

    if @currentState?
      @trigger "leavestate:#{@currentState}"
      @activeIcon.removeClass 'active'

    @trigger "enterstate:#{name}"

    # Swap the icon divs around so that we can change state more than once.
    [ @activeIcon, @inactiveIcon ] = [ @inactiveIcon, @activeIcon ]

    # Prefered over addClass, since it also removes previous state classes.
    @activeIcon.attr class: "icon #{name} active"

    if @currentState?
      @activeIcon.fadeIn null, => @inactiveIcon.fadeOut 100
    else
      # Current state is only falsey when the view is first loaded.
      @activeIcon.show()
      @inactiveIcon.hide()

    @currentState = name
