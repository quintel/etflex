# Starts the intro.js tour when the user is on a scenario page.
#
#   tour = require('views/tour')
#   tour.start()
#
# Returns nothing.
exports.start = ->
  tour = introJs()
  tour.setOptions
    jQuerySelector: true
    steps: tourSteps()
    nextLabel: "#{ I18n.t('tour.next') } &rarr;"
    prevLabel: "&larr; #{ I18n.t('tour.back') }"
    skipLabel: I18n.t('tour.skip')
    doneLabel: I18n.t('tour.done')

  tour.onchange(onChange)
  tour.start()

# An array containing each step to be shown to the user
tourSteps = ->
  steps = [{
     element: '#left-inputs'
     intro: I18n.t 'intro.left-controls'
     position: 'right'
   }]

   if $('#theme-header .house').length
     steps.push({
        element: '.world .house'
        intro: I18n.t 'intro.house'
        position: 'right'
     })

   if $('#energy-generation').length
     steps.push({
        element: '#energy-generation'
        intro: I18n.t 'intro.balance'
        position: 'right'
     })

   if $('#scores ol .current').length
     # If the user's current scenario is in the high score table, highlight
     # that as the final tour item.
     highScoreEl = '#scores ol .current'
   else if $('#scores ol li').length
     # Highlight the current top score. We do this rather than showing the
     # whole high score div because it is too tall.
     highScoreEl = '#scores ol li:first-child'
   else
     # Okay, fine. The whole (empty) high score div will do.
     highScoreEl = '#scores'

   steps.push({
     element: '#right-inputs'
     intro: I18n.t 'intro.right-controls'
     position: 'left'
   }, {
     element: '.dashboard'
     intro: I18n.t 'intro.dashboard'
     position: 'top'
   }, {
     element: highScoreEl
     intro: I18n.t 'intro.highscores'
     position: 'top'
   })

   steps

onChange = (target) ->
  isHouse = target && target.className.match(/\bhouse\b/)

  # All of the props *after* the house prop need to have their z-index
  # adjusted, otherwise they disappear when the house step is active.
  $('.world .house').nextAll('.icon-prop').each (i, sibling) ->
    $sibling = $ sibling

    if isHouse is null
      $sibling.css('z-index', '')
    else if $sibling.css('z-index') isnt '9999999'
      $sibling = $sibling.css('z-index', '+=9999999')
