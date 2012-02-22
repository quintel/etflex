# A simple helper method which renders a view and replaces the <body> element
# contents with the view's element.
#
# view - The view instance to be rendered and added to the body.
#
module.exports = (view) ->
  body = $ 'body'
  document.title = pageTitle view

  body.html view.render().el

  if $.browser.msie and $.browser.version < 9.0
    showLegacyBrowserWarning()

  body.removeClass 'message'

  module.exports.appendModalDialog()
  view.postRender?()

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
