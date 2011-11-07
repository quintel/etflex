{ GenericVisualisation } = require 'views/vis/generic'

# IconVisualisation is used when displaying a visualisation which alters it
# appearance by changing from one icon to another. One such example might be
# changing from an icon showing a jar with lots of money, to an empty jar,
# based on the total cost of a scenario.
#
class exports.IconVisualisation extends Backbone.View

  className: 'icon'

  # Creates a new IconVisualisation.
  #
  # You may supply an initial array of acceptable states which don't use
  # callbacks. If you need to trigger an event when the state changes, use
  # addState instead.
  #
  constructor: (states) ->
    super()
    @states or= {}

    @states[key] = null for key in states if _.isArray(states)

  # Adds an visualisation "state". The view will be in only one state at any
  # given moment, and the state indicates how the vis appears to the user. In
  # the above money example, "high" might show an icon with lots of money, and
  # "low" an icon with no money. By calling "setState" within a subclass, you
  # may easily fade between different view states.
  #
  # The very first added state is assumed to be the default.
  #
  # If simply fading between one icon and another does not suffice, you may
  # supply an optional callback function which will be executed as the icon
  # changes:
  #
  # Example:
  #
  #   vis.addState 'high', (vis, jqEl) -> vis.doSomethingElse()
  #
  # Returns self.
  #
  addState: (name, callback) ->
    @states[name] = callback
    @setState name unless @currentState?

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
  setState: (name) ->
    unless @states.hasOwnProperty name
      throw "No such state: #{name}"

    element = $ @el

    element.removeClass(@currentState or '')
    element.addClass(name)

    @currentState = name

    @states[name]? this, element
