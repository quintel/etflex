sceneNavTemplate = require 'templates/scene_nav'

TEMPLATES =
  'info':     require('templates/scene_nav/info')
  'settings': require('templates/scene_nav/settings')
  'user':     require('templates/scene_nav/user')

class exports.SceneNav extends Backbone.View
  id: 'main-nav'
  events: { 'click ul a': 'handleClick' }

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
    console.log "ACTIVATE: #{ itemName }"

    if itemName is @activeItem
      return @deactivate()
    else if @activeItem
      @$('li.active').removeClass 'active'

    @activeItem = itemName
    $(@el).find("#nav-#{ itemName }").addClass('active')

    @pulldown.html TEMPLATES[ itemName ]()
    @pulldown.show()

    if itemName is 'info'
      @pulldown.addClass('first').removeClass('last')
    else if itemName is 'user'
      @pulldown.addClass('last').removeClass('first')
    else
      @pulldown.removeClass('last').removeClass('first')

  # Deactivates the menu by removing the "active" class from the currently
  # active anchor, and hiding the menu.
  #
  deactivate: ->
    console.log "DEACTIVATE"

    @activeItem = null

    @$('li.active').removeClass 'active'
    @pulldown.hide()
