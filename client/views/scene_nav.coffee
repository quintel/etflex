sceneNavTemplate = require 'templates/scene_nav'

TEMPLATES =
  'info':     require('templates/scene_nav/info')
  'settings': require('templates/scene_nav/settings')
  'user':     require('templates/scene_nav/user')

class exports.SceneNav extends Backbone.View
  id: 'main-nav'

  events:
    'click ul a':   'handleClick'
    'clickoutside': 'deactivate'

  activeItem: null

  render: ->
    $(@el).append sceneNavTemplate
      info:     'Information'
      settings: 'Settings'
      user:     'Log in'

    @pulldown = @$ '.main-nav-pulldown'

    this

  # Handler for the onClick event for each link element.
  #
  # event - The jQuery event triggered during the click.
  #
  handleClick: (event) ->
    parent = $(event.currentTarget).parent('li')

    itemName = switch parent.attr 'id'
      when 'nav-info'     then 'info'
      when 'nav-settings' then 'settings'
      when 'nav-user'     then 'user'

    @activate itemName

    event.preventDefault()

  # Activates an item in the navigation by the key. If the item is already
  # active the menu will be deactivated instead.
  #
  # itemName - The item name, e.g. "info", "settings" for the item which is
  #            being activated.
  #
  activate: (itemName) ->
    if @activeItem is itemName then return @deactivate()
    if @activeItem?            then @itemEl(@activeItem).removeClass('active')

    @itemEl(itemName).addClass('active')
    @pulldown.html(TEMPLATES[ itemName ]()).show()

    # The first and last items overlap the left and right of the menu, so we
    # need to disable the correct border radius so that the menu doesn't look
    # weird.
    radii = if itemName is 'info'
      [ 'addClass', 'removeClass' ]
    else if itemName is 'user'
      [ 'removeClass', 'addClass' ]
    else
      [ 'removeClass', 'removeClass' ]

    @pulldown[radii[0]]('first')
    @pulldown[radii[1]]('last')

    @activeItem = itemName

  # Deactivates the menu by removing the "active" class from the currently
  # active anchor, and hiding the menu.
  #
  deactivate: ->
    @itemEl(@activeItem).removeClass('active')
    @pulldown.hide()

    @activeItem = null

  # Returns the element from the navigation menu for a given section name.
  #
  # itemName - The name of the navigation item element; e.g. "info" or
  #            "settings".
  #
  itemEl: (itemName) ->
    @$ "#nav-#{ itemName }"
