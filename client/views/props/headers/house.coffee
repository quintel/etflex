{ HeaderIcon } = require 'views/props/header_icon'

class exports.HouseProp extends HeaderIcon
  queries: []

  render: ->
    @$el.append '<span class="help"></span>'

    @$el.append '<span class="animation man"></span>'
    @$el.append '<span class="animation cat"></span>'
    @$el.append '<span class="animation girl"></span>'

    super
    @showHelpButton()
    this

  showHelpButton: (fadeTime = 500) =>
    # Prevent the button being hidden if the hideInfo timeout is present.
    window.clearTimeout @infoTimeout if @infoTimeout
    @$('.help').stop().animate opacity: 1, fadeTime
 # Help Texts
  helpHeader: -> "props.house.header"
  helpBody: -> "props.house.body"
