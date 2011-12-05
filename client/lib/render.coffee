# A simple helper method which renders a view and replaces the <body> element
# contents with the view's element.
#
# view - The view instance to be rendered and added to the body.
#
module.exports = (view) ->
  $('body').html  view.render().el
  $('title').text pageTitle view

  view.postRender?()

  true

# Given a view, returns the page title which shoud be set.
#
# Looks for a "pageTitle" attribute on the view. If it is a function, the
# return value will be used; otherwise the attribute is used verbatim. No
# pageTitle attribute will result in the page title being set to "ETFlex".
#
pageTitle = (view) ->
  unless view.pageTitle? then 'ETFlex' else
    "#{view.pageTitle?() or view.pageTitle} - ETFlex"
