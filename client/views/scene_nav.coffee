app              = require 'app'
api              = require 'lib/api'

sceneNavTemplate = require 'templates/scene_nav'
infoTemplate     = require 'templates/scene_nav/info'
settingsTemplate = require 'templates/scene_nav/settings'
userTemplate     = require 'templates/scene_nav/user'
accountTemplate  = require 'templates/scene_nav/account'

# ----------------------------------------------------------------------------

# Returns the path to the current ETEngine scenario on ETModel.
#
# scenario - The scenario we want to view on ETModel.
#
urlToScenarioOnETM = (scenario) ->
  host = if api.isBeta
    'http://beta.et-model.com'
  else
    'http://et-model.com'

  "#{ host }/scenarios/#{ scenario.get('sessionId') }/load"

# Given an event, returns the name of the item used to trigger the event.
itemNameFromEvent = (event) ->
  $(event.currentTarget).parent('li').attr('id')[4..]

# Renders the contents of the information menu.
renderInfo = ({ model }) ->
  infoTemplate
    etmURL:   urlToScenarioOnETM(model.scenario)
    about:    I18n.t('navigation.about')
    feedback: I18n.t('navigation.feedback')
    privacy:  I18n.t('navigation.privacy')
    etmodel:  I18n.t('navigation.etmodel')

# Renders the contents of the settings menu.
renderSettings = -> settingsTemplate()

# Renders the contents of the user menu.
renderUser = -> userTemplate()

# Renders the contents of the user account menu.
renderAccount = -> accountTemplate()

# SceneNav -------------------------------------------------------------------

class exports.SceneNav extends Backbone.View
  id: 'main-nav'

  events:
    'click ul.scene-nav a':       'handleClick'
    'click .main-nav-pulldown a': 'deactivate'
    'clickoutside':               'deactivate'

  activeItem: null

  render: ->
    @$el.append sceneNavTemplate(isSignedIn: app.isSignedIn)
    @pulldown = @$ '.main-nav-pulldown'

    this

  # Handler for the onClick event for each link element.
  #
  # event - The jQuery event triggered during the click.
  #
  handleClick: (event) ->
    @activate itemNameFromEvent(event)
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
      when 'account'  then renderAccount  this

    @pulldown.show()

    # The first and last items overlap the left and right of the menu, so we
    # need to disable the correct border radius so that the menu doesn't look
    # weird.
    radii = switch itemName
      when 'info'            then [ 'addClass',    'removeClass' ]
      when 'user', 'account' then [ 'removeClass', 'addClass'    ]
      else                        [ 'removeClass', 'removeClass' ]

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
