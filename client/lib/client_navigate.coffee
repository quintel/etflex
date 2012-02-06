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
  target = $(event.target)
  target = target.parent('a') unless target.is 'a'

  href = target.attr 'href'

  if href? and href[0..7] isnt 'http://'
    app.navigate href
    event.preventDefault()
