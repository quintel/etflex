{ HeaderIcon }  = require 'views/props/header_icon'
{ showMessage } = require 'lib/messages'
props           = require 'views/props'

class exports.CarProp extends HeaderIcon
  queries: [ 'number_of_electric_cars' ]

  hurdles: [ 1000000 ]
  states:  [ 'suv', 'eco' ]

  events:
    'mouseenter':  'showHelpButton'
    'mouseleave':  'hideHelpButton'

  render: ->
    @$el.append '<span class="help"></span>'

    super
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
  # Can be refactored and moved to headerIcon.

  showHelpButton: (fadeTime = 500) =>
    # Prevent the button being hidden if the hideInfo timeout is present.
    window.clearTimeout @infoTimeout if @infoTimeout
    @$('.help').stop().animate opacity: 1, fadeTime

  hideHelpButton: =>
    @$('.help').stop().animate opacity: 0, 500
    @infoTimeout = null

  # Help Texts
  helpHeader: -> "props.car.name"
  helpBody: -> "props.car.info.#{@currentState}"
