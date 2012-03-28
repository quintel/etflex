{ LoadingGrowl, ENABLE_GROWL } = require 'views/growl'

# Indicates whether the "refreshRelativeDates" interval has been set up. We
# only want to do this once per page load, otherwise subsequent calls to
# render.enhance() will add additional intervals each time.
datesInitialized = false

# Holds on to the currently rendered view instance. May be nil if the most
# recently displayed page was a static page which used render.enhance.
currentView = null

# A simple helper method which renders a view and replaces the <body> element
# contents with the view's element.
#
# view - The view instance to be rendered and added to the body.
#
module.exports = (view) ->
  # Destruct the old view, if present.
  currentView?.destructor?()

  document.title = pageTitle view

  # Forcefully scroll to the top, otherwise when the page is redrawn we
  # find ourselves at a random position.
  $.scrollTo 0 unless window.location.hash?.length

  $('#master-content').html view.render().el

  module.exports.enhance()

  module.exports.appendModalDialog()
  view.postRender?()

  currentView = view

  true

# A helper method which behaves like render, but acts on the existing page
# elements rather than replacing them.
#
# Used on semi-static pages like the front-page so that we can use Backbone.
#
module.exports.enhance = (view) ->
  if $.browser.msie and $.browser.version < 9.0
    showLegacyBrowserWarning()

  # Schedule another time update in 60s.
  datesInitialized or= _.delay refreshRelativeDates, 60000

  # The body.message class displays a splash page informing the user that the
  # application is being loaded; remove it.
  $('body').removeClass 'message'

  # Add an XHR "loading" message displayed to the user when a request is
  # pending.
  unless $('#loading-notifier').length or not ENABLE_GROWL
    loader = new LoadingGrowl $ """
      <div id='loading-notifier'>
        #{ I18n.t 'words.loading' }&hellip;
      </div>
    """

    $('body').append loader.$el

    loader.$el.ajaxStart loader.show
    loader.$el.ajaxStop  loader.hide

  currentView = null

  true

# Appends the modal dialog HTML to the page.
module.exports.appendModalDialog = ->
  # Add the modal dialog elements used by Reveal.
  $('#master-content').append $("""
    <div id="modal-dialog" class="reveal-modal">
      <div id="modal-content"></div>
      <a class="close-reveal-modal">&#215;</a>
    </div>
  """)

# Given a view, returns the page title which shoud be set.
#
# Looks for a "pageTitle" attribute on the view. If it is a function, the
# return value will be used; otherwise the attribute is used verbatim. No
# pageTitle attribute will result in the page title being set to "ETFlex".
#
pageTitle = (view) ->
  unless view.pageTitle? then 'ETFlex' else
    "#{view.pageTitle?() or view.pageTitle} - ETFlex"

# Users of old browsers should be warned that we don't support them and
# informed that the site may not work correctly.
#
# This message is only shown the on the first visit.
#
showLegacyBrowserWarning = ->
  unless $.cookie 'ignore_eol_browser'
    view = new (require('views/legacy_browser').LegacyBrowser) dismiss: ->
      $.cookie 'ignore_eol_browser', '1', expires: 14, path: '/'

      # If the user moved their mousewheel on the message page, ensure that
      # the view is restored back to the top of the page.
      if (bodyElement = $ 'body').scrollTop() isnt 0
        $('body').scrollTop 0

    $('body').append view.render().el

# Refreshes all relative dates every 60 seconds, except those which are over
# an hour old.
#
# Note that this also queues up the *next* update to occur in 60 seconds.
#
refreshRelativeDates = ->
  now = new Date

  $('.js-relative-date:visible').each (i, element) ->
    element = $ element
    date    = moment element.attr('datetime')

    if now - date.toDate() < 3600000
      element.text date.fromNow()

  # Schedule another update in 60s.
  _.delay refreshRelativeDates, 60000
