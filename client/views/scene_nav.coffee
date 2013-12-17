app              = require 'app'
api              = require 'lib/api'

sceneNavTemplate = require 'templates/scene_nav'
infoTemplate     = require 'templates/scene_nav/info'
settingsTemplate = require 'templates/scene_nav/settings'

{ showMessage }  = require 'lib/messages'

# ----------------------------------------------------------------------------

# Returns the path to the current ETEngine scenario on ETModel.
#
# scenario - The scenario we want to view on ETModel.
#
urlToScenarioOnETM = (scenario) ->
  # Laptops use a custom URL defined in the settings file
  host = if app.etm_url
    app.etm_url
  else if api.isBeta
    'http://beta.pro.et-model.com'
  else
    'http://pro.et-model.com'

  "#{ host }/scenarios/#{ scenario.get('sessionId') }/load"

# Given an event, returns the name of the item used to trigger the event.
itemNameFromEvent = (event) ->
  $(event.currentTarget).parent('li').attr('id')[4..]

# Renders the contents of the information menu.
renderInfo = ({ model, deactivate }) ->
  elements = $ infoTemplate
    etmURL:   if model? then urlToScenarioOnETM(model)
    help:     I18n.t('navigation.how_to_use')
    about:    I18n.t('navigation.about')
    feedback: I18n.t('navigation.feedback')
    privacy:  I18n.t('navigation.privacy')
    etmodel:  I18n.t('navigation.etmodel')

  elements.find('.start-intro').on 'click', ->
    require('views/tour').start()
    deactivate()
    false

  elements

# Renders the contents of the settings menu.
renderSettings = (nav) ->
  element = $ settingsTemplate
    country:           nav.model.get('country')
    endYear:           nav.model.get('endYear')
    showScore:         nav.model.get('showScore')
    locale:            I18n.locale
    sceneId:           nav.model.get('scene').id
    alternativeLocale: (if I18n.locale == 'nl' then 'en' else 'nl')
    conference:        app.conference

  year = $ '#change-end-year', element
  year.on 'change', -> nav.model.set endYear: year.val()

  country = $ '#change-country', element
  country.on 'change', -> nav.model.set country: country.val()

  showScore = $ '#show-score', element
  showScore.on 'change', ->
    hideOrShow = showScore.is(':checked')
    nav.model.set showScore: hideOrShow
    $('#main-props .score').css('opacity': if hideOrShow then 1 else 0)

  hardReset = $ '.hard-reset', element
  hardReset.on 'click', -> localStorage?.removeItem 'seen-prelaunch'

  element

# SceneNav -------------------------------------------------------------------

class exports.SceneNav extends Backbone.View
  id: 'main-nav'

  events:
    'click ul.scene-nav a':        'handleClick'
    'click .main-nav-pulldown a':  'deactivate'
    'clickoutside':                'deactivate'
    'click ul a[data-modal-key]':  'showModalMessage'

  activeItem: null

  render: ->
    @$el.append sceneNavTemplate(isSignedIn: app.user.isSignedIn)
    @pulldown = @$ '.main-nav-pulldown'

    this

  showModalMessage: (event) ->
    showMessage '', I18n.t($(event.target).attr 'data-modal-key')

    event.preventDefault()
    event.stopPropagation()

  # Handler for the onClick event for each link element.
  #
  # event - The jQuery event triggered during the click.
  #
  handleClick: (event) ->
    @activate itemNameFromEvent(event)
    event.preventDefault()
    event.stopPropagation()

  # active the menu will be deactivated instead.
  #
  # itemName - The item name, e.g. "info", "settings" for the item which is
  #            being activated.
  #
  activate: (itemName) ->
    if @activeItem is itemName then return @deactivate()
    if @activeItem?            then @itemEl(@activeItem).removeClass('active')

    content = switch itemName
      when 'info'     then renderInfo     this
      when 'settings' then renderSettings this

    if content
      @itemEl(itemName).addClass('active')
      @pulldown.html content
      @pulldown.show()

      # The first and last items overlap the left and right of the menu, so we
      # need to disable the correct border radius so that the menu doesn't look
      # weird.
      radii = switch itemName
        when '----'     then [ 'addClass',    'removeClass' ]
        when 'settings' then [ 'removeClass', 'addClass'    ]
        else                 [ 'removeClass', 'removeClass' ]

      @pulldown[radii[0]]('first')
      @pulldown[radii[1]]('last')

      @activeItem = itemName
    else
      @deactivate()

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
