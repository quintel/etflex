{ GenericProp } = require 'views/props/generic'

# IconProp is used when displaying a prop which alters it appearance by
# changing from one icon to another. One such example might be changing from
# an icon showing a jar with lots of money, to an empty jar, based on the
# total cost of a scenario.
#
class exports.IconProp extends Backbone.View

  className: 'icon-prop'
  fadeType:  'serial'

  render: ->
    @activeIcon   = $ @make 'span', class: 'icon'
    @inactiveIcon = $ @make 'span', class: 'icon'

    if @fadeType is 'drop'
      @activeIcon.css   'top', '0px'
      @inactiveIcon.css 'top', '-192px'

      @$el.css 'overflow', 'hidden'

    @$el.append @activeIcon, @inactiveIcon

    this

  # Sets the view to the given state name. Adds the state name to the main
  # element and executes the callback given when the state was added.
  #
  # Example:
  #
  #   prop.setState 'high'
  #
  # Example:
  #
  #   prop.setState 'low'
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
      if @fadeType is 'parallel'
        @activeIcon.fadeIn 1000
        @inactiveIcon.fadeOut 1000
      else if @fadeType is 'drop'
        # Adds a little randomness to the animation lengths; this means that
        # if multiple icons change simultaneously, the changes don't look
        # quite so "perfect".
        variance     = Math.round(Math.random() * 100) * 3
        activeTime   = 600 + variance
        inactiveTime = 400 + variance

        @activeIcon.show().css(top: '-192px').
          animate(top: '0px', activeTime, 'easeOutBounce')

        @inactiveIcon.animate top: '192px', inactiveTime, =>
          @inactiveIcon.hide()
      else
        @activeIcon.fadeIn 1000, => @inactiveIcon.hide()
    else
      # Current state is only falsey when the view is first loaded.
      if @fadeType is 'drop'
        @activeIcon.show().css('top', '0px')
        @inactiveIcon.hide().css('top', '-192px')
      else
        @activeIcon.show()
        @inactiveIcon.hide()

    @currentState = name