{ HeaderIcon }  = require 'views/props/header_icon'
{ showMessage } = require 'lib/messages'
props           = require 'views/props'

class exports.CarProp extends HeaderIcon
  queries: [ 'number_of_electric_cars' ]

  hurdles: [ 1000000 ]
  states:  [ 'suv', 'eco' ]

  events:
    'click .help': 'showHelp'
    'mouseenter':  'showHelpButton'
    'mouseleave':  'hideHelpButton'

  helpText: 'My thing'

  render: ->
    super
    @$el.append '<span class="help"></span>'
    this

  refresh: ->
    beforeState = @currentState
    super

    if @currentState isnt beforeState
      @showHelpButton 1000
      @infoTimeout = window.setTimeout @hideHelpButton, 4000

  # The Info (?) button
  # -------------------
  #
  # If the prop has some help text defined, add a question mark so that the
  # user may find out more. This is a bit of a hack at the moment to be
  # ready for the 01/02/12 client meeting and will be refactored later.

  showHelpButton: (fadeTime = 500) =>
    # Prevent the button being hidden if the hideInfo timeout is present.
    window.clearTimeout @infoTimeout if @infoTimeout
    @$('.help').stop().animate opacity: 1, fadeTime

  hideHelpButton: =>
    @$('.help').stop().animate opacity: 0, 500
    @infoTimeout = null

  # TODO: this should be moved to Generic
  showHelp: ->
    super 'car', @currentState
