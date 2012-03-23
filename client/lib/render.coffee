# A simple helper method which renders a view and replaces the <body> element
# contents with the view's element.
#
# view - The view instance to be rendered and added to the body.
#
module.exports = (view) ->
  document.title = pageTitle view

  $('#master-content').html view.render().el

  module.exports.enhance()

  module.exports.appendModalDialog()
  view.postRender?()

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
  _.delay refreshRelativeDates, 60000

  # Add an XHR "loading" message displayed to the user when a request is
  # pending.
  unless $('#loading-notifier').length
    loader = $ """
      <div id='loading-notifier'>
        #{ I18n.t 'words.loading' }&hellip;
      </div>
    """

    loader.ajaxStart -> loader.stop().animate bottom:   '0px', 'fast'
    loader.ajaxStop  -> loader.stop().animate bottom: '-37px', 'fast'

    $('body').append loader

  true

# Appends the modal dialog HTML to the page.
module.exports.appendModalDialog = ->
  # Add the modal dialog elements used by Reveal.
  $('body').append $("""
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
