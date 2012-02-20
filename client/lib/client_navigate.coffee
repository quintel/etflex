app = require 'app'

# Intercepts clicks on links to local pages and loads them in the client,
# instead of reloading the applicaion.
#
# It may be used in a view event hash like so:
#
#   { clientNavigate } = require 'lib/client_navigate'
#
#   class exports.MyView extends Backbone.View
#     events:
#       'click a': clientNavigate
#
exports.clientNavigate = (event) ->
  # Pages which don't boot the client should not use JS redirects.
  return true unless app.isBooted

  target = $(event.target)
  target = target.parent('a') unless target.is 'a'

  # Links with data-navigate="noclient" will not use clientNavigate but
  # instead the browser's default behaviour.
  return true if target.attr('data-navigate') is 'noclient'

  href = target.attr 'href'

  if href? and href[0...7] isnt 'http://'
    app.navigate href
    event.preventDefault()
