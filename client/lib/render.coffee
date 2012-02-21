# A simple helper method which renders a view and replaces the <body> element
# contents with the view's element.
#
# view - The view instance to be rendered and added to the body.
#
module.exports = (view) ->
  document.title = pageTitle view
  $('body').html(view.render().el).removeClass 'message'

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
