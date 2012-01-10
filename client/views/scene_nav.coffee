api              = require 'lib/api'

sceneNavTemplate = require 'templates/scene_nav'
infoTemplate     = require 'templates/scene_nav/info'
settingsTemplate = require 'templates/scene_nav/settings'
userTemplate     = require 'templates/scene_nav/user'

# ----------------------------------------------------------------------------

# Returns the path to the current ETEngine session on ETModel.
#
# session - The session instance we want to view on ETModel.
#
urlToSessionOnETM = (session) ->
  host = if api.isBeta
    'http://beta.et-model.com'
  else
    'http://et-model.com'

  "#{ host }/scenarios/#{ session.id }/load"

# Renders the contents of the information menu.
renderInfo = ({ model }) ->
  infoTemplate
    etmURL:   urlToSessionOnETM(model.session)
    about:    I18n.t('navigation.about')
    feedback: I18n.t('navigation.feedback')
    privacy:  I18n.t('navigation.privacy')
    etmodel:  I18n.t('navigation.etmodel')

# Renders the contents of the settings menu.
renderSettings = -> settingsTemplate()

# Renders the contents of the user menu.
renderUser = -> userTemplate()

# SceneNav -------------------------------------------------------------------

class exports.SceneNav extends Backbone.View
  id: 'main-nav'

  events:
    'click ul a':   'handleClick'
    'clickoutside': 'deactivate'

  activeItem: null

  render: ->
    $(@el).append sceneNavTemplate
      info:     I18n.t('navigation.info')
      settings: I18n.t('navigation.settings')
      user:     I18n.t('navigation.sign_in')

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

    @pulldown.html switch itemName
      when 'info'     then renderInfo     this
      when 'settings' then renderSettings this
      when 'user'     then renderUser     this

    @pulldown.show()

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
